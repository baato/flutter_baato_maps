import 'dart:math';
import 'dart:ui';
import 'package:baato_api/baato_api.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class CoordinateConverter {
  final MapLibreMapController _mapLibreMapController;

  CoordinateConverter(this._mapLibreMapController);

  Future<BaatoCoordinate?> toLatLng(Offset screenLocation) async {
    final point = await _mapLibreMapController.toLatLng(
      Point(screenLocation.dx, screenLocation.dy),
    );
    return BaatoCoordinate(point.latitude, point.longitude);
  }

  Future<Offset?> toScreenLocation(BaatoCoordinate coordinate) async {
    final latLng = LatLng(coordinate.latitude, coordinate.longitude);
    final point = await _mapLibreMapController.toScreenLocation(latLng);
    return Offset(point.x.toDouble(), point.y.toDouble());
  }
}
