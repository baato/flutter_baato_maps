import 'package:baato_api/baato_api.dart';
import 'package:baato_maps/src/model/baato_layer_properties.dart';

/// Abstract base class for GeoJSON features.
///
/// This class provides the foundation for all GeoJSON feature types in the Baato API.
/// It includes common properties and methods for working with GeoJSON data.
abstract class BaatoGeoJson {
  /// The properties associated with this GeoJSON feature.
  final BaatoLayerProperties? properties;

  /// Creates a new [BaatoGeoJson] instance.
  ///
  /// [properties] is an optional map of properties associated with the feature.
  BaatoGeoJson({this.properties});

  /// Converts this feature to a GeoJSON-compliant map.
  ///
  /// Returns a map that follows the GeoJSON specification.
  Map<String, dynamic> toGeoJson({
    bool wrappedWithFeatureCollection = false,
  });
}

/// A GeoJSON Point feature.
///
/// Represents a single point location with latitude and longitude coordinates.
class BaatoPointGeoJson extends BaatoGeoJson {
  /// The latitude coordinate of the point.
  final double latitude;

  /// The longitude coordinate of the point.
  final double longitude;

  /// Creates a new [BaatoPointGeoJson] instance.
  ///
  /// [latitude] is the latitude coordinate.
  /// [longitude] is the longitude coordinate.
  /// [properties] is an optional map of properties associated with the point.
  BaatoPointGeoJson({
    required this.latitude,
    required this.longitude,
    super.properties,
  });

  @override
  Map<String, dynamic> toGeoJson({
    bool wrappedWithFeatureCollection = false,
  }) {
    final featureJson = {
      'type': 'Feature',
      'geometry': {
        'type': 'Point',
        'coordinates': [longitude, latitude]
      },
      'properties': properties != null ? properties?.toJson() : {},
    };

    if (wrappedWithFeatureCollection) {
      return {
        'type': 'FeatureCollection',
        'features': [featureJson]
      };
    }

    return featureJson;
  }
}

/// A GeoJSON MultiPoint feature.
///
/// Represents multiple point locations as a single feature.
class BaatoMultiPointGeoJson extends BaatoGeoJson {
  /// The list of points in this MultiPoint feature.
  final List<BaatoCoordinate> points;

  /// Creates a new [BaatoMultiPointGeoJson] instance.
  ///
  /// [points] is the list of points to include in the feature.
  /// [properties] is an optional map of properties associated with the feature.
  BaatoMultiPointGeoJson({required this.points, super.properties});

  @override
  Map<String, dynamic> toGeoJson({
    bool wrappedWithFeatureCollection = false,
  }) {
    final featureJson = {
      'type': 'Feature',
      'geometry': {
        'type': 'MultiPoint',
        'coordinates':
            points.map((point) => [point.longitude, point.latitude]).toList()
      },
      'properties': properties != null ? properties?.toJson() : {},
    };

    if (wrappedWithFeatureCollection) {
      return {
        'type': 'FeatureCollection',
        'features': [featureJson]
      };
    }

    return featureJson;
  }
}

/// A GeoJSON LineString feature.
///
/// Represents a sequence of points connected by straight line segments.
class BaatoLineGeoJson extends BaatoGeoJson {
  /// The list of points that form the line.
  final List<BaatoCoordinate> points;

  /// Creates a new [BaatoLineGeoJson] instance.
  ///
  /// [points] is the list of points that form the line.
  /// [properties] is an optional map of properties associated with the line.
  BaatoLineGeoJson({required this.points, super.properties});

  @override
  Map<String, dynamic> toGeoJson({
    bool wrappedWithFeatureCollection = false,
  }) {
    final featureJson = {
      'type': 'Feature',
      'geometry': {
        'type': 'LineString',
        'coordinates':
            points.map((point) => [point.longitude, point.latitude]).toList()
      },
      'properties': properties != null ? properties?.toJson() : {},
    };

    if (wrappedWithFeatureCollection) {
      return {
        'type': 'FeatureCollection',
        'features': [featureJson]
      };
    }

    return featureJson;
  }
}

/// A GeoJSON MultiLineString feature.
///
/// Represents multiple LineString features as a single feature.
class BaatoMultiLineGeoJson extends BaatoGeoJson {
  /// The list of lines in this MultiLineString feature.
  final List<List<BaatoCoordinate>> lines;

  /// Creates a new [BaatoMultiLineGeoJson] instance.
  ///
  /// [lines] is the list of lines to include in the feature.
  /// [properties] is an optional map of properties associated with the feature.
  BaatoMultiLineGeoJson({required this.lines, super.properties});

  @override
  Map<String, dynamic> toGeoJson({
    bool wrappedWithFeatureCollection = false,
  }) {
    final featureJson = {
      'type': 'Feature',
      'geometry': {
        'type': 'MultiLineString',
        'coordinates': lines
            .map((line) =>
                line.map((point) => [point.longitude, point.latitude]).toList())
            .toList()
      },
      'properties': properties != null ? properties?.toJson() : {},
    };

    if (wrappedWithFeatureCollection) {
      return {
        'type': 'FeatureCollection',
        'features': [featureJson]
      };
    }

    return featureJson;
  }
}

/// A GeoJSON Polygon feature.
///
/// Represents a closed shape defined by a sequence of points.
class BaatoPolygonGeoJson extends BaatoGeoJson {
  /// The coordinates that define the polygon's shape.
  final List<List<BaatoCoordinate>> coordinates;

  /// Creates a new [BaatoPolygonGeoJson] instance.
  ///
  /// [coordinates] is the list of coordinate rings that define the polygon.
  /// [properties] is an optional map of properties associated with the polygon.
  BaatoPolygonGeoJson({required this.coordinates, super.properties});

  @override
  Map<String, dynamic> toGeoJson({
    bool wrappedWithFeatureCollection = false,
  }) {
    final featureJson = {
      'type': 'Feature',
      'geometry': {
        'type': 'Polygon',
        'coordinates': coordinates
            .map((point) => point
                .map((point) => [point.longitude, point.latitude])
                .toList())
            .toList()
      },
      'properties': properties != null ? properties?.toJson() : {},
    };

    if (wrappedWithFeatureCollection) {
      return {
        'type': 'FeatureCollection',
        'features': [featureJson]
      };
    }

    return featureJson;
  }
}

/// A GeoJSON MultiPolygon feature.
///
/// Represents multiple Polygon features as a single feature.
class BaatoMultiPolygonGeoJson extends BaatoGeoJson {
  /// The list of polygons in this MultiPolygon feature.
  final List<List<List<BaatoCoordinate>>> coordinates;

  /// Creates a new [BaatoMultiPolygonGeoJson] instance.
  ///
  /// [coordinates] is the list of polygons to include in the feature.
  /// [properties] is an optional map of properties associated with the feature.
  BaatoMultiPolygonGeoJson({
    required this.coordinates,
    super.properties,
  });

  @override
  Map<String, dynamic> toGeoJson({
    bool wrappedWithFeatureCollection = false,
  }) {
    final featureJson = {
      'type': 'Feature',
      'geometry': {
        'type': 'MultiPolygon',
        'coordinates': coordinates
            .map((point) => point
                .map((point) => point
                    .map((point) => [point.longitude, point.latitude])
                    .toList())
                .toList())
            .toList()
      },
      'properties': properties != null ? properties?.toJson() : {},
    };

    if (wrappedWithFeatureCollection) {
      return {
        'type': 'FeatureCollection',
        'features': [featureJson]
      };
    }

    return featureJson;
  }
}

/// A GeoJSON FeatureCollection.
///
/// Represents a collection of GeoJSON features.
class BaatoFeatureCollectionGeoJson {
  /// The list of features in this collection.
  final List<BaatoGeoJson> features;

  /// Creates a new [BaatoFeatureCollectionGeoJson] instance.
  ///
  /// [features] is the list of features to include in the collection.
  BaatoFeatureCollectionGeoJson({
    required this.features,
  });

  Map<String, dynamic> toGeoJson({
    bool wrappedWithFeatureCollection = false,
  }) {
    final featureJson = {
      'type': 'FeatureCollection',
      'features': features.map((feature) => feature.toGeoJson()).toList()
    };

    return featureJson;
  }
}
