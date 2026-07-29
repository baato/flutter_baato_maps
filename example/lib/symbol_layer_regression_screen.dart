import 'dart:async';
import 'dart:math';

import 'package:baato_maps/baato_maps.dart';
import 'package:flutter/material.dart';

/// Regression case for the symbol layer wipe fixed in 2.0.1.
///
/// Three icon-only symbols share one annotation layer: two static pins and a
/// third that moves and rotates on a repeating timer. On top of that the
/// screen applies a zoom-based `icon-size` expression to the symbol layer —
/// the ingredient that actually triggers the bug. Adding and updating symbols
/// alone is harmless.
///
/// Since `maplibre_gl` 0.26.0, [MapLibreMapController.setLayerProperties]
/// serialises with `skipNulls: false`, so a partially-populated
/// [SymbolLayerProperties] arrives at the platform side with every unset
/// property as an explicit null. Applying those nulls clears the annotation
/// layer's data-driven `icon-image` expression, and with no icon to draw every
/// symbol on the layer vanishes — the static pins along with the animated one.
///
/// Use the toggle to see both paths:
/// - **Safe** — `sourceAndLayerManager.updateLayerProperties()`, which wraps
///   the properties so only `icon-size` is sent. All three stay visible while
///   the third animates.
/// - **Unsafe** — the raw `libreController.setLayerProperties()` call that
///   consumers reach for. Reproduces the bug: everything disappears.
///
/// The damage does not heal on its own — a later partial update sets only the
/// property it carries, so `icon-image` stays null. Switching back to the safe
/// path therefore rebuilds the layer first.
class SymbolLayerRegressionScreen extends StatefulWidget {
  const SymbolLayerRegressionScreen({super.key});

  @override
  State<SymbolLayerRegressionScreen> createState() =>
      _SymbolLayerRegressionScreenState();
}

class _SymbolLayerRegressionScreenState
    extends State<SymbolLayerRegressionScreen> {
  static final _center = BaatoCoordinate(latitude: 27.7172, longitude: 85.3240);
  static const _iconImage = 'baato_marker';
  static const _animationInterval = Duration(seconds: 1);
  static const _staticOffsetDegrees = 0.004;
  static const _orbitRadiusDegrees = 0.002;
  static const _stepsPerOrbit = 36;

  /// Camera-and-data expression for `icon-size`, the property under test.
  /// Each stop scales the symbol's own `iconSize`, so it has to stay
  /// data-driven — exactly the kind of expression a null wipe destroys.
  static const _zoomBasedIconSize = <dynamic>[
    'interpolate',
    ['linear'],
    ['zoom'],
    11,
    [
      '*',
      0.7,
      ['get', 'iconSize'],
    ],
    15,
    ['get', 'iconSize'],
    18,
    [
      '*',
      1.3,
      ['get', 'iconSize'],
    ],
  ];

  final BaatoMapController _controller = BaatoMapController();

  Symbol? _animatedSymbol;
  Timer? _timer;
  int _step = 0;
  bool _useSafePath = true;
  String _status = 'Waiting for style…';

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _onStyleLoaded() async {
    _setStatus('Style loaded — adding symbols…');

    // BaatoMap registers "baato_marker" in its own style-loaded handler; give
    // that a turn before the first symbol references the image.
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    try {
      await _addStaticSymbols();
      await _addAnimatedSymbol();
      // Mirrors how the consuming app configures the layer, and keeps
      // collision detection from muddying the count when the animated symbol
      // passes close to a static pin.
      await _setIconOverlapAllowed(true);
      await _applyZoomBasedIconSize();
    } on Exception catch (e) {
      // Nothing awaits this callback, so an uncaught throw would leave the
      // screen sitting on a stale status with no clue why.
      _setStatus('Setup failed: $e');
      return;
    }

    _timer?.cancel();
    _timer = Timer.periodic(_animationInterval, (_) => _animate());
  }

  /// Two static pins, icon only — no textField anywhere in this screen.
  Future<void> _addStaticSymbols() async {
    for (final offset in const [-_staticOffsetDegrees, _staticOffsetDegrees]) {
      await _controller.markerManager.addMarker(
        BaatoSymbolOption(
          geometry: BaatoCoordinate(
            latitude: _center.latitude + offset,
            longitude: _center.longitude,
          ),
          iconImage: _iconImage,
          iconSize: 1.2,
          iconOffset: Offset.zero,
        ),
      );
    }
  }

  Future<void> _addAnimatedSymbol() async {
    _animatedSymbol = await _controller.markerManager.addMarker(
      BaatoSymbolOption(
        geometry: _center,
        iconImage: _iconImage,
        iconSize: 1.2,
        iconRotate: 0,
        iconOffset: Offset.zero,
      ),
    );
  }

  /// Applies the zoom-based `icon-size` expression by whichever path is
  /// currently selected. This is the call that breaks the layer when it is
  /// allowed to serialise its unset properties as nulls.
  Future<void> _applyZoomBasedIconSize() async {
    final layerId = _controller.libreController?.symbolManager?.layerIds.first;
    if (layerId == null) {
      _setStatus('No symbol layer yet');
      return;
    }

    if (_useSafePath) {
      await _controller.sourceAndLayerManager.updateLayerProperties(
        layerId,
        const BaatoSymbolLayerProperties(iconSize: _zoomBasedIconSize),
      );
      _setStatus('Safe path — all three symbols should stay visible');
      return;
    }

    await _controller.libreController?.setLayerProperties(
      layerId,
      const SymbolLayerProperties(iconSize: _zoomBasedIconSize),
    );
    _setStatus('Unsafe path — icon-image nulled, every symbol should vanish');
  }

  Future<void> _animate() async {
    final symbol = _animatedSymbol;
    if (symbol == null || !mounted) return;

    _step++;
    final angle = 2 * pi * (_step % _stepsPerOrbit) / _stepsPerOrbit;

    try {
      await _controller.markerManager.updateSymbol(
        symbol,
        SymbolOptions(
          geometry: LatLng(
            _center.latitude + _orbitRadiusDegrees * cos(angle),
            _center.longitude + _orbitRadiusDegrees * sin(angle),
          ),
          iconRotate: angle * 180 / pi,
        ),
      );
    } on Exception catch (e) {
      _timer?.cancel();
      _setStatus('Update failed: $e');
    }
  }

  void _setStatus(String status) {
    if (!mounted) return;
    setState(() => _status = status);
  }

  Future<void> _togglePath(bool useSafePath) async {
    setState(() => _useSafePath = useSafePath);
    // Nulling out icon-image is not self-healing: the safe path only sends
    // icon-size, so switching back would leave the layer without an icon
    // expression and the symbols still invisible. Rebuild first so the A/B
    // comparison is repeatable.
    if (useSafePath) await _rebuildSymbolLayer();
    await _applyZoomBasedIconSize();
  }

  Future<void> _setIconOverlapAllowed(bool allowed) async {
    final libreController = _controller.libreController;
    if (libreController == null) return;

    await libreController.setSymbolIconAllowOverlap(allowed);
    await libreController.setSymbolIconIgnorePlacement(allowed);
  }

  /// Restores the annotation layer's default data-driven expressions.
  ///
  /// Toggling an overlap flag is the only public trigger for the annotation
  /// manager's internal layer rebuild, which re-adds the layer from
  /// `allLayerProperties` — icon-image included. Both writes are needed
  /// because the manager ignores a set to the value it already holds.
  Future<void> _rebuildSymbolLayer() async {
    await _setIconOverlapAllowed(false);
    await _setIconOverlapAllowed(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BaatoMap(
            controller: _controller,
            initialPosition: _center,
            initialZoom: 14.0,
            style: BaatoMapStyle.defaultStyle,
            myLocationEnabled: false,
            onStyleLoadedCallback: _onStyleLoaded,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Symbol layer regression',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(_status),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Use safe partial update'),
                        value: _useSafePath,
                        onChanged: _togglePath,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
