import 'dart:math';
import 'package:baato_api/baato_api.dart';
import 'package:baato_maps/src/map/baato_map_controller.dart';
import 'package:baato_maps/src/map_core/map_core.dart';
import 'package:flutter/services.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class BaatoMapControllerImpl implements BaatoMapController {
  /// The underlying MapLibre map controller
  MapLibreMapController? _controller;

  /// Manages camera operations like panning, zooming, and animations
  @override
  late CameraManager cameraManager;

  /// Manages markers on the map
  @override
  late final MarkerManager markerManager;

  /// Manages shapes like lines, polygons, and circles on the map
  @override
  late final ShapeManager shapeManager;

  /// Manages GeoJSON data visualization on the map
  @override
  late final GeoJsonManager geoJsonManager;

  /// Manages map styles and appearance
  @override
  late StyleManager styleManager;

  /// Converts between screen coordinates and map coordinates
  @override
  late final CoordinateConverter coordinateConverter;

  /// Manages route display and navigation features
  @override
  late final RouteManager routeManager;

  /// Manages map sources and layers
  @override
  late final SourceAndLayerManager sourceAndLayerManager;

  /// List of POI layers
  List<String> _poiLayers = [];

  /// Creates a new BaatoMapControllerImpl with the default initial style
  BaatoMapControllerImpl() {
    styleManager = StyleManagerImpl(initialStyle: BaatoMapStyle.baatoLite);
  }

  /// Creates a new controller instance with style changes
  @override
  void changeStyle({BaatoMapStyle? style}) {
    if (style == null) {
      return;
    }
    styleManager = StyleManagerImpl(initialStyle: style);
  }

  /// Callback for user location updates
  ///
  /// This is forwarded from the underlying MapLibre controller
  @override
  void Function(UserLocation)? get onUserLocationUpdated =>
      _controller?.onUserLocationUpdated;

  /// The underlying MapLibre map controller
  @override
  MapLibreMapController? get libreController => _controller;

  /// Returns the raw MapLibre controller
  ///
  /// This provides direct access to the underlying MapLibre functionality
  @override
  MapLibreMapController? get rawController => _controller;

  /// Sets the underlying MapLibre controller and initializes all managers
  ///
  /// This method must be called before using any other functionality of this controller
  @override
  Future<void> setController(
    MapLibreMapController libreController, {
    List<String>? poiLayerContainIds,
  }) async {
    _controller = libreController;
    if (_controller == null) {
      throw Exception('Baato Map Controller not initialized');
    }
    cameraManager = CameraManagerImpl(_controller!);
    sourceAndLayerManager = SourceAndLayerManagerImpl(_controller!);
    markerManager = MarkerManagerImpl(_controller!);
    geoJsonManager = GeoJsonManagerImpl(_controller!);
    shapeManager = ShapeManagerImpl(_controller!);
    coordinateConverter = CoordinateConverterImpl(_controller!);
    routeManager = RouteManagerImpl(_controller!, sourceAndLayerManager);
    // await _addDefaultAssets();
    // _poiLayers =.
    //     await findPOILayers(poiLayerContainIds ?? const ["Poi", "BusStop"]);
  }

  /// Adds a listener to the map controller
  ///
  /// The listener will be called when map events occur
  @override
  Future<void> addListener(void Function() listener) async {
    if (_controller == null) {
      throw Exception('Baato Map Controller not initialized');
    }
    _controller!.addListener(listener);
  }

  /// Removes a previously added listener from the map controller
  @override
  Future<void> removeListener(void Function() listener) async {
    if (_controller == null) {
      throw Exception('Baato Map Controller not initialized');
    }
    _controller!.removeListener(listener);
  }

  /// Forces a resize of the map when running on web platforms
  ///
  /// This is useful when the map container size changes
  @override
  void forceResizeWebMap() {
    if (_controller == null) {
      throw Exception('Baato Map Controller not initialized');
    }
    _controller!.forceResizeWebMap();
  }

  @override
  Future<void> addImageFromData(String name, ByteData data) async {
    if (_controller == null) {
      throw Exception('Baato Map Controller not initialized');
    }
    final Uint8List imageBytes = data.buffer.asUint8List();
    await _controller!.addImage(name, imageBytes);
  }

  /// Sets the POI layers for the map
  @override
  void setPOILayers(List<String> poiLayer) {
    _poiLayers = poiLayer;
  }

  @override
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

  @override
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
  @override
  void dispose() {
    styleManager.dispose();
    _controller?.dispose();
  }
}
