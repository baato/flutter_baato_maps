import 'package:baato_api/baato_api.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

/// Configuration options for circles on the Baato map.
///
/// This class provides a way to customize the appearance and behavior of circles
/// drawn on the map, including properties like radius, color, opacity, and stroke.
class BaatoCircleOptions {
  /// The geographical coordinate for the center of the circle.
  ///
  /// This determines where on the map the circle will be positioned.
  final BaatoCoordinate center;

  /// The radius of the circle in pixels.
  ///
  /// This determines the size of the circle on the map.
  final double circleRadius;

  /// The color of the circle in hex format (e.g., "#FF0000" for red).
  ///
  /// This determines the fill color of the circle.
  final String? circleColor;

  /// The amount of blur applied to the circle, in pixels.
  ///
  /// Higher values create a more feathered, soft edge.
  final double? circleBlur;

  /// The opacity of the circle as a value between 0 and 1.
  ///
  /// A value of 0 makes the circle completely transparent, while 1 makes it fully opaque.
  final double? circleOpacity;

  /// The width of the circle's stroke in pixels.
  ///
  /// This determines the thickness of the circle's outline.
  final double? circleStrokeWidth;

  /// The color of the circle's stroke in hex format.
  ///
  /// This determines the color of the circle's outline.
  final String? circleStrokeColor;

  /// The opacity of the circle's stroke as a value between 0 and 1.
  ///
  /// A value of 0 makes the stroke completely transparent, while 1 makes it fully opaque.
  final double? circleStrokeOpacity;

  /// Whether the circle can be dragged to a new position.
  ///
  /// If true, users can move the circle by dragging it on the map.
  final bool? draggable;

  /// Creates a set of circle configuration options.
  ///
  /// By default, every non-specified field is null, meaning no desire to change
  /// circle defaults or current configuration.
  ///
  /// [center] is required and specifies the geographical position of the circle.
  /// [circleRadius] is required and specifies the size of the circle in pixels.
  const BaatoCircleOptions({
    required this.center,
    required this.circleRadius,
    this.circleColor,
    this.circleBlur,
    this.circleOpacity,
    this.circleStrokeWidth,
    this.circleStrokeColor,
    this.circleStrokeOpacity,
    this.draggable,
  });

  /// Converts BaatoCircleOptions to MapLibre's CircleOptions.
  ///
  /// This method transforms the Baato-specific circle options into the format
  /// expected by the underlying MapLibre library.
  ///
  /// Returns a [CircleOptions] object that can be used with MapLibre.
  CircleOptions toCircleOptions() {
    return CircleOptions(
      geometry: LatLng(center.latitude, center.longitude),
      circleRadius: circleRadius,
      circleColor: circleColor,
      circleBlur: circleBlur,
      circleOpacity: circleOpacity,
      circleStrokeWidth: circleStrokeWidth,
      circleStrokeColor: circleStrokeColor,
      circleStrokeOpacity: circleStrokeOpacity,
      draggable: draggable,
    );
  }

  /// Creates a copy of this BaatoCircleOptions with the given fields replaced with new values.
  ///
  /// This method allows for creating a new instance with modified properties
  /// while keeping the original instance unchanged.
  ///
  /// Returns a new [BaatoCircleOptions] instance with the specified fields updated.
  BaatoCircleOptions copyWith({
    BaatoCoordinate? center,
    double? circleRadius,
    String? circleColor,
    double? circleBlur,
    double? circleOpacity,
    double? circleStrokeWidth,
    String? circleStrokeColor,
    double? circleStrokeOpacity,
    bool? draggable,
  }) {
    return BaatoCircleOptions(
      center: center ?? this.center,
      circleRadius: circleRadius ?? this.circleRadius,
      circleColor: circleColor ?? this.circleColor,
      circleBlur: circleBlur ?? this.circleBlur,
      circleOpacity: circleOpacity ?? this.circleOpacity,
      circleStrokeWidth: circleStrokeWidth ?? this.circleStrokeWidth,
      circleStrokeColor: circleStrokeColor ?? this.circleStrokeColor,
      circleStrokeOpacity: circleStrokeOpacity ?? this.circleStrokeOpacity,
      draggable: draggable ?? this.draggable,
    );
  }

  /// Creates a BaatoCircleOptions instance from MapLibre's CircleOptions.
  ///
  /// This factory method converts MapLibre-specific circle options into the
  /// Baato format, allowing for interoperability between the two APIs.
  ///
  /// [circleOptions] is the MapLibre CircleOptions to convert.
  ///
  /// Returns a new [BaatoCircleOptions] instance.
  /// Throws an [ArgumentError] if the input CircleOptions doesn't have a geometry.
  factory BaatoCircleOptions.fromCircleOptions(CircleOptions circleOptions) {
    if (circleOptions.geometry == null) {
      throw ArgumentError('CircleOptions must have a geometry');
    }
    return BaatoCircleOptions(
      center: BaatoCoordinate(
        latitude: circleOptions.geometry!.latitude,
        longitude: circleOptions.geometry!.longitude,
      ),
      circleRadius: circleOptions.circleRadius ?? 0,
      circleColor: circleOptions.circleColor,
      circleBlur: circleOptions.circleBlur,
      circleOpacity: circleOptions.circleOpacity,
      circleStrokeWidth: circleOptions.circleStrokeWidth,
      circleStrokeColor: circleOptions.circleStrokeColor,
      circleStrokeOpacity: circleOptions.circleStrokeOpacity,
      draggable: circleOptions.draggable,
    );
  }
}
