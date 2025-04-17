import 'package:maplibre_gl/maplibre_gl.dart';

class GeoJsonManager {
  final MapLibreMapController _mapLibreMapController;

  GeoJsonManager(this._mapLibreMapController);

  /// Adds a GeoJSON source to the map.
  ///
  /// Parameters:
  /// - [sourceId]: The ID of the source to add
  /// - [geojson]: The GeoJSON data to add
  /// - [promoteId]: Optional ID to promote the source to
  ///
  Future<void> addGeoJson(
    String sourceId,
    Map<String, dynamic> geojson, {
    String? promoteId,
  }) async {
    if (geojson['features'] == null) {
      throw ArgumentError('geojson must contain a features property');
    }
    if (geojson['features'].length == 0) {
      throw ArgumentError('geojson must contain at least one feature');
    }

    if (geojson['features'][0]['geometry'] == null) {
      throw ArgumentError('geojson must contain a geometry property');
    }

    if (geojson['features'][0]['geometry']['type'] != 'LineString') {
      throw ArgumentError('geojson must contain a LineString geometry');
    }

    if (geojson['features'][0]['geometry']['coordinates'] == null) {
      throw ArgumentError('geojson must contain a coordinates property');
    }

    if (geojson['features'][0]['geometry']['coordinates'].length == 0) {
      throw ArgumentError('geojson must contain at least one coordinate');
    }

    if (geojson['features'][0]['properties'] == null) {
      throw ArgumentError('geojson must contain a properties property');
    }

    if (geojson['features'][0]['properties'].length == 0) {
      throw ArgumentError('geojson must contain at least one property');
    }
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
