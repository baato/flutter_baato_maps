import 'package:baato_maps/baato_maps.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class ShapeManager {
  final MapLibreMapController _mapLibreMapController;

  ShapeManager(this._mapLibreMapController);

  Future<Line> addPolyline(List<BaatoCoordinate> points) async {
    List<LatLng> latLngPoints =
        points.map((point) => LatLng(point.latitude, point.longitude)).toList();
    return await _mapLibreMapController.addLine(
      LineOptions(geometry: latLngPoints, lineColor: "#ff0000", lineWidth: 2.0),
    );
  }

  Future<Fill> addFill(
    List<BaatoCoordinate> points, {
    String? fillColor = "#FFFF00",
    double fillOpacity = 0.5,
    String? outlineColor = "#000000",
  }) async {
    List<LatLng> latLngPoints =
        points.map((point) => LatLng(point.latitude, point.longitude)).toList();
    return await _mapLibreMapController.addFill(
      FillOptions(
        geometry: [latLngPoints],
        fillColor: fillColor,
        fillOpacity: fillOpacity,
        fillOutlineColor: outlineColor,
      ),
    );
  }

  Future<Fill> highlightArea(List<BaatoCoordinate> points) async {
    return await addFill(
      points,
      fillColor: "#00FF00",
      fillOpacity: 0.3,
      outlineColor: "#00FF00",
    );
  }

  Future<void> addLine(LineOptions options) async {
    await _mapLibreMapController.addLine(options);
  }

  Future<void> removeLine(Line line) async {
    await _mapLibreMapController.removeLine(line);
  }

  Future<void> clearLines() async {
    await _mapLibreMapController.clearLines();
  }
}
