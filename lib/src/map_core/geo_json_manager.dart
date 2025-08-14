import 'package:baato_maps/src/model/baato_geojson.dart';

/// A utility interface for managing GeoJSON sources and layers on the map.
///
/// This interface defines methods for adding, updating, and removing GeoJSON
/// data from a map, as well as setting individual features.
abstract class GeoJsonManager {
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
  });

  /// Adds a collection of GeoJSON features to the map.
  ///
  /// Iterates over each feature in the collection and adds it as a separate
  /// GeoJSON source and layer, updating if they already exist.
  Future<void> addFeatureCollectionGeoJson(
    String sourceId,
    String layerId,
    BaatoFeatureCollectionGeoJson featureCollection,
  );

  /// Updates an existing GeoJSON source and layer with new data.
  ///
  /// This method ensures that the GeoJSON data is updated if the source
  /// and layer already exist on the map.
  Future<void> updateGeoJson(
    String sourceId,
    String layerId,
    BaatoGeoJson geojson,
  );

  /// Removes a GeoJSON source and layer from the map.
  ///
  /// Checks if the source and layer exist before attempting to remove them.
  Future<void> removeGeoJson(String sourceId, String layerId);

  /// Sets a specific GeoJSON feature for a given source.
  ///
  /// This method allows updating a specific feature within a GeoJSON source.
  Future<void> setGeoJsonFeature(
    String sourceId,
    Map<String, dynamic> geojsonFeature,
  );
}
