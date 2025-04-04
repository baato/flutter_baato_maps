import 'package:baato_maps/baato_maps.dart';
import 'package:baato_maps/src/map_core/marker_manager.dart';
import 'package:baato_maps/src/map_core/shape_manager.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class RouteManager {
  final MapLibreMapController _mapLibreMapController;
  final MarkerManager _markerManager;
  final ShapeManager _shapeManager;

  RouteManager(this._mapLibreMapController)
    : _markerManager = MarkerManager(_mapLibreMapController),
      _shapeManager = ShapeManager(_mapLibreMapController);

  Future<void> addRoute(BaatoCoordinate start, BaatoCoordinate end) async {
    final routePoints = [start, end];
    await _shapeManager.addPolyline(routePoints);
    await _markerManager.addMarker(start, iconImage: 'start');
    await _markerManager.addMarker(end, iconImage: 'end');
  }

  void drawRoute(BaatoRouteResponse route) {
    if ((route.data ?? []).isEmpty) throw Exception("No result found");
    final routeData = route.data?[0];
    if (routeData == null) throw Exception("No route data found");
    List<LatLng> latLngList = [];
    for (BaatoCoordinate geoCoord in routeData.coordinates ?? []) {
      latLngList.add(LatLng(geoCoord.latitude, geoCoord.longitude));
    }
    _shapeManager.clearLines();
    _shapeManager.addLine(
      LineOptions(
        geometry: latLngList,
        lineColor: "#081E2A",
        lineWidth: 10.0,
        lineOpacity: 0.5,
      ),
    );
  }
}
