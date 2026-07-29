import 'package:maplibre_gl/maplibre_gl.dart';

/// A [LayerProperties] that forwards only the properties its delegate set.
///
/// Since `maplibre_gl` 0.26.0, [MapLibreMapController.setLayerProperties]
/// serialises with `skipNulls: false`. A partially-populated
/// [LayerProperties] — the normal way to express "change just this one
/// property" — is therefore sent with every *unset* property as an explicit
/// null, and the platform side applies those nulls to the live layer.
///
/// On an annotation layer that is destructive rather than merely wasteful: it
/// clears the data-driven expressions the annotation manager installed
/// (`["get", "iconImage"]`, `["get", "iconRotate"]`, `text-font`,
/// `symbol-sort-key`, `icon-allow-overlap`, …). With `icon-image` cleared no
/// feature on the layer has an icon left to draw, so every symbol on it
/// disappears — not just the one being restyled.
///
/// Wrapping the delegate discards the caller's `skipNulls` and keeps the
/// update genuinely partial.
///
/// ```dart
/// await controller.setLayerProperties(
///   layerId,
///   PartialLayerProperties(SymbolLayerProperties(iconSize: expression)),
/// );
/// ```
class PartialLayerProperties implements LayerProperties {
  /// Wraps [delegate] so only the properties it actually sets are sent.
  const PartialLayerProperties(this.delegate);

  /// The properties to send. Its unset fields are omitted rather than nulled.
  final LayerProperties delegate;

  @override
  Map<String, dynamic> toJson({bool skipNulls = true}) =>
      delegate.toJson(skipNulls: true);
}
