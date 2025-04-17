import 'package:baato_maps/src/model/baato_model.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

/// A manager class that handles map sources and layers for Baato Maps.
///
/// This class provides methods to add, remove, and manage data sources and visual layers
/// on the map. It works with the underlying MapLibre map controller to handle these
/// map elements.
class SourceAndLayerManager {
  /// The underlying MapLibre map controller used for source and layer operations
  final MapLibreMapController _mapLibreMapController;

  /// Creates a new SourceAndLayerManager with the specified MapLibre controller
  ///
  /// [_mapLibreMapController] is the MapLibre controller used for source and layer operations
  SourceAndLayerManager(this._mapLibreMapController);

  /// Callbacks that are triggered when a map feature is tapped
  get onFeatureTapped => _mapLibreMapController.onFeatureTapped;

  /// Callbacks that are triggered when a map feature is dragged
  get onFeatureDrag => _mapLibreMapController.onFeatureDrag;

  /// Adds a data source to the map.
  ///
  /// Parameters:
  /// - [sourceId]: A unique identifier for the source
  /// - [sourceProperties]: The properties defining the source data and behavior
  ///
  /// Returns a [Future] that completes when the source has been added.
  Future<void> addSource(
      String sourceId, BaatoSourceProperties sourceProperties) async {
    await _mapLibreMapController.addSource(sourceId, sourceProperties);
  }

  /// Removes a data source from the map.
  ///
  /// Parameters:
  /// - [sourceId]: The identifier of the source to remove
  ///
  /// Returns a [Future] that completes when the source has been removed.
  Future<void> removeSource(String sourceId) async {
    await _mapLibreMapController.removeSource(sourceId);
  }

  /// Adds a visual layer to the map that renders data from a source.
  ///
  /// Parameters:
  /// - [sourceId]: The identifier of the source providing data for this layer
  /// - [layerId]: A unique identifier for the layer
  /// - [layerProperties]: The properties defining how the layer should be rendered
  /// - [belowLayerId]: Optional identifier of another layer to place this layer below
  /// - [enableInteraction]: Whether user interaction with this layer is enabled
  /// - [sourceLayer]: For vector tile sources, the name of the source layer to use
  /// - [minzoom]: The minimum zoom level at which the layer is visible
  /// - [maxzoom]: The maximum zoom level at which the layer is visible
  /// - [filter]: Optional filter expression to limit which features are displayed
  ///
  /// Returns a [Future] that completes when the layer has been added.
  Future<void> addLayer(
    String sourceId,
    String layerId,
    BaatoLayerProperties layerProperties, {
    String? belowLayerId,
    bool enableInteraction = true,
    String? sourceLayer,
    double? minzoom,
    double? maxzoom,
    dynamic filter,
  }) async {
    await _mapLibreMapController.addLayer(
      sourceId,
      layerId,
      layerProperties,
      belowLayerId: belowLayerId,
      enableInteraction: enableInteraction,
      sourceLayer: sourceLayer,
      minzoom: minzoom,
      maxzoom: maxzoom,
      filter: filter,
    );
  }

  /// Removes a layer from the map.
  ///
  /// Parameters:
  /// - [layerId]: The identifier of the layer to remove
  ///
  /// Returns a [Future] that completes when the layer has been removed.
  Future<void> removeLayer(String layerId) async {
    await _mapLibreMapController.removeLayer(layerId);
  }

  /// check if a layer exists
  Future<bool> layerExists(String layerId) async {
    final layerIds = await _mapLibreMapController.getLayerIds();
    return layerIds.contains(layerId);
  }

  /// check if a source exists
  Future<bool> sourceExists(String sourceId) async {
    final sourceIds = await _mapLibreMapController.getSourceIds();
    return sourceIds.contains(sourceId);
  }
}
