import 'package:baato_maps/baato_maps.dart';

/// A class that represents the properties of a Baato route.
///
/// This class provides a way to customize the appearance and behavior of routes
/// displayed on a Baato map.
class BaatoRouteProperties {
  /// The coordinates for the route
  final List<BaatoCoordinate> coordinates;

  /// The properties for styling the route line
  late final BaatoLineLayerProperties lineLayerProperties;

  /// Creates a new BaatoRouteProperties instance.
  ///
  /// [lineLayerProperties] defines the visual styling of the route line
  BaatoRouteProperties({
    required this.coordinates,
    BaatoLineLayerProperties? lineLayerProperties,
  }) {
    this.lineLayerProperties = lineLayerProperties ??
        const BaatoLineLayerProperties(
          lineColor: "#081E2A",
          lineWidth: 10.0,
          lineOpacity: 0.5,
          lineJoin: "round",
          lineCap: "round",
        );
  }

  /// Creates a copy of this BaatoRouteProperties with the given fields replaced with new values.
  BaatoRouteProperties copyWith({
    List<BaatoCoordinate>? coordinates,
    BaatoLineLayerProperties? lineLayerProperties,
  }) {
    return BaatoRouteProperties(
      coordinates: coordinates ?? this.coordinates,
      lineLayerProperties: lineLayerProperties ?? this.lineLayerProperties,
    );
  }

  /// Converts the route properties to a GeoJSON object.
  ///
  /// Returns a Map<String, dynamic> representing the GeoJSON object.
  Map<String, dynamic> toGeoJson() {
    return {
      "type": "Feature",
      "geometry": {
        "type": "LineString",
        "coordinates": coordinates
            .map((coord) => [coord.longitude, coord.latitude])
            .toList(),
      },
      "properties": lineLayerProperties.toJson(),
    };
  }
}
