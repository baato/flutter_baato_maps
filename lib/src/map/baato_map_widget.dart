import 'dart:math';

import 'package:baato_api/baato_api.dart';
import 'package:baato_maps/src/model/baato_map_feature.dart';
import 'package:baato_maps/src/model/baato_camera_position.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:baato_maps/src/map/baato_map_controller.dart';

/// A widget that displays a Baato map.
///
/// This widget provides a customizable map interface with various interaction capabilities
/// such as tapping, long-pressing, and location tracking.
class BaatoMapWidget extends StatefulWidget {
  /// The initial geographic position of the map's center.
  final BaatoCoordinate initialPosition;

  /// The initial zoom level of the map.
  /// Higher values zoom in closer to the map.
  final double initialZoom;

  /// The initial map style URL to use.
  /// Defaults to Stadia Maps' outdoors style.
  final String initialStyle;

  /// Whether to show the user's current location on the map.
  final bool myLocationEnabled;

  /// List of layer ID prefixes to identify POI (Points of Interest) layers.
  /// Used for feature detection when tapping on the map.
  final List<String> poiLayerContainIds;

  /// Whether to enable detection of map features when interacting with the map.
  final bool enableLayerDetection;

  /// Callback that is called when the map is created and ready to use.
  final Function(BaatoMapController)? onMapCreated;

  /// Callback that is called when the user taps on the map.
  /// Provides the screen point, geographic coordinate, and any detected map features.
  final void Function(Point<double>, BaatoCoordinate, List<BaatoMapFeature>)?
      onTap;

  /// Callback that is called when the user long-presses on the map.
  /// Provides the screen point, geographic coordinate, and any detected map features.
  final void Function(Point<double>, BaatoCoordinate, List<BaatoMapFeature>)?
      onLongPress;

  /// Which gestures should be consumed by the map.
  ///
  /// It is possible for other gesture recognizers to be competing with the map on pointer
  /// events, e.g if the map is inside a [ListView] the [ListView] will want to handle
  /// vertical drags. The map will claim gestures that are recognized by any of the
  /// recognizers on this list.
  ///
  /// When this set is empty or null, the map will only handle pointer events for gestures that
  /// were not claimed by any other gesture recognizer.
  final Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers;

  /// Callback for when the map is clicked.
  /// This is a direct pass-through to the underlying MapLibre map.
  final OnMapClickCallback? onMapClick;

  /// Callback for when the map is long-clicked.
  /// This is a direct pass-through to the underlying MapLibre map.
  final OnMapClickCallback? onMapLongClick;

  /// While the `myLocationEnabled` property is set to `true`, this method is
  /// called whenever a new location update is received by the map view.
  final OnUserLocationUpdated? onUserLocationUpdated;

  /// Called when the map's camera no longer follows the physical device location, e.g. because the user moved the map
  final OnCameraTrackingDismissedCallback? onCameraTrackingDismissed;

  /// Called when the location tracking mode changes
  final OnCameraTrackingChangedCallback? onCameraTrackingChanged;

  // Called when camera movement has ended.
  final OnCameraIdleCallback? onCameraIdle;

  /// Called when map view is entering an idle state, and no more drawing will
  /// be necessary until new data is loaded or there is some interaction with
  /// the map.
  /// * No camera transitions are in progress
  /// * All currently requested tiles have loaded
  /// * All fade/transition animations have completed
  final OnMapIdleCallback? onMapIdle;

  /// Creates a BaatoMapWidget with the specified parameters.
  ///
  /// The [initialPosition] parameter is required and specifies the initial center point of the map.
  /// Other parameters are optional and provide additional customization of the map's behavior.
  const BaatoMapWidget({
    super.key,
    required this.initialPosition,
    this.initialZoom = 10.0,
    this.initialStyle = 'https://tiles.stadiamaps.com/styles/outdoors.json',
    this.myLocationEnabled = false,
    this.poiLayerContainIds = const ["Poi", "BusStop"],
    this.enableLayerDetection = true,
    this.onMapCreated,
    this.onTap,
    this.onLongPress,
    this.gestureRecognizers,
    this.onMapClick,
    this.onMapLongClick,
    this.onUserLocationUpdated,
    this.onCameraTrackingDismissed,
    this.onCameraTrackingChanged,
    this.onCameraIdle,
    this.onMapIdle,
  });

  @override
  State<BaatoMapWidget> createState() => _BaatoMapWidgetState();
}

/// The state for the BaatoMapWidget.
///
/// Manages the map controller and handles map interactions.
class _BaatoMapWidgetState extends State<BaatoMapWidget> {
  /// The controller for the Baato map.
  late BaatoMapController _baatoController;

  /// List of POI layer IDs detected in the map style.
  List<String> poiLayers = [];

  @override
  void initState() {
    _baatoController = BaatoMapController(widget.initialStyle);

    super.initState();
  }

  @override
  void dispose() {
    _baatoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: _baatoController.styleManager.styleNotifier,
      builder: (context, style, child) {
        final lastCameraPosition = null;
        final cameraPosition = CameraPosition(
          target: LatLng(
            lastCameraPosition?.target.latitude ??
                widget.initialPosition.latitude,
            lastCameraPosition?.target.longitude ??
                widget.initialPosition.longitude,
          ),
          zoom: lastCameraPosition?.zoom ?? widget.initialZoom,
        );
        return MapLibreMap(
          key: ValueKey(style),
          initialCameraPosition: cameraPosition,
          styleString: style,
          myLocationEnabled: widget.myLocationEnabled,
          onMapCreated: (controller) async {
            await _baatoController.setController(controller);
            if (widget.enableLayerDetection) {
              await findPOILayers();
            }
            widget.onMapCreated?.call(_baatoController);
          },
          onMapClick: (point, latLng) async {
            final List<BaatoMapFeature> features =
                widget.enableLayerDetection ? (await _queryPOI(point)) : [];
            widget.onTap?.call(
              point,
              BaatoCoordinate(
                latitude: latLng.latitude,
                longitude: latLng.longitude,
              ),
              features,
            );
          },
          onMapLongClick: (point, latLng) async {
            final List<BaatoMapFeature> features =
                widget.enableLayerDetection ? await _queryPOI(point) : [];
            widget.onLongPress?.call(
              point,
              BaatoCoordinate(
                latitude: latLng.latitude,
                longitude: latLng.longitude,
              ),
              features,
            );
          },
          onUserLocationUpdated: widget.onUserLocationUpdated,
          onCameraTrackingChanged: widget.onCameraTrackingChanged,
          onCameraTrackingDismissed: widget.onCameraTrackingDismissed,
          onCameraIdle: () {
            final position = _baatoController.rawController?.cameraPosition;
            if (position != null) {
              _baatoController.cameraManager?.setLastCameraPosition(
                BaatoCameraPosition(
                  target: BaatoCoordinate(
                    latitude: position.target.latitude,
                    longitude: position.target.longitude,
                  ),
                ),
              );
            }
            _baatoController.rawController?.invalidateAmbientCache();
            widget.onCameraIdle?.call();
          },
          onMapIdle: widget.onMapIdle,
          gestureRecognizers: widget.gestureRecognizers,
        );
      },
    );
  }

  /// Queries the map for features at the given screen point.
  ///
  /// Returns a list of [BaatoMapFeature] objects representing the map features
  /// found at the specified point.
  Future<List<BaatoMapFeature>> _queryPOI(Point<double> point) async {
    final mapLibreController = _baatoController.rawController;
    if (mapLibreController == null) return [];

    List<dynamic> mapFeatures = await mapLibreController.queryRenderedFeatures(
      point,
      poiLayers,
      null,
    );

    final features = mapFeatures
        .map(
          (e) => BaatoMapFeature.fromMapFeature(e, null),
        ) //TODO: Add user location
        .toList();

    return features;
  }

  /// Finds and stores POI layers in the current map style.
  ///
  /// This method queries the map for all layer IDs and filters them based on
  /// the prefixes specified in [widget.poiLayerContainIds].
  Future<void> findPOILayers() async {
    this.poiLayers = [];
    final mapLibreController = _baatoController.rawController;
    if (mapLibreController == null) return;

    List<String> layers = (await mapLibreController.getLayerIds())
        .map((e) => e.toString())
        .toList();

    List<String> poiLayers = layers
        .where(
          (layer) => widget.poiLayerContainIds.any(
            (text) => layer.startsWith(text),
          ),
        )
        .toList();

    if (poiLayers.isEmpty) {
      return;
    }

    this.poiLayers = poiLayers;
  }
}
