import 'package:maplibre_gl/maplibre_gl.dart';

class GeoJsonManager {
  final MapLibreMapController _mapLibreMapController;

  GeoJsonManager(this._mapLibreMapController);

  Future<void> addGeoJson(
    Map<String, dynamic> geoJson, {
    String sourceId = 'custom-geojson',
  }) async {}
}
