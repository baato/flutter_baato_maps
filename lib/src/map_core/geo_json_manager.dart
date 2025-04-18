import 'package:baato_maps/src/model/baato_geojson.dart';
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
  Future<void> addGeoJson({
    required String sourceId,
    required String layerId,
    required BaatoGeoJson geojson,
    bool updateIfSourceExist = false,
    bool updateIfLayerExist = false,
  }) async {
    final isSourceExist =
        (await _mapLibreMapController.getSourceIds()).contains(sourceId);
    if (!isSourceExist) {
      await _mapLibreMapController.addGeoJsonSource(
        sourceId,
        geojson.toGeoJson(),
      );
    } else if (updateIfSourceExist) {
      await _mapLibreMapController.setGeoJsonSource(
        sourceId,
        geojson.toGeoJson(),
      );
    }

    if (geojson.properties != null) {
      final isLayerExist =
          (await _mapLibreMapController.getLayerIds()).contains(layerId);
      if (!isLayerExist) {
        await _mapLibreMapController.addLayer(
          sourceId,
          layerId,
          geojson.properties!,
        );
      } else if (updateIfLayerExist) {
        await _mapLibreMapController.setLayerProperties(
          layerId,
          geojson.properties!,
        );
      }
    }
  }

  Future<void> updateGeoJson(
    String sourceId,
    String layerId,
    BaatoGeoJson geojson,
  ) async {
    return addGeoJson(
      sourceId: sourceId,
      layerId: layerId,
      geojson: geojson,
      updateIfSourceExist: true,
      updateIfLayerExist: true,
    );
  }

  Future<void> removeGeoJson(String sourceId, String layerId) async {
    final isSourceExist =
        (await _mapLibreMapController.getSourceIds()).contains(sourceId);
    if (isSourceExist) {
      return _mapLibreMapController.removeSource(sourceId);
    }
    final isLayerExist =
        (await _mapLibreMapController.getLayerIds()).contains(layerId);
    if (isLayerExist) {
      return _mapLibreMapController.removeLayer(layerId);
    }
  }

  Future<void> setGeoJsonFeature(
    String sourceId,
    Map<String, dynamic> geojsonFeature,
  ) async {
    return _mapLibreMapController.setGeoJsonFeature(sourceId, geojsonFeature);
  }
}
