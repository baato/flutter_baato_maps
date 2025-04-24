import 'dart:math';

import 'package:baato_api/baato_api.dart';
import 'package:baato_maps/src/constants/baato_map_style.dart';
import 'package:baato_maps/src/constants/baato_markers.dart';
import 'package:baato_maps/src/map_core/camera_manager.dart';
import 'package:baato_maps/src/map_core/coordinate_converter.dart';
import 'package:baato_maps/src/map_core/geo_json_manager.dart';
import 'package:baato_maps/src/map_core/marker_manager.dart';
import 'package:baato_maps/src/map_core/route_manager.dart';
import 'package:baato_maps/src/map_core/shape_manager.dart';
import 'package:baato_maps/src/map_core/source_and_layer_manager.dart';
import 'package:baato_maps/src/map_core/style_manager.dart';
import 'package:baato_maps/src/model/baato_map_feature.dart';
import 'package:flutter/services.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

/// Base controller for managing the Baato map.
///
/// This controller provides access to various map management functionalities through
/// specialized managers for different aspects of the map:
/// - [cameraManager]: Controls camera position, zoom, and movement
/// - [markerManager]: Handles adding, removing, and updating markers
/// - [shapeManager]: Manages shapes like lines, polygons on the map
/// - [geoJsonManager]: Handles GeoJSON data visualization
/// - [styleManager]: Controls map styles and appearance
/// - [coordinateConverter]: Converts between screen and map coordinates
/// - [routeManager]: Manages route display and navigation
/// - [sourceAndLayerManager]: Handles map sources and layers
class BaatoMapController {
  /// The underlying MapLibre map controller
  MapLibreMapController? _controller;

  /// Manages camera operations like panning, zooming, and animations
  late final CameraManager? cameraManager;

  /// Manages markers on the map
  late final MarkerManager markerManager;

  /// Manages shapes like lines, polygons, and circles on the map
  late final ShapeManager shapeManager;

  /// Manages GeoJSON data visualization on the map
  late final GeoJsonManager geoJsonManager;

  /// Manages map styles and appearance
  late final StyleManager styleManager;

  /// Converts between screen coordinates and map coordinates
  late final CoordinateConverter coordinateConverter;

  /// Manages route display and navigation features
  late final RouteManager routeManager;

  /// Manages map sources and layers
  late final SourceAndLayerManager sourceAndLayerManager;

  /// Creates a new BaatoMapController with the specified initial style
  ///
  /// [initialStyle] is the map style or identifier to use when the map is first loaded
  BaatoMapController(
    BaatoMapStyle initialStyle,
  ) {
    styleManager = StyleManager(initialStyle: initialStyle);
  }

  /// Callback for user location updates
  ///
  /// This is forwarded from the underlying MapLibre controller
  void Function(UserLocation)? get onUserLocationUpdated =>
      _controller?.onUserLocationUpdated;

  /// The underlying MapLibre map controller
  MapLibreMapController? get controller => _controller;

  /// Sets the underlying MapLibre controller and initializes all managers
  ///
  /// This method must be called before using any other functionality of this controller
  Future<void> setController(
    MapLibreMapController controller, {
    List<String>? poiLayerContainIds,
  }) async {
    _controller = controller;
    if (_controller == null) {
      throw Exception('Baato Map Controller not initialized');
    }
    cameraManager = CameraManager(_controller!);
    sourceAndLayerManager = SourceAndLayerManager(_controller!);
    markerManager = MarkerManager(_controller!);
    geoJsonManager = GeoJsonManager(_controller!);
    shapeManager = ShapeManager(_controller!);
    coordinateConverter = CoordinateConverter(_controller!);
    routeManager = RouteManager(_controller!, sourceAndLayerManager);
    // await _addDefaultAssets();
    // _poiLayers =
    //     await findPOILayers(poiLayerContainIds ?? const ["Poi", "BusStop"]);
  }

  /// Adds a listener to the map controller
  ///
  /// The listener will be called when map events occur
  Future<void> addListener(void Function() listener) async {
    if (_controller == null) {
      throw Exception('Baato Map Controller not initialized');
    }
    _controller!.addListener(listener);
  }

  /// Removes a previously added listener from the map controller
  Future<void> removeListener(void Function() listener) async {
    if (_controller == null) {
      throw Exception('Baato Map Controller not initialized');
    }
    _controller!.removeListener(listener);
  }

  /// Forces a resize of the map when running on web platforms
  ///
  /// This is useful when the map container size changes
  void forceResizeWebMap() async {
    if (_controller == null) {
      throw Exception('Baato Map Controller not initialized');
    }
    _controller!.forceResizeWebMap();
  }

  /// Adds default assets to the map
  ///
  /// This includes the default Baato marker icon
  Future<void> _addDefaultAssets() async {
    final ByteData bytes = await rootBundle.load(
      BaatoMarker.baatoDefault.assetPath,
    );
    await addImageFromData("baato_marker", bytes);
  }

  /// Adds an image to the map from binary data
  ///
  /// [name] is the identifier for the image that can be used in marker symbols
  /// [data] is the binary image data
  Future<void> addImageFromData(String name, ByteData data) async {
    if (_controller == null) {
      throw Exception('Baato Map Controller not initialized');
    }
    final Uint8List imageBytes = data.buffer.asUint8List();
    await _controller!.addImage(name, imageBytes);
  }

  setPOILayers(List<String> poiLayer) {
    _poiLayers = poiLayer;
  }

  /// Returns the raw MapLibre controller
  ///
  /// This provides direct access to the underlying MapLibre functionality
  MapLibreMapController? get rawController => _controller;

  List<String> _poiLayers = [];

  /// Queries the map for features at the given screen point.
  ///
  /// Returns a list of [BaatoMapFeature] objects representing the map features
  /// found at the specified point.
  Future<List<BaatoMapFeature>> queryPOIFeatures(
    Point<double> point, {
    BaatoCoordinate? sourceCoordinate,
  }) async {
    final mapLibreController = rawController;
    if (mapLibreController == null) return [];

    List<dynamic> mapFeatures = await mapLibreController.queryRenderedFeatures(
      point,
      _poiLayers,
      null,
    );

    final features = mapFeatures
        .map(
          (e) => BaatoMapFeature.fromMapFeature(e, sourceCoordinate),
        )
        .toList();

    return features;
  }

  /// Finds and stores POI layers in the current map style.
  ///
  /// This method queries the map for all layer IDs and filters them based on
  /// the prefixes specified in [poiLayerContainIds].
  Future<List<String>> findPOILayers(List<String> poiLayerContainIds) async {
    final mapLibreController = rawController;
    if (mapLibreController == null) return [];

    List<String> layers = (await mapLibreController.getLayerIds())
        .map((e) => e.toString())
        .toList();

    List<String> poiLayers = layers
        .where(
          (layer) => poiLayerContainIds.any(
            (text) => layer.startsWith(text),
          ),
        )
        .toList();

    _poiLayers = poiLayers;
    if (poiLayers.isEmpty) {
      return [];
    }

    return poiLayers;
  }

  /// Disposes the controller and releases resources
  void dispose() {
    styleManager.dispose();
  }
}
