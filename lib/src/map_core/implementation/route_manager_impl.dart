import 'package:baato_maps/baato_maps.dart';
import 'package:baato_maps/src/constants/base_constant.dart';
import 'package:baato_maps/src/map_core/map_core.dart';


class RouteManagerImpl implements RouteManager{
  /// The underlying MapLibre map controller used for route operations
  final MapLibreMapController _mapLibreMapController;

  /// The source and layer manager for handling map sources and layers
  final SourceAndLayerManager _sourceAndLayerManager;

  RouteManagerImpl(this._mapLibreMapController, this._sourceAndLayerManager);


  @override
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


  @override
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

  @override
  Future<void> drawRouteFromGeoJson(
    Map<String, dynamic> geoJson, {
    String sourceId = BaatoConstant.defaultRouteSourceName,
    String layerId = BaatoConstant.defaultRouteLayerName,
  }) async {
    final isSourceExists = await _sourceAndLayerManager.sourceExists(sourceId);
    if (isSourceExists) {
      await _mapLibreMapController.setGeoJsonSource(sourceId, geoJson);
    } else {
      await _mapLibreMapController.addGeoJsonSource(sourceId, geoJson);
    }
    final lineLayerMap = geoJson['features'][0]['properties'];
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

  @override
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

  @override
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
  @override
  Future<void> clearCustomRoute(
      {String sourceId = BaatoConstant.defaultRouteSourceName,
      String layerId = BaatoConstant.defaultRouteLayerName}) async {
    await _sourceAndLayerManager.removeSource(sourceId);
    await _sourceAndLayerManager.removeLayer(layerId);
  }

  /// Clears the route from the map
  @override
  Future<void> clearRoute() async {
    await _sourceAndLayerManager
        .removeSource(BaatoConstant.defaultRouteSourceName);
    await _sourceAndLayerManager
        .removeLayer(BaatoConstant.defaultRouteLayerName);
  }
}
