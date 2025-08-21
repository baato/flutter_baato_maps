import 'package:baato_maps/src/model/baato_model.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

/// An abstract interface that handles map sources and layers for Baato Maps.
///
/// Provides methods to add, remove, and manage data sources and visual layers
/// on the map.
abstract class SourceAndLayerManager {
  /// Callbacks that are triggered when a map feature is tapped
  List<OnFeatureInteractionCallback> get onFeatureTapped;

  /// Callbacks that are triggered when a map feature is dragged
  List<OnFeatureDragnCallback> get onFeatureDrag;

  /// Adds a data source to the map.
  ///
  /// Parameters:
  /// - [sourceId]: A unique identifier for the source
  /// - [sourceProperties]: The properties defining the source data and behavior
  Future<void> addSource(
      String sourceId, BaatoSourceProperties sourceProperties);

  /// Removes a data source from the map.
  ///
  /// Parameters:
  /// - [sourceId]: The identifier of the source to remove
  Future<void> removeSource(String sourceId);

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
  Future<void> addLayer(
    String sourceId,
    String layerId,
    BaatoLayerProperties layerProperties, {
    String? belowLayerId,
    bool enableInteraction,
    String? sourceLayer,
    double? minzoom,
    double? maxzoom,
    dynamic filter,
  });

  /// Updates the properties of an existing layer.
  ///
  /// Parameters:
  /// - [layerId]: The identifier of the layer to update
  /// - [layerProperties]: The new properties to apply to the layer
  Future<void> updateLayerProperties(
    String layerId,
    BaatoLayerProperties layerProperties,
  );

  /// Adds a line layer to the map.
  ///
  /// Parameters:
  /// - [sourceId]: The identifier of the source providing data for this layer
  /// - [layerId]: A unique identifier for the layer
  /// - [lineLayerProperties]: The properties defining how the line layer should be rendered
  /// - [belowLayerId]: Optional identifier of another layer to place this layer below
  /// - [enableInteraction]: Whether user interaction with this layer is enabled
  /// - [sourceLayer]: For vector tile sources, the name of the source layer to use
  /// - [minzoom]: The minimum zoom level at which the layer is visible
  /// - [maxzoom]: The maximum zoom level at which the layer is visible
  /// - [filter]: Optional filter expression to limit which features are displayed
  Future<void> addLineLayer(
    String sourceId,
    String layerId,
    LineLayerProperties lineLayerProperties, {
    String? belowLayerId,
    bool enableInteraction,
    String? sourceLayer,
    double? minzoom,
    double? maxzoom,
    dynamic filter,
  });

  /// Adds a circle layer to the map.
  ///
  /// Parameters:
  /// - [sourceId]: The identifier of the source providing data for this layer
  /// - [layerId]: A unique identifier for the layer
  /// - [circleLayerProperties]: The properties defining how the circle layer should be rendered
  /// - [belowLayerId]: Optional identifier of another layer to place this layer below
  /// - [enableInteraction]: Whether user interaction with this layer is enabled
  /// - [sourceLayer]: For vector tile sources, the name of the source layer to use
  /// - [minzoom]: The minimum zoom level at which the layer is visible
  /// - [maxzoom]: The maximum zoom level at which the layer is visible
  /// - [filter]: Optional filter expression to limit which features are displayed
  Future<void> addCircleLayer(
    String sourceId,
    String layerId,
    CircleLayerProperties circleLayerProperties, {
    String? belowLayerId,
    bool enableInteraction,
    String? sourceLayer,
    double? minzoom,
    double? maxzoom,
    dynamic filter,
  });

  /// Adds a fill layer to the map.
  ///
  /// Parameters:
  /// - [sourceId]: The identifier of the source providing data for this layer
  /// - [layerId]: A unique identifier for the layer
  /// - [fillLayerProperties]: The properties defining how the fill layer should be rendered
  /// - [belowLayerId]: Optional identifier of another layer to place this layer below
  /// - [enableInteraction]: Whether user interaction with this layer is enabled
  /// - [sourceLayer]: For vector tile sources, the name of the source layer to use
  /// - [minzoom]: The minimum zoom level at which the layer is visible
  /// - [maxzoom]: The maximum zoom level at which the layer is visible
  /// - [filter]: Optional filter expression to limit which features are displayed
  Future<void> addFillLayer(
    String sourceId,
    String layerId,
    FillLayerProperties fillLayerProperties, {
    String? belowLayerId,
    bool enableInteraction,
    String? sourceLayer,
    double? minzoom,
    double? maxzoom,
    dynamic filter,
  });

  /// Adds a symbol layer to the map.
  ///
  /// Parameters:
  /// - [sourceId]: The identifier of the source providing data for this layer
  /// - [layerId]: A unique identifier for the layer
  /// - [symbolLayerProperties]: The properties defining how the symbol layer should be rendered
  /// - [belowLayerId]: Optional identifier of another layer to place this layer below
  /// - [enableInteraction]: Whether user interaction with this layer is enabled
  /// - [sourceLayer]: For vector tile sources, the name of the source layer to use
  /// - [minzoom]: The minimum zoom level at which the layer is visible
  /// - [maxzoom]: The maximum zoom level at which the layer is visible
  /// - [filter]: Optional filter expression to limit which features are displayed
  Future<void> addSymbolLayer(
    String sourceId,
    String layerId,
    SymbolLayerProperties symbolLayerProperties, {
    String? belowLayerId,
    bool enableInteraction,
    String? sourceLayer,
    double? minzoom,
    double? maxzoom,
    dynamic filter,
  });

  /// Adds an image layer to the map.
  ///
  /// Parameters:
  /// - [imageSourceId]: The identifier of the source providing data for this layer
  /// - [imageLayerId]: A unique identifier for the layer
  /// - [minzoom]: The minimum zoom level at which the layer is visible
  /// - [maxzoom]: The maximum zoom level at which the layer is visible
  Future<void> addImageLayer(
    String imageSourceId,
    String imageLayerId, {
    double? minzoom,
    double? maxzoom,
  });

  /// Removes a layer from the map.
  ///
  /// Parameters:
  /// - [layerId]: The identifier of the layer to remove
  Future<void> removeLayer(String layerId);

  /// Checks if a layer exists.
  Future<bool> layerExists(String layerId);

  /// Checks if a source exists.
  Future<bool> sourceExists(String sourceId);
}
