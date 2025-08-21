import 'package:baato_api/baato_api.dart';
import 'package:baato_maps/src/model/baato_camera_position.dart';
import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

/// An abstract definition of a camera manager for Baato Maps.
/// 
/// This interface specifies the contract for camera operations such as moving,
/// zooming, and fitting bounds without specifying the underlying implementation.
abstract class CameraManager {
  /// Gets the current visible region of the map.
  Future<LatLngBounds> get visibleRegion;

  /// Indicates whether the camera is currently in motion.
  bool get isCameraMoving;

  /// Moves the camera to the user's current location.
  Future<void> moveToMyLocation();

  /// Moves the camera to a specified coordinate position.
  /// 
  /// [position] - Target coordinate.
  /// [zoom] - Optional zoom level.
  /// [animate] - Whether to animate the movement.
  Future<void> moveTo(
    BaatoCoordinate position, {
    double? zoom,
    bool animate = true,
  });

  /// Zooms in by one level.
  Future<void> zoomIn();

  /// Zooms out by one level.
  Future<void> zoomOut();

  /// Adjusts the camera to fit the given bounds.
  /// 
  /// [bounds] - Target bounds.
  /// [padding] - Optional padding.
  Future<void> fitBounds(LatLngBounds bounds, {EdgeInsets? padding});

  /// Retrieves the current camera position.
  BaatoCameraPosition? getCameraPosition();

  /// Gets the last recorded camera position.
  BaatoCameraPosition? get lastCameraPosition;

  /// Sets the last recorded camera position manually.
  void setLastCameraPosition(BaatoCameraPosition? position);
}
