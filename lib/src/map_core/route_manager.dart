import 'package:baato_maps/baato_maps.dart';
import 'package:baato_maps/src/constants/base_constant.dart';
import 'package:baato_maps/src/map_core/source_and_layer_manager.dart';

/// A manager class that handles route operations for Baato Maps.
///
/// This class provides methods to add and draw routes on the map, including
/// placing markers at route endpoints and rendering route lines.
class RouteManager {
  /// The underlying MapLibre map controller used for route operations
  final MapLibreMapController _mapLibreMapController;

  /// The source and layer manager for handling map sources and layers
  final SourceAndLayerManager _sourceAndLayerManager;

  /// Creates a new RouteManager with the specified controllers
  ///
  /// [_mapLibreMapController] is the MapLibre controller used for map operations
  /// [_sourceAndLayerManager] is the manager for map sources and layers
  RouteManager(this._mapLibreMapController, this._sourceAndLayerManager);

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
  }) async {
    if (routeProperties.coordinates.isEmpty) {
      return;
    }
    await drawRouteFromGeoJson(
      routeProperties.toGeoJson(wrappedWithFeatureCollection: true),
      sourceId: sourceId,
      layerId: layerId,
    );
  }

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
  }) async {
    if (routeProperties.isEmpty) {
      return;
    }
    for (int i = 0; i < routeProperties.length; i++) {
      final routeProperty = routeProperties[i];
      final routeSourceId = i > 0 ? '${sourceId}_$i' : sourceId;
      final routeLayerId = i > 0 ? '${layerId}_$i' : layerId;
      await drawRouteFromGeoJson(
        routeProperty.toGeoJson(),
        sourceId: routeSourceId,
        layerId: routeLayerId,
      );
    }
  }

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
  }) async {
    final isSourceExists = await _sourceAndLayerManager.sourceExists(sourceId);
    if (isSourceExists) {
      _mapLibreMapController.setGeoJsonSource(sourceId, geoJson);
    } else {
      _mapLibreMapController.addGeoJsonSource(sourceId, geoJson);
    }
    final lineLayerMap = geoJson['properties'];
    final LineLayerProperties lineLayerProperties;
    if (lineLayerMap == null) {
      lineLayerProperties = const LineLayerProperties(
        lineColor: "#081E2A",
        lineWidth: 10.0,
        lineOpacity: 0.5,
        lineJoin: "round",
        lineCap: "round",
      );
    } else {
      lineLayerProperties = LineLayerProperties.fromJson(lineLayerMap);
    }

    final isLayerExists = await _sourceAndLayerManager.layerExists(layerId);
    if (isLayerExists) {
      _mapLibreMapController.setLayerProperties(layerId, lineLayerProperties);
    } else {
      _mapLibreMapController.addLayer(
        sourceId,
        layerId,
        lineLayerProperties,
      );
    }
  }

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
  }) async {
    final route = await Baato.api.direction.getRoutes(
      startCoordinate: BaatoCoordinate(
        latitude: start.latitude,
        longitude: start.longitude,
      ),
      endCoordinate: BaatoCoordinate(
        latitude: end.latitude,
        longitude: end.longitude,
      ),
      mode: mode,
      decodePolyline: true,
    );
    await drawRouteFromResponse(route,
        lineLayerProperties: lineLayerProperties);
  }

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
  }) async {
    if ((route.data ?? []).isEmpty) throw Exception("No result found");
    final routeData = route.data?[0];
    if (routeData == null) throw Exception("No route data found");

    final routeProperties = BaatoRouteProperties(
      coordinates: routeData.coordinates ?? [],
      lineLayerProperties: lineLayerProperties,
    );
    await drawRoute(routeProperties);
  }

  /// Clears the custom route from the map
  Future<void> clearCustomRoute(
      {String sourceId = BaatoConstant.defaultRouteSourceName,
      String layerId = BaatoConstant.defaultRouteLayerName}) async {
    await _sourceAndLayerManager.removeSource(sourceId);
    await _sourceAndLayerManager.removeLayer(layerId);
  }

  /// Clears the route from the map
  Future<void> clearRoute() async {
    await _sourceAndLayerManager
        .removeSource(BaatoConstant.defaultRouteSourceName);
    await _sourceAndLayerManager
        .removeLayer(BaatoConstant.defaultRouteLayerName);
  }
}
