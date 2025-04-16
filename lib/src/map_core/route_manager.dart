import 'package:baato_maps/baato_maps.dart';
import 'package:baato_maps/src/map_core/marker_manager.dart';
import 'package:baato_maps/src/map_core/shape_manager.dart';
import 'package:baato_maps/src/map_core/source_and_layer_manager.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

/// A manager class that handles route operations for Baato Maps.
///
/// This class provides methods to add and draw routes on the map, including
/// placing markers at route endpoints and rendering route lines.
class RouteManager {
  /// The underlying MapLibre map controller used for route operations
  final MapLibreMapController _mapLibreMapController;

  /// The marker manager for handling map markers at route endpoints
  final MarkerManager _markerManager;

  /// The shape manager for handling route lines and other shapes
  final ShapeManager _shapeManager;

  /// The source and layer manager for handling map sources and layers
  final SourceAndLayerManager _sourceAndLayerManager;

  /// Creates a new RouteManager with the specified controllers
  ///
  /// [_mapLibreMapController] is the MapLibre controller used for map operations
  /// [_sourceAndLayerManager] is the manager for map sources and layers
  RouteManager(this._mapLibreMapController, this._sourceAndLayerManager)
      : _markerManager =
            MarkerManager(_mapLibreMapController, _sourceAndLayerManager),
        _shapeManager = ShapeManager(_mapLibreMapController);

  /// Adds a simple route between two coordinates with markers at each endpoint.
  ///
  /// This method creates a line connecting the start and end points and
  /// places markers at both locations.
  ///
  /// Parameters:
  /// - [start]: The starting coordinate of the route
  /// - [end]: The ending coordinate of the route
  ///
  /// Returns a [Future] that completes when the route and markers have been added.
  Future<void> addRoute(BaatoCoordinate start, BaatoCoordinate end) async {
    final routePoints = [start, end];
    await _shapeManager.addMultiLine(routePoints);
    await _markerManager.addMarker(BaatoSymbolOption(geometry: start));
    await _markerManager.addMarker(BaatoSymbolOption(geometry: end));
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
  void drawRoute(BaatoRouteResponse route) {
    if ((route.data ?? []).isEmpty) throw Exception("No result found");
    final routeData = route.data?[0];
    if (routeData == null) throw Exception("No route data found");
    List<BaatoCoordinate> latLngList = [];
    for (BaatoCoordinate geoCoord in routeData.coordinates ?? []) {
      latLngList.add(BaatoCoordinate(
        latitude: geoCoord.latitude,
        longitude: geoCoord.longitude,
      ));
    }
    _shapeManager.clearLines();
    _shapeManager.addLine(
      latLngList[0],
      latLngList[1],
      options: BaatoLineOptions(
        lineColor: "#081E2A",
        lineWidth: 10.0,
        lineOpacity: 0.5,
      ),
    );
  }
}
