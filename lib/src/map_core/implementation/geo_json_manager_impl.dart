import 'package:baato_maps/src/map_core/map_core.dart';
import 'package:baato_maps/src/model/baato_geojson.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class GeoJsonManagerImpl implements GeoJsonManager {
  final MapLibreMapController _mapLibreMapController;

  GeoJsonManagerImpl(this._mapLibreMapController);

  /// Adds a GeoJSON source to the map.
  ///
  /// Parameters:
  /// - [sourceId]: The ID of the source to add
  /// - [geojson]: The GeoJSON data to add
  /// - [promoteId]: Optional ID to promote the source to
  ///
  @override
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
        geojson.toGeoJson(wrappedWithFeatureCollection: true),
      );
    } else if (updateIfSourceExist) {
      await _mapLibreMapController.setGeoJsonSource(
        sourceId,
        geojson.toGeoJson(wrappedWithFeatureCollection: true),
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

  /// Adds a collection of GeoJSON features to the map.
  ///
  /// Iterates over each feature in the collection and adds it as a separate
  /// GeoJSON source and layer, updating if they already exist.
  @override
  Future<void> addFeatureCollectionGeoJson(
    String sourceId,
    String layerId,
    BaatoFeatureCollectionGeoJson featureCollection,
  ) async {
    for (var i = 0; i < featureCollection.features.length; i++) {
      final feature = featureCollection.features[i];
      final sid = i == 0 ? sourceId : "$sourceId$i";
      final lid = i == 0 ? layerId : "$layerId$i";
      addGeoJson(
        sourceId: sid,
        layerId: lid,
        geojson: feature,
        updateIfSourceExist: true,
        updateIfLayerExist: true,
      );
    }
  }

  /// Updates an existing GeoJSON source and layer with new data.
  ///
  /// This method ensures that the GeoJSON data is updated if the source
  /// and layer already exist on the map.
  @override
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

  /// Removes a GeoJSON source and layer from the map.
  ///
  /// Checks if the source and layer exist before attempting to remove them.
  @override
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

  /// Sets a specific GeoJSON feature for a given source.
  ///
  /// This method allows updating a specific feature within a GeoJSON source.
  @override
  Future<void> setGeoJsonFeature(
    String sourceId,
    Map<String, dynamic> geojsonFeature,
  ) async {
    return _mapLibreMapController.setGeoJsonFeature(sourceId, geojsonFeature);
  }
}
