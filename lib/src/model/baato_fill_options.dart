import 'package:baato_api/baato_api.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

/// Configuration options for fills (polygons) on the Baato map.
///
/// This class provides a way to customize the appearance and behavior of polygon fills
/// drawn on the map, including properties like opacity, color, outline color, and pattern.
class BaatoFillOptions {
  /// The opacity of the fill as a value between 0 and 1.
  ///
  /// A value of 0 makes the fill completely transparent, while 1 makes it fully opaque.
  final double? fillOpacity;

  /// The color of the fill in hex format (e.g., "#FF0000" for red).
  ///
  /// This determines the interior color of the polygon.
  final String? fillColor;

  /// The color of the fill outline in hex format.
  ///
  /// This determines the color of the polygon's border.
  final String? fillOutlineColor;

  /// The name of a pattern image to use for the fill.
  ///
  /// This allows for textured fills using a predefined pattern.
  final String? fillPattern;

  /// Whether the fill can be dragged to a new position.
  ///
  /// If true, users can move the polygon by dragging it on the map.
  final bool? draggable;

  /// The geometry of the fill, represented as a list of coordinate rings.
  ///
  /// Each ring is a list of coordinates that define a closed shape.
  /// The first ring represents the outer boundary, while subsequent rings
  /// represent holes in the polygon.
  List<List<BaatoCoordinate>>? geometry;

  /// Creates a set of fill configuration options.
  ///
  /// By default, every non-specified field is null, meaning no desire to change
  /// fill defaults or current configuration.
  BaatoFillOptions({
    this.fillOpacity,
    this.fillColor,
    this.fillOutlineColor,
    this.fillPattern,
    this.draggable,
  });

  /// Creates a copy of this BaatoFillOptions with the given fields replaced with new values.
  ///
  /// This method allows for creating a new instance with modified properties
  /// while keeping the original instance unchanged.
  ///
  /// Returns a new [BaatoFillOptions] instance with the specified fields updated.
  BaatoFillOptions copyWith({
    double? fillOpacity,
    String? fillColor,
    String? fillOutlineColor,
    String? fillPattern,
    List<List<BaatoCoordinate>>? geometry,
    bool? draggable,
  }) {
    final fillOptions = BaatoFillOptions(
      fillOpacity: fillOpacity ?? this.fillOpacity,
      fillColor: fillColor ?? this.fillColor,
      fillOutlineColor: fillOutlineColor ?? this.fillOutlineColor,
      fillPattern: fillPattern ?? this.fillPattern,
      draggable: draggable ?? this.draggable,
    );
    fillOptions.geometry = geometry ?? this.geometry;
    return fillOptions;
  }

  /// Converts the fill options to a JSON representation.
  ///
  /// This method transforms the fill options into a map that can be serialized to JSON.
  ///
  /// Returns a [Map] containing the non-null properties of this fill options.
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (fillOpacity != null) json['fillOpacity'] = fillOpacity;
    if (fillColor != null) json['fillColor'] = fillColor;
    if (fillOutlineColor != null) json['fillOutlineColor'] = fillOutlineColor;
    if (fillPattern != null) json['fillPattern'] = fillPattern;
    if (geometry != null) json['geometry'] = geometry;
    if (draggable != null) json['draggable'] = draggable;
    return json;
  }

  /// Creates a BaatoFillOptions instance from a JSON representation.
  ///
  /// This factory method converts a JSON map into fill options,
  /// allowing for deserialization from stored or transmitted data.
  ///
  /// [json] is the map containing the fill options properties.
  ///
  /// Returns a new [BaatoFillOptions] instance.
  factory BaatoFillOptions.fromJson(Map<String, dynamic> json) {
    return BaatoFillOptions(
      fillOpacity: json['fillOpacity'] as double?,
      fillColor: json['fillColor'] as String?,
      fillOutlineColor: json['fillOutlineColor'] as String?,
      fillPattern: json['fillPattern'] as String?,
      draggable: json['draggable'] as bool?,
    );
  }

  /// Converts BaatoFillOptions to MapLibre's FillOptions.
  ///
  /// This method transforms the Baato-specific fill options into the format
  /// expected by the underlying MapLibre library. It also ensures that polygons
  /// are properly closed by adding the first point at the end if necessary.
  ///
  /// [points] is the list of coordinate rings that define the polygon geometry.
  ///
  /// Returns a [FillOptions] object that can be used with MapLibre.
  FillOptions toFillOptions(List<List<BaatoCoordinate>> points) {
    final geometry = points.map((e) {
      final innerGeometries =
          e.map((e) => LatLng(e.latitude, e.longitude)).toList();
      if (innerGeometries.length > 2) {
        if (innerGeometries.first != innerGeometries.last) {
          innerGeometries.add(innerGeometries.first);
        }
      }
      return innerGeometries;
    }).toList();
    return FillOptions(
      fillOpacity: fillOpacity,
      fillColor: fillColor,
      fillOutlineColor: fillOutlineColor,
      fillPattern: fillPattern,
      geometry: geometry,
      draggable: draggable,
    );
  }

  /// Creates a BaatoFillOptions instance from MapLibre's FillOptions.
  ///
  /// This factory method converts MapLibre-specific fill options into the
  /// Baato format, allowing for interoperability between the two APIs.
  ///
  /// [options] is the MapLibre FillOptions to convert.
  ///
  /// Returns a new [BaatoFillOptions] instance.
  factory BaatoFillOptions.fromFillOptions(FillOptions options) {
    final filloption = BaatoFillOptions(
      fillOpacity: options.fillOpacity,
      fillColor: options.fillColor,
      fillOutlineColor: options.fillOutlineColor,
      fillPattern: options.fillPattern,
      draggable: options.draggable,
    );
    filloption.geometry = options.geometry
        ?.map((e) => e
            .map((e) => BaatoCoordinate(
                  latitude: e.latitude,
                  longitude: e.longitude,
                ))
            .toList())
        .toList();
    return filloption;
  }
}
