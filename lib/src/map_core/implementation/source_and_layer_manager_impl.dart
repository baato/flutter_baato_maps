import 'package:baato_maps/src/map_core/map_core.dart';
import 'package:baato_maps/src/model/baato_model.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class SourceAndLayerManagerImpl implements SourceAndLayerManager {
  /// The underlying MapLibre map controller used for source and layer operations
  final MapLibreMapController _mapLibreMapController;

  /// Creates a new SourceAndLayerManager with the specified MapLibre controller
  ///
  /// [_mapLibreMapController] is the MapLibre controller used for source and layer operations
  SourceAndLayerManagerImpl(this._mapLibreMapController);

  /// Callbacks that are triggered when a map feature is tapped
  @override
  List<OnFeatureInteractionCallback> get onFeatureTapped =>
      _mapLibreMapController.onFeatureTapped;

  /// Callbacks that are triggered when a map feature is dragged
  @override
  List<OnFeatureDragnCallback> get onFeatureDrag =>
      _mapLibreMapController.onFeatureDrag;

  @override
  Future<void> addSource(
      String sourceId, BaatoSourceProperties sourceProperties) async {
    await _mapLibreMapController.addSource(sourceId, sourceProperties);
  }

  @override
  Future<void> removeSource(String sourceId) async {
    await _mapLibreMapController.removeSource(sourceId);
  }

  @override
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

  @override
  Future<void> updateLayerProperties(
    String layerId,
    BaatoLayerProperties layerProperties,
  ) async {
    await _mapLibreMapController.setLayerProperties(
      layerId,
      layerProperties,
    );
  }

  @override
  Future<void> addLineLayer(
    String sourceId,
    String layerId,
    LineLayerProperties lineLayerProperties, {
    String? belowLayerId,
    bool enableInteraction = true,
    String? sourceLayer,
    double? minzoom,
    double? maxzoom,
    dynamic filter,
  }) async {
    await _mapLibreMapController.addLineLayer(
      sourceId,
      layerId,
      lineLayerProperties,
      belowLayerId: belowLayerId,
      enableInteraction: enableInteraction,
      sourceLayer: sourceLayer,
      minzoom: minzoom,
      maxzoom: maxzoom,
      filter: filter,
    );
  }

  @override
  Future<void> addCircleLayer(
    String sourceId,
    String layerId,
    CircleLayerProperties circleLayerProperties, {
    String? belowLayerId,
    bool enableInteraction = true,
    String? sourceLayer,
    double? minzoom,
    double? maxzoom,
    dynamic filter,
  }) async {
    await _mapLibreMapController.addCircleLayer(
      sourceId,
      layerId,
      circleLayerProperties,
      belowLayerId: belowLayerId,
      enableInteraction: enableInteraction,
      sourceLayer: sourceLayer,
      minzoom: minzoom,
      maxzoom: maxzoom,
      filter: filter,
    );
  }

  @override
  Future<void> addFillLayer(
    String sourceId,
    String layerId,
    FillLayerProperties fillLayerProperties, {
    String? belowLayerId,
    bool enableInteraction = true,
    String? sourceLayer,
    double? minzoom,
    double? maxzoom,
    dynamic filter,
  }) async {
    await _mapLibreMapController.addFillLayer(
      sourceId,
      layerId,
      fillLayerProperties,
      belowLayerId: belowLayerId,
      enableInteraction: enableInteraction,
      sourceLayer: sourceLayer,
      minzoom: minzoom,
      maxzoom: maxzoom,
      filter: filter,
    );
  }

  @override
  Future<void> addSymbolLayer(
    String sourceId,
    String layerId,
    SymbolLayerProperties symbolLayerProperties, {
    String? belowLayerId,
    bool enableInteraction = true,
    String? sourceLayer,
    double? minzoom,
    double? maxzoom,
    dynamic filter,
  }) async {
    await _mapLibreMapController.addSymbolLayer(
      sourceId,
      layerId,
      symbolLayerProperties,
      belowLayerId: belowLayerId,
      enableInteraction: enableInteraction,
      sourceLayer: sourceLayer,
      minzoom: minzoom,
      maxzoom: maxzoom,
      filter: filter,
    );
  }

  @override
  Future<void> addImageLayer(
    String imageSourceId,
    String imageLayerId, {
    double? minzoom,
    double? maxzoom,
  }) async {
    await _mapLibreMapController.addImageLayer(
      imageSourceId,
      imageLayerId,
      minzoom: minzoom,
      maxzoom: maxzoom,
    );
  }

  @override
  Future<void> removeLayer(String layerId) async {
    await _mapLibreMapController.removeLayer(layerId);
  }

  /// check if a layer exists
  @override
  Future<bool> layerExists(String layerId) async {
    final layerIds = await _mapLibreMapController.getLayerIds();
    return layerIds.contains(layerId);
  }

  /// check if a source exists
  @override
  Future<bool> sourceExists(String sourceId) async {
    final sourceIds = await _mapLibreMapController.getSourceIds();
    return sourceIds.contains(sourceId);
  }
}
