import 'package:maplibre_gl/maplibre_gl.dart';

class GeoJsonManager {
  final MapLibreMapController _mapLibreMapController;

  GeoJsonManager(this._mapLibreMapController);

  Future<void> addGeoJson(
    String sourceId,
    Map<String, dynamic> geojson, {
    String? promoteId,
  }) async {
    return _mapLibreMapController.addGeoJsonSource(
      sourceId,
      geojson,
      promoteId: promoteId,
    );
  }

  Future<void> updateGeoJson(
    String sourceId,
    Map<String, dynamic> geojson,
  ) async {
    return _mapLibreMapController.setGeoJsonSource(
      sourceId,
      geojson,
    );
  }

  Future<void> removeGeoJson(String sourceId) async {
    return _mapLibreMapController.removeSource(sourceId);
  }

  Future<void> setGeoJsonFeature(
    String sourceId,
    Map<String, dynamic> geojsonFeature,
  ) async {
    return _mapLibreMapController.setGeoJsonFeature(sourceId, geojsonFeature);
  }
}
