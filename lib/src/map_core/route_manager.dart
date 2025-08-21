import 'package:baato_maps/baato_maps.dart';
import 'package:baato_maps/src/constants/base_constant.dart';

/// A manager class that handles route operations for Baato Maps.
///
/// This class provides methods to add and draw routes on the map, including
/// placing markers at route endpoints and rendering route lines.
abstract class RouteManager {
  /// Draws a route on the map from an array of route properties
  ///
  /// This method creates a GeoJSON LineString from the provided route properties
  /// and draws it on the map as a route line.
  ///
  /// Parameters:
  /// - [routeProperties]: List of [BaatoRouteProperties] that define the route
  /// - [sourceId]: Optional custom source ID (defaults to the default route source)
  /// - [layerId]: Optional custom layer ID (defaults to the default route layer)
  Future<void> drawRoute(
    BaatoRouteProperties routeProperties, {
    String sourceId = BaatoConstant.defaultRouteSourceName,
    String layerId = BaatoConstant.defaultRouteLayerName,
  });

  /// Draws a route on the map from an array of route properties
  ///
  /// This method creates a GeoJSON LineString from the provided coordinates
  /// and draws it on the map as a route line.
  ///
  /// Parameters:
  /// - [routeProperties]: List of [BaatoRouteProperties] that define the route
  /// - [sourceId]: Optional custom source ID (defaults to the default route source)
  /// - [layerId]: Optional custom layer ID (defaults to the default route layer)
  Future<void> drawRoutesFromProperties(
    List<BaatoRouteProperties> routeProperties, {
    String sourceId = BaatoConstant.defaultRouteSourceName,
    String layerId = BaatoConstant.defaultRouteLayerName,
  });

  /// Draws a route on the map from a GeoJSON LineString
  ///
  /// This method clears existing lines and draws a new route line using
  /// the coordinates from the GeoJSON LineString.
  ///
  /// Parameters:
  /// - [geoJson]: The GeoJSON LineString to be drawn
  /// - [sourceId]: Optional custom source ID (defaults to the default route source)
  /// - [layerId]: Optional custom layer ID (defaults to the default route layer)
  Future<void> drawRouteFromGeoJson(
    Map<String, dynamic> geoJson, {
    String sourceId = BaatoConstant.defaultRouteSourceName,
    String layerId = BaatoConstant.defaultRouteLayerName,
  });

  /// Draws a route between two coordinates using the Baato Directions API.
  ///
  /// This method fetches a route from the Baato API and draws it on the map.
  ///
  /// Parameters:
  /// - [start]: The starting coordinate of the route
  /// - [end]: The ending coordinate of the route
  /// - [mode]: The transportation mode (car, bike, foot) - defaults to car
  /// - [lineLayerProperties]: Optional styling properties for the route line
  ///
  /// Returns a [Future] that completes when the route has been fetched and drawn.
  Future<void> drawRouteBetweenCoordinates({
    required BaatoCoordinate start,
    required BaatoCoordinate end,
    BaatoDirectionMode mode = BaatoDirectionMode.car,
    BaatoLineLayerProperties? lineLayerProperties,
  });

  /// Draws a route on the map based on a Baato route response.
  ///
  /// This method clears existing lines and draws a new route line using
  /// the coordinates from the route response.
  ///
  /// Parameters:
  /// - [route]: The [BaatoRouteResponse] containing route data to be drawn
  ///
  /// Throws an exception if no route data is found in the response.
  Future<void> drawRouteFromResponse(
    BaatoRouteResponse route, {
    BaatoLineLayerProperties? lineLayerProperties,
  });

  /// Clears the custom route from the map
  Future<void> clearCustomRoute({
    String sourceId = BaatoConstant.defaultRouteSourceName,
    String layerId = BaatoConstant.defaultRouteLayerName,
  });

  /// Clears the route from the map
  Future<void> clearRoute();
}
