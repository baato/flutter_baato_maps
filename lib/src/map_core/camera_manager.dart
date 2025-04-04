import 'dart:math';

import 'package:baato_maps/baato_maps.dart';
import 'package:baato_maps/src/model/camera_position.dart';
import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class CameraManager {
  final MapLibreMapController _mapLibreMapController;
  BaatoCameraPosition? _lastCameraPosition;

  CameraManager(this._mapLibreMapController);

  Future<void> moveTo(
    BaatoCoordinate position, {
    double? zoom,
    bool animate = true,
  }) async {
    final latLng = LatLng(position.latitude, position.longitude);
    final cameraUpdate = CameraUpdate.newCameraPosition(
      CameraPosition(
        target: latLng,
        zoom: zoom ?? _mapLibreMapController.cameraPosition?.zoom ?? 10.0,
      ),
    );
    if (animate) {
      await _mapLibreMapController.animateCamera(cameraUpdate);
    } else {
      await _mapLibreMapController.moveCamera(cameraUpdate);
    }
    _lastCameraPosition = BaatoCameraPosition(
      target: position,
      zoom: zoom ?? _mapLibreMapController.cameraPosition?.zoom ?? 10.0,
    );
  }

  Future<void> zoomIn() async {
    final currentZoom = _mapLibreMapController.cameraPosition?.zoom ?? 0;
    await _mapLibreMapController.animateCamera(
      CameraUpdate.zoomTo(currentZoom + 1),
    );
    _lastCameraPosition = BaatoCameraPosition(
      target: BaatoCoordinate(
        _mapLibreMapController.cameraPosition?.target.latitude ?? 0,
        _mapLibreMapController.cameraPosition?.target.longitude ?? 0,
      ),
      zoom: currentZoom + 1,
    );
  }

  Future<void> zoomOut() async {
    final currentZoom = _mapLibreMapController.cameraPosition?.zoom ?? 0;
    await _mapLibreMapController.animateCamera(
      CameraUpdate.zoomTo(max(0, currentZoom - 1)),
    );
    _lastCameraPosition = BaatoCameraPosition(
      target: BaatoCoordinate(
        _mapLibreMapController.cameraPosition?.target.latitude ?? 0,
        _mapLibreMapController.cameraPosition?.target.longitude ?? 0,
      ),
      zoom: currentZoom + 1,
    );
  }

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
        _mapLibreMapController.cameraPosition?.target.latitude ?? 0,
        _mapLibreMapController.cameraPosition?.target.longitude ?? 0,
      ),
      zoom: _mapLibreMapController.cameraPosition?.zoom ?? 0,
    );
  }

  BaatoCameraPosition? getCameraPosition() {
    final baatoCameraPosition = BaatoCameraPosition(
      target: BaatoCoordinate(
        _mapLibreMapController.cameraPosition?.target.latitude ?? 0,
        _mapLibreMapController.cameraPosition?.target.longitude ?? 0,
      ),
      zoom: _mapLibreMapController.cameraPosition?.zoom ?? 0,
    );
    return baatoCameraPosition;
  }

  BaatoCameraPosition? get lastCameraPosition => _lastCameraPosition;

  void setLastCameraPosition(BaatoCameraPosition? position) {
    _lastCameraPosition = position;
  }
}
