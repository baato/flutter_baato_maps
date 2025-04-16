import 'dart:math';

import 'package:baato_maps/baato_maps.dart';

/// Represents a geographic feature on a Baato map.
///
/// This class encapsulates information about map features such as points of interest,
/// landmarks, roads, or other geographic entities displayed on the map.
class BaatoMapFeature {
  /// The name of the feature, if available.
  final String? name;

  /// The importance rank of the feature.
  ///
  /// Higher values typically indicate more significant features.
  final int rank;

  /// The primary classification of the feature (e.g., "building", "highway").
  final String className;

  /// The secondary classification of the feature (e.g., "residential", "commercial").
  final String? subClassName;

  /// The geographic coordinates of the feature.
  final BaatoCoordinate coordinate;

  /// The distance from the user's location to this feature, in meters.
  ///
  /// This value is null if the user's location is not available.
  final double? distance;

  /// The raw data of the feature as received from the map source.
  final dynamic rawFeature;

  /// Creates a new [BaatoMapFeature] instance.
  BaatoMapFeature({
    required this.name,
    required this.rank,
    required this.className,
    required this.subClassName,
    required this.coordinate,
    required this.distance,
    required this.rawFeature,
  });

  /// Creates a [BaatoMapFeature] from a map feature data structure.
  ///
  /// [mapFeature] is the raw feature data from the map source.
  /// [userLocation] is the current user location, if available.
  ///
  /// Returns a new [BaatoMapFeature] instance with processed data.
  factory BaatoMapFeature.fromMapFeature(
    Map<String, dynamic> mapFeature,
    BaatoCoordinate? userLocation,
  ) {
    final attributes = mapFeature['properties'] as Map<String, dynamic>?;
    final coordinate = BaatoCoordinate(
      latitude: mapFeature['geometry']['coordinates'][1],
      longitude: mapFeature['geometry']['coordinates'][0],
    );

    String? name = attributes?['name'] as String?;
    int rank = attributes?['rank'] as int? ?? 0;
    String className = attributes?['class'] as String? ?? '';
    String? subClassName = attributes?['subclass'] as String?;

    if (attributes?.containsKey('name:latin') ?? false) {
      name = attributes?['name:latin'] as String?;
    }
    if (attributes?.containsKey('name:en') ?? false) {
      name = attributes?['name:en'] as String?;
    }
    if (attributes?.containsKey('name:ne') ?? false) {
      name = attributes?['name:ne'] as String?;
    }

    final featureLocation = BaatoCoordinate(
      latitude: coordinate.latitude,
      longitude: coordinate.longitude,
    );
    double? distance;
    if (userLocation != null) {
      distance = _calculateDistance(userLocation, featureLocation);
    }

    if (name != null &&
        distance != null &&
        distance > 20.0 &&
        distance < 500.0) {
      name = 'Near $name';
    }

    return BaatoMapFeature(
      name: name,
      rank: rank,
      className: className,
      subClassName: subClassName,
      coordinate: coordinate,
      distance: distance,
      rawFeature: mapFeature,
    );
  }

  /// Calculates the distance between two geographic coordinates using the Haversine formula.
  ///
  /// [start] is the starting coordinate.
  /// [end] is the ending coordinate.
  ///
  /// Returns the distance in meters.
  static double _calculateDistance(BaatoCoordinate start, BaatoCoordinate end) {
    const double earthRadius = 6371000;
    final double dLat = _degreesToRadians(end.latitude - start.latitude);
    final double dLng = _degreesToRadians(end.longitude - start.longitude);
    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(start.latitude)) *
            cos(_degreesToRadians(end.latitude)) *
            sin(dLng / 2) *
            sin(dLng / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  /// Converts degrees to radians.
  ///
  /// [degrees] is the angle in degrees.
  ///
  /// Returns the angle in radians.
  static double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }
}
