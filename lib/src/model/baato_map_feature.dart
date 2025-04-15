import 'dart:math';

import 'package:baato_maps/baato_maps.dart';

class BaatoMapFeature {
  final String? name;
  final int rank;
  final String className;
  final String? subClassName;
  final BaatoCoordinate coordinate;
  final double? distance;
  final dynamic rawFeature;

  BaatoMapFeature({
    required this.name,
    required this.rank,
    required this.className,
    required this.subClassName,
    required this.coordinate,
    required this.distance,
    required this.rawFeature,
  });

  factory BaatoMapFeature.fromMapFeature(
    Map<String, dynamic> mapFeature,
    BaatoCoordinate? userLocation,
  ) {
    final attributes = mapFeature['properties'] as Map<String, dynamic>?;
    final coordinate = BaatoCoordinate(
      mapFeature['geometry']['coordinates'][1],
      mapFeature['geometry']['coordinates'][0],
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
      coordinate.latitude,
      coordinate.longitude,
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

  static double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }
}
