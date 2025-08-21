import 'dart:math';

import 'package:baato_api/baato_api.dart';
import 'package:baato_maps/src/map_core/map_core.dart';
import 'package:flutter/services.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

/// Abstract base class for managing Baato map controllers.
/// Base libreController for managing the Baato map.
///
/// This libreController provides access to various map management functionalities through
/// specialized managers for different aspects of the map:
/// - [cameraManager]: Controls camera position, zoom, and movement
/// - [markerManager]: Handles adding, removing, and updating markers
/// - [shapeManager]: Manages shapes like lines, polygons on the map
/// - [geoJsonManager]: Handles GeoJSON data visualization
/// - [styleManager]: Controls map styles and appearance
/// - [coordinateConverter]: Converts between screen and map coordinates
/// - [routeManager]: Manages route display and navigation
/// - [sourceAndLayerManager]: Handles map sources and layers
/// consistent behavior across different map controller implementations.
abstract class BaatoMapController {
  factory BaatoMapController._internal() => BaatoMapControllerImpl();

  /// Manages camera operations like panning, zooming, and animations
  CameraManager get cameraManager;

  /// Manages markers on the map
  MarkerManager get markerManager;

  /// Manages shapes like lines, polygons, and circles on the map
  ShapeManager get shapeManager;

  /// Manages GeoJSON data visualization on the map
  GeoJsonManager get geoJsonManager;

  /// Manages map styles and appearance
  StyleManager get styleManager;

  /// Converts between screen coordinates and map coordinates
  CoordinateConverter get coordinateConverter;

  /// Manages route display and navigation features
  RouteManager get routeManager;

  /// Manages map sources and layers
  SourceAndLayerManager get sourceAndLayerManager;

  /// Callback for user location updates
  void Function(UserLocation)? get onUserLocationUpdated;

  /// The underlying MapLibre map controller
  MapLibreMapController? get libreController;

  /// Returns the raw MapLibre controller for direct access
  MapLibreMapController? get rawController;

  /// Creates a new map controller with style changes
  ///
  /// [style] is the new map style to apply
  /// Returns a new controller instance with the specified style
  void changeStyle({BaatoMapStyle? style});

  /// Sets the underlying MapLibre controller and initializes all managers
  ///
  /// This method must be called before using any other functionality
  /// [libreController] is the MapLibre controller to wrap
  /// [poiLayerContainIds] optional list of POI layer identifiers
  Future<void> setController(
    MapLibreMapController libreController, {
    List<String>? poiLayerContainIds,
  });

  /// Adds a listener to the map controller
  ///
  /// [listener] will be called when map events occur
  Future<void> addListener(void Function() listener);

  /// Removes a previously added listener from the map controller
  ///
  /// [listener] the listener function to remove
  Future<void> removeListener(void Function() listener);

  /// Forces a resize of the map when running on web platforms
  ///
  /// Useful when the map container size changes
  void forceResizeWebMap();

  /// Adds an image to the map from binary data
  ///
  /// [name] identifier for the image that can be used in marker symbols
  /// [data] binary image data
  Future<void> addImageFromData(String name, ByteData data);

  /// Sets the POI layers for the map
  ///
  /// [poiLayer] list of POI layer identifiers
  void setPOILayers(List<String> poiLayer);

  /// Queries the map for features at the given screen point
  ///
  /// [point] screen coordinates to query
  /// [sourceCoordinate] optional source coordinate for context
  /// Returns list of map features found at the specified point
  Future<List<BaatoMapFeature>> queryPOIFeatures(
    Point<double> point, {
    BaatoCoordinate? sourceCoordinate,
  });

  /// Finds and stores POI layers in the current map style
  ///
  /// [poiLayerContainIds] list of layer ID prefixes to search for
  /// Returns list of matching POI layer identifiers
  Future<List<String>> findPOILayers(List<String> poiLayerContainIds);

  /// Disposes the controller and releases resources
  ///
  /// Should be called when the controller is no longer needed
  void dispose();

  ///The controller for the Baato map implementation
  factory BaatoMapController() => BaatoMapController._internal();
}
