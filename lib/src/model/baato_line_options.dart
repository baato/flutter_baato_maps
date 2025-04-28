import 'package:baato_maps/baato_maps.dart';

/// Configuration options for line features in Baato maps.
///
/// This class provides properties to customize the appearance and behavior of lines
/// drawn on the map, such as roads, paths, or custom routes.
class BaatoLineOptions {
  /// The display of line endings.
  ///
  /// Possible values: "bevel", "round", "miter"
  final String? lineJoin;

  /// The opacity of the line.
  ///
  /// Range: 0 to 1, where 0 is fully transparent and 1 is fully opaque.
  final double? lineOpacity;

  /// The color of the line.
  ///
  /// Can be any CSS color string.
  final String? lineColor;

  /// The width of the line in pixels.
  final double? lineWidth;

  /// Draws a line casing outside of a line's actual path.
  ///
  /// Value indicates the width of the inner gap.
  final double? lineGapWidth;

  /// The line's offset from its original path.
  ///
  /// Positive values offset the line to the right, negative to the left.
  final double? lineOffset;

  /// The amount to blur the line.
  ///
  /// Higher values increase the blur effect.
  final double? lineBlur;

  /// Name of the image to use for drawing the line.
  final String? linePattern;

  /// Whether the line can be dragged by the user.
  final bool? draggable;

  /// The coordinates that define the line's path.
  List<BaatoCoordinate>? points = [];

  /// Creates a new [BaatoLineOptions] instance.
  BaatoLineOptions({
    this.lineJoin,
    this.lineOpacity,
    this.lineColor,
    this.lineWidth,
    this.lineGapWidth,
    this.lineOffset,
    this.lineBlur,
    this.linePattern,
    this.draggable,
  });

  /// Converts this object to a JSON representation.
  ///
  /// Returns a map containing all non-null properties.
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (lineJoin != null) json['lineJoin'] = lineJoin;
    if (lineOpacity != null) json['lineOpacity'] = lineOpacity;
    if (lineColor != null) json['lineColor'] = lineColor;
    if (lineWidth != null) json['lineWidth'] = lineWidth;
    if (lineGapWidth != null) json['lineGapWidth'] = lineGapWidth;
    if (lineOffset != null) json['lineOffset'] = lineOffset;
    if (lineBlur != null) json['lineBlur'] = lineBlur;
    if (linePattern != null) json['linePattern'] = linePattern;
    if (draggable != null) json['draggable'] = draggable;
    return json;
  }

  /// Creates a copy of this object with the given fields replaced.
  ///
  /// Returns a new [BaatoLineOptions] instance with updated properties.
  BaatoLineOptions copyWith({
    String? lineJoin,
    double? lineOpacity,
    String? lineColor,
    double? lineWidth,
    double? lineGapWidth,
    double? lineOffset,
    double? lineBlur,
    String? linePattern,
    List<BaatoCoordinate>? points,
    bool? draggable,
  }) {
    final lineOptions = BaatoLineOptions(
      lineJoin: lineJoin ?? this.lineJoin,
      lineOpacity: lineOpacity ?? this.lineOpacity,
      lineColor: lineColor ?? this.lineColor,
      lineWidth: lineWidth ?? this.lineWidth,
      lineGapWidth: lineGapWidth ?? this.lineGapWidth,
      lineOffset: lineOffset ?? this.lineOffset,
      lineBlur: lineBlur ?? this.lineBlur,
      linePattern: linePattern ?? this.linePattern,
      draggable: draggable ?? this.draggable,
    );
    lineOptions.points = points ?? this.points;
    return lineOptions;
  }

  /// Converts this object to a [LineOptions] instance.
  ///
  /// Takes a list of [BaatoCoordinate] points and converts them to the format
  /// required by the underlying map implementation.
  LineOptions toLineOptions(List<BaatoCoordinate> points) {
    return LineOptions(
      lineJoin: lineJoin,
      lineOpacity: lineOpacity,
      lineColor: lineColor,
      lineWidth: lineWidth,
      lineGapWidth: lineGapWidth,
      lineOffset: lineOffset,
      lineBlur: lineBlur,
      linePattern: linePattern,
      geometry: points.map((e) => LatLng(e.latitude, e.longitude)).toList(),
      draggable: draggable,
    );
  }

  /// Creates a [BaatoLineOptions] instance from a JSON map.
  ///
  /// Used for deserializing line options from storage or API responses.
  factory BaatoLineOptions.fromJson(Map<String, dynamic> json) {
    return BaatoLineOptions(
      lineJoin: json['lineJoin'] as String?,
      lineOpacity: json['lineOpacity'] as double?,
      lineColor: json['lineColor'] as String?,
      lineWidth: json['lineWidth'] as double?,
      lineGapWidth: json['lineGapWidth'] as double?,
      lineOffset: json['lineOffset'] as double?,
      lineBlur: json['lineBlur'] as double?,
      linePattern: json['linePattern'] as String?,
      draggable: json['draggable'] as bool?,
    );
  }

  /// Creates a [BaatoLineOptions] instance from a [LineOptions] object.
  ///
  /// Converts from the underlying map implementation's line options to Baato's format.
  factory BaatoLineOptions.fromLineOptions(LineOptions options) {
    final lineOptions = BaatoLineOptions(
      lineJoin: options.lineJoin,
      lineOpacity: options.lineOpacity,
      lineColor: options.lineColor,
      lineWidth: options.lineWidth,
      lineGapWidth: options.lineGapWidth,
      lineOffset: options.lineOffset,
      lineBlur: options.lineBlur,
      linePattern: options.linePattern,
      draggable: options.draggable,
    );
    lineOptions.points = options.geometry
        ?.map((e) => BaatoCoordinate(
              latitude: e.latitude,
              longitude: e.longitude,
            ))
        .toList();
    return lineOptions;
  }
}
