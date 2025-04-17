import 'dart:convert';

import 'package:baato_api/baato_api.dart';
import 'package:baato_maps/src/model/baato_model.dart';

/// Enum representing different types of GeoJSON objects
enum GeoJSONType {
  point,
  multiPoint,
  lineString,
  multiLineString,
  polygon,
  multiPolygon,
  geometryCollection,
  feature,
  featureCollection,
}

/// A class representing GeoJSON data structure
class BaatoGeoJSON {
  final GeoJSONType type;
  final BaatoLayerProperties? properties;
  final dynamic geometry;
  final List<BaatoCoordinate> coordinates;

  BaatoGeoJSON({
    required this.type,
    required this.coordinates,
    this.properties,
    this.geometry,
  });

  /// Convert GeoJSON object to Map
  Map<String, dynamic> toGeoJSON() {
    final Map<String, dynamic> geoJson = {
      'type': type.toString().split('.').last,
    };

    geoJson['coordinates'] =
        coordinates.map((coord) => [coord.longitude, coord.latitude]).toList();

    if (properties != null) {
      geoJson['properties'] = properties!.toJson();
    }

    if (geometry != null) {
      geoJson['geometry'] = geometry;
    }

    return geoJson;
  }

  /// Create GeoJSON object from Map
  static BaatoGeoJSON fromGeoJSON(Map<String, dynamic> json) {
    final typeStr = json['type'] as String;
    final type = GeoJSONType.values.firstWhere(
      (e) => e.toString().split('.').last == typeStr,
      orElse: () => throw FormatException('Invalid GeoJSON type: $typeStr'),
    );

    return BaatoGeoJSON(
      type: type,
      coordinates: json['coordinates']
          .map((coord) => BaatoCoordinate(
                latitude: coord[1],
                longitude: coord[0],
              ))
          .toList(),
      geometry: json['geometry'],
    );
  }

  /// Convert object to JSON string
  String toJSON() => jsonEncode(toGeoJSON());

  /// Create object from JSON string
  static BaatoGeoJSON fromJSON(String source) {
    final Map<String, dynamic> json = jsonDecode(source);
    return fromGeoJSON(json);
  }

  @override
  String toString() {
    return 'BaatoGeoJSON(type: $type, properties: $properties, geometry: $geometry, coordinates: $coordinates)';
  }
}
