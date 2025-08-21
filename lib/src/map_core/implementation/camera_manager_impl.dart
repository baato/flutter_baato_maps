import 'dart:math';

import 'package:baato_api/baato_api.dart';
import 'package:baato_maps/src/map_core/camera_manager.dart';
import 'package:baato_maps/src/map_core/extension/export.dart';
import 'package:baato_maps/src/model/baato_camera_position.dart';
import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

/// A manager class that handles camera operations for the Baato Maps.
///
/// This class provides methods to control the map camera, including movement,
/// zooming, and bounds fitting operations. It maintains the last camera position
/// and provides access to the current camera state.
class CameraManagerImpl implements CameraManager {
  /// The underlying MapLibre map controller used for camera operations
  final MaplibreMapController _mapLibreMapController;

  /// Stores the last camera position after camera movements
  BaatoCameraPosition? _lastCameraPosition;

  /// Creates a new CameraManager with the specified MapLibre controller
  ///
  /// [_mapLibreMapController] is the MapLibre controller that will be used
  /// for all camera operations
  CameraManagerImpl(this._mapLibreMapController);

  /// Gets the current visible region of the map as a LatLngBounds
  ///
  /// Returns a Future that resolves to the LatLngBounds representing the
  /// currently visible area on the map
  @override
  Future<LatLngBounds> get visibleRegion =>
      _mapLibreMapController.getVisibleRegion();

  /// Indicates whether the camera is currently in motion
  ///
  /// Returns true if the camera is currently moving, false otherwise
  @override
  bool get isCameraMoving => _mapLibreMapController.isCameraMoving;

  /// Moves the camera to the user's current location.
  ///
  /// This method animates the camera to the user's current location and updates the last camera position.
  /// Returns a [Future] that completes when the camera movement is finished.
  @override
  Future<void> moveToMyLocation() async {
    final cameraPosition = CameraPosition(
      target: LatLng(
          _mapLibreMapController.cameraPosition?.target.latitude ?? 0,
          _mapLibreMapController.cameraPosition?.target.longitude ?? 0),
      zoom: _mapLibreMapController.cameraPosition?.zoom ?? 10.0,
    );
    final cameraUpdate = CameraUpdate.newCameraPosition(cameraPosition);
    await _mapLibreMapController.animateCamera(cameraUpdate);
    _lastCameraPosition = cameraPosition.toBaatoCameraPosition;
  }

  /// Moves the camera to a specified coordinate position.
  ///
  /// Parameters:
  /// - [position]: The target [BaatoCoordinate] to move the camera to
  /// - [zoom]: Optional zoom level. If not provided, maintains current zoom or defaults to 10.0
  /// - [animate]: Whether to animate the camera movement (default: true)
  ///
  /// Returns a [Future] that completes when the camera movement is finished.
  @override
  Future<void> moveTo(
    BaatoCoordinate position, {
    double? zoom,
    bool animate = true,
  }) async {
    final cameraPosition = CameraPosition(
      target: position.toLatLng,
      zoom: zoom ?? _mapLibreMapController.cameraPosition?.zoom ?? 10.0,
    );
    final cameraUpdate = CameraUpdate.newCameraPosition(cameraPosition);
    if (animate) {
      await _mapLibreMapController.animateCamera(cameraUpdate);
    } else {
      await _mapLibreMapController.moveCamera(cameraUpdate);
    }
    _lastCameraPosition = cameraPosition.toBaatoCameraPosition;
  }

  /// Increases the map zoom level by 1.
  ///
  /// Animates the camera to zoom in and updates the last camera position.
  /// Returns a [Future] that completes when the zoom animation is finished.
  @override
  Future<void> zoomIn() async {
    final currentZoom = _mapLibreMapController.cameraPosition?.zoom ?? 0;
    await _mapLibreMapController.animateCamera(
      CameraUpdate.zoomTo(currentZoom + 1),
    );
    _lastCameraPosition = BaatoCameraPosition(
      target: BaatoCoordinate(
        latitude: _mapLibreMapController.cameraPosition?.target.latitude ?? 0,
        longitude: _mapLibreMapController.cameraPosition?.target.longitude ?? 0,
      ),
      zoom: currentZoom + 1,
    );
  }

  /// Decreases the map zoom level by 1.
  ///
  /// Animates the camera to zoom out and updates the last camera position.
  /// The zoom level is constrained to not go below 0.
  /// Returns a [Future] that completes when the zoom animation is finished.
  @override
  Future<void> zoomOut() async {
    final currentZoom = _mapLibreMapController.cameraPosition?.zoom ?? 0;
    await _mapLibreMapController.animateCamera(
      CameraUpdate.zoomTo(max(0, currentZoom - 1)),
    );
    _lastCameraPosition = BaatoCameraPosition(
      target: BaatoCoordinate(
        latitude: _mapLibreMapController.cameraPosition?.target.latitude ?? 0,
        longitude: _mapLibreMapController.cameraPosition?.target.longitude ?? 0,
      ),
      zoom: currentZoom + 1,
    );
  }

  /// Adjusts the camera view to fit the given bounds.
  ///
  /// Parameters:
  /// - [bounds]: The [LatLngBounds] that should be visible in the viewport
  /// - [padding]: Optional [EdgeInsets] to apply padding around the bounds (defaults to 100 on all sides)
  ///
  /// Returns a [Future] that completes when the camera adjustment is finished.
  @override
  Future<void> fitBounds(LatLngBounds bounds, {EdgeInsets? padding}) async {
    await _mapLibreMapController.animateCamera(
      CameraUpdate.newLatLngBounds(
        bounds,
        left: padding?.left ?? 100,
        top: padding?.top ?? 100,
        right: padding?.right ?? 100,
        bottom: padding?.bottom ?? 100,
      ),
    );
    _lastCameraPosition = BaatoCameraPosition(
      target: BaatoCoordinate(
        latitude: _mapLibreMapController.cameraPosition?.target.latitude ?? 0,
        longitude: _mapLibreMapController.cameraPosition?.target.longitude ?? 0,
      ),
      zoom: _mapLibreMapController.cameraPosition?.zoom ?? 0,
    );
  }

  /// Retrieves the current camera position.
  ///
  /// Returns a [BaatoCameraPosition] containing the current camera coordinates and zoom level.
  /// If the camera position is not available, returns default values (0,0) with zoom 0.
  @override
  BaatoCameraPosition? getCameraPosition() {
    final baatoCameraPosition = BaatoCameraPosition(
      target: BaatoCoordinate(
        latitude: _mapLibreMapController.cameraPosition?.target.latitude ?? 0,
        longitude: _mapLibreMapController.cameraPosition?.target.longitude ?? 0,
      ),
      zoom: _mapLibreMapController.cameraPosition?.zoom ?? 0,
    );
    return baatoCameraPosition;
  }

  /// Gets the last recorded camera position.
  ///
  /// Returns the most recent [BaatoCameraPosition] that was set through camera operations.
  /// May return null if no camera operations have been performed yet.
  @override
  BaatoCameraPosition? get lastCameraPosition => _lastCameraPosition;

  /// Sets the last camera position manually.
  ///
  /// Parameters:
  /// - [position]: The [BaatoCameraPosition] to set as the last camera position
  @override
  void setLastCameraPosition(BaatoCameraPosition? position) {
    _lastCameraPosition = position;
  }
}
