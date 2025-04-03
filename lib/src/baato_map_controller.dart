import 'dart:math';

import 'package:baato_api/baato_api.dart';
import 'package:baato_maps/src/constants/baato_markers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

/// Controller for managing the Baato map.
class BaatoMapController {
  MapLibreMapController? _controller;
  final ValueNotifier<String> styleNotifier;
  CameraPosition? lastCameraPosition;

  /// Constructor for initializing the BaatoMapController.
  BaatoMapController(String initialStyle, {this.lastCameraPosition})
    : styleNotifier = ValueNotifier(initialStyle);

  /// Sets the MapLibreMapController and adds default assets.
  Future<void> setController(MapLibreMapController controller) async {
    _controller = controller;
    _addDefaultAssets();
  }

  /// Adds default assets to the map.
  Future<void> _addDefaultAssets() async {
    final ByteData bytes = await rootBundle.load(
      BaatoMarker.baatoDefault.assetPath,
    );
    final Uint8List imageBytes = bytes.buffer.asUint8List();
    await _controller!.addImage("custom_marker", imageBytes);
  }

  /// Moves the camera to the specified position.
  Future<void> moveTo(
    LatLng position, {
    double? zoom,
    bool animate = true,
  }) async {
    if (_controller == null) throw Exception('Controller not initialized');
    final cameraUpdate = CameraUpdate.newCameraPosition(
      CameraPosition(
        target: position,
        zoom: zoom ?? _controller!.cameraPosition?.zoom ?? 10.0,
      ),
    );
    if (animate) {
      await _controller!.animateCamera(cameraUpdate);
    } else {
      await _controller!.moveCamera(cameraUpdate);
    }
    lastCameraPosition = _controller!.cameraPosition;
  }

  /// Adds a marker to the map at the specified position.
  Future<Symbol> addMarker(
    LatLng position, {
    String? iconImage,
    double? iconSize,
    String? title,
    String? textColor,
    String? textHaloColor,
    double? textHaloWidth,
    double? textSize,
    Offset? textOffset,
  }) async {
    if (_controller == null) throw Exception('Controller not initialized');
    return await _controller!.addSymbol(
      SymbolOptions(
        geometry: position,
        iconImage: "custom_marker",
        iconSize: iconSize,
        // ✅ Text Properties
        textField: title,
        textSize: textSize,
        textOffset: textOffset ?? const Offset(0, 2),
        textColor: textColor ?? "#FF0000",
        textHaloColor: textHaloColor ?? "#FFFFFF",
        textHaloWidth: textHaloWidth ?? 2.0,
        fontNames: ["OpenSans"],
      ),
    );
  }

  /// Clears all markers from the map.
  Future<void> clearMarkers() async {
    if (_controller == null) throw Exception('Controller not initialized');
    await _controller!.clearSymbols();
  }

  /// Clears symbols from the map based on the given ids.
  Future<void> clearSymbolsByIds(List<String> ids) async {
    if (_controller == null) throw Exception('Controller not initialized');
    final symbols = await _controller!.symbols;
    final symbolsToRemove =
        symbols.where((symbol) => ids.contains(symbol.id)).toList();
    for (var symbol in symbolsToRemove) {
      await _controller!.removeSymbol(symbol);
    }
  }

  /// Adds a polyline to the map with the specified points.
  Future<Line> addPolyline(List<LatLng> points) async {
    if (_controller == null) throw Exception('Controller not initialized');
    return await _controller!.addLine(
      LineOptions(geometry: points, lineColor: "#ff0000", lineWidth: 2.0),
    );
  }

  /// Zooms the camera to fit the given bounds with padding.
  Future<void> fitBounds(LatLngBounds bounds, {EdgeInsets? padding}) async {
    if (_controller == null) throw Exception('Controller not initialized');
    await _controller!.animateCamera(
      CameraUpdate.newLatLngBounds(
        bounds,
        left: padding?.left ?? 100,
        top: padding?.top ?? 100,
        right: padding?.right ?? 100,
        bottom: padding?.bottom ?? 100,
      ),
    );
    lastCameraPosition = _controller!.cameraPosition;
  }

  /// Zooms the camera in by one zoom level.
  Future<void> zoomIn() async {
    if (_controller == null) throw Exception('Controller not initialized');
    final currentZoom = _controller!.cameraPosition?.zoom ?? 0;
    await _controller!.animateCamera(CameraUpdate.zoomTo(currentZoom + 1));
    lastCameraPosition = _controller!.cameraPosition;
  }

  /// Zooms the camera out by one zoom level.
  Future<void> zoomOut() async {
    if (_controller == null) throw Exception('Controller not initialized');
    final currentZoom = _controller!.cameraPosition?.zoom ?? 0;
    await _controller!.animateCamera(
      CameraUpdate.zoomTo(max(0, currentZoom - 1)),
    );
    lastCameraPosition = _controller!.cameraPosition;
  }

  /// Gets the current camera position.
  CameraPosition? getCameraPosition() {
    if (_controller == null) return null;
    return _controller!.cameraPosition;
  }

  /// Removes a symbol from the map.
  Future<void> removeSymbol(Symbol symbol) async {
    if (_controller == null) throw Exception('Controller not initialized');
    await _controller!.removeSymbol(symbol);
  }

  /// Removes a line from the map.
  Future<void> removeLine(Line line) async {
    if (_controller == null) throw Exception('Controller not initialized');
    await _controller!.removeLine(line);
  }

  /// Removes a fill from the map.
  Future<void> removeFill(Fill fill) async {
    if (_controller == null) throw Exception('Controller not initialized');
    await _controller!.removeFill(fill);
  }

  /// Clears all symbols from the map.
  Future<void> clearSymbols() async {
    if (_controller == null) throw Exception('Controller not initialized');
    await _controller!.clearSymbols();
  }

  /// Clears all lines from the map.
  Future<void> clearLines() async {
    if (_controller == null) throw Exception('Controller not initialized');
    await _controller!.clearLines();
  }

  /// Clears all fills from the map.
  Future<void> clearFills() async {
    if (_controller == null) throw Exception('Controller not initialized');
    await _controller!.clearFills();
  }

  /// Converts screen coordinates to map coordinates.
  Future<LatLng?> toLatLng(Offset screenLocation) async {
    if (_controller == null) throw Exception('Controller not initialized');
    return await _controller!.toLatLng(
      Point(screenLocation.dx, screenLocation.dy),
    );
  }

  /// Converts map coordinates to screen coordinates.
  Future<Offset?> toScreenLocation(LatLng latLng) async {
    if (_controller == null) throw Exception('Controller not initialized');
    final point = await _controller!.toScreenLocation(latLng);
    return Offset(point.x.toDouble(), point.y.toDouble());
  }

  /// Updates a symbol with new options.
  Future<void> updateSymbol(Symbol symbol, SymbolOptions changes) async {
    if (_controller == null) throw Exception('Controller not initialized');
    await _controller!.updateSymbol(symbol, changes);
  }

  /// Updates a line with new options.
  Future<void> updateLine(Line line, LineOptions changes) async {
    if (_controller == null) throw Exception('Controller not initialized');
    await _controller!.updateLine(line, changes);
  }

  /// Updates a fill with new options.
  Future<void> updateFill(Fill fill, FillOptions changes) async {
    if (_controller == null) throw Exception('Controller not initialized');
    await _controller!.updateFill(fill, changes);
  }

  /// Adds a custom image to the map style.
  Future<void> addImage(String name, Uint8List bytes) async {
    if (_controller == null) throw Exception('Controller not initialized');
    await _controller!.addImage(name, bytes);
  }

  /// Adds a fill to the map with the specified points and options.
  Future<Fill> addFill(
    List<LatLng> points, {
    String? fillColor = "#FFFF00",
    double fillOpacity = 0.5,
    String? outlineColor = "#000000",
  }) async {
    if (_controller == null) throw Exception('Controller not initialized');
    return await _controller!.addFill(
      FillOptions(
        geometry: [points],
        fillColor: fillColor,
        fillOpacity: fillOpacity,
        fillOutlineColor: outlineColor,
      ),
    );
  }

  /// Highlights an area on the map with the specified points.
  Future<Fill> highlightArea(List<LatLng> points) async {
    return await addFill(
      points,
      fillColor: "#00FF00",
      fillOpacity: 0.3,
      outlineColor: "#00FF00",
    );
  }

  /// Adds custom GeoJSON data to the map.
  Future<void> addGeoJson(
    Map<String, dynamic> geoJson, {
    String sourceId = 'custom-geojson',
  }) async {
    if (_controller == null) {
      throw Exception('Controller not initialized');
    }

    await _removeExistingSourceAndLayers(sourceId);

    await _controller!.addGeoJsonSource(sourceId, geoJson);

    final features = (geoJson['features'] as List?) ?? [];
    for (var i = 0; i < features.length; i++) {
      final feature = features[i];
      final geometryType = feature['geometry']['type'] as String;
      final layerId = _generateUniqueLayerId(sourceId, i);

      await _removeLayerIfExists(layerId);

      await _addLayerForGeometryType(sourceId, layerId, geometryType);
    }
  }

  Future<void> _removeExistingSourceAndLayers(String sourceId) async {
    try {
      final layers = await _controller!.getLayerIds();
      for (final layerId in layers) {
        if (layerId.startsWith('$sourceId-')) {
          try {
            await _controller!.removeLayer(layerId);
          } catch (e) {
            // Ignore errors when removing layers
          }
        }
      }
      await _controller!.removeSource(sourceId);
    } catch (e) {
      // Ignore if source doesn't exist or other errors
    }
  }

  String _generateUniqueLayerId(String sourceId, int index) {
    return '$sourceId-$index-${Random().nextInt(1000000)}';
  }

  Future<void> _removeLayerIfExists(String layerId) async {
    try {
      final layers = await _controller!.getLayerIds();
      if (layers.contains(layerId)) {
        await _controller!.removeLayer(layerId);
      }
    } catch (_) {
      // Ignore errors when checking/removing layers
    }
  }

  Future<void> _addLayerForGeometryType(
    String sourceId,
    String layerId,
    String geometryType,
  ) async {
    switch (geometryType) {
      case 'Point':
      case 'MultiPoint':
        await _controller!.addSymbolLayer(
          sourceId,
          layerId,
          const SymbolLayerProperties(iconImage: 'marker-15', iconSize: 1.0),
          filter: [
            '==',
            ['geometry-type'],
            geometryType,
          ],
        );
        break;
      case 'LineString':
      case 'MultiLineString':
        await _controller!.addLineLayer(
          sourceId,
          layerId,
          const LineLayerProperties(lineColor: '#ff0000', lineWidth: 2.0),
          filter: [
            '==',
            ['geometry-type'],
            geometryType,
          ],
        );
        break;
      case 'Polygon':
      case 'MultiPolygon':
        await _controller!.addFillLayer(
          sourceId,
          layerId,
          const FillLayerProperties(
            fillColor: '#FFFF00',
            fillOpacity: 0.5,
            fillOutlineColor: '#000000',
          ),
          filter: [
            '==',
            ['geometry-type'],
            geometryType,
          ],
        );
        break;
    }
  }

  /// Adds an annotation pin with custom properties.
  Future<Symbol> addAnnotationPin(
    LatLng position, {
    String? text,
    String? iconImage,
  }) async {
    if (_controller == null) throw Exception('Controller not initialized');
    return await _controller!.addSymbol(
      SymbolOptions(
        geometry: position,
        iconImage: iconImage ?? BaatoMarker.baatoDefault.assetPath,
        textField: text,
        textOffset: const Offset(0, 1.5), // Corrected to Offset type
        textAnchor: 'top',
        iconSize: 1.0,
      ),
    );
  }

  /// Adds a route between start and end points (simplified example using straight line).
  Future<void> addRoute(LatLng start, LatLng end) async {
    if (_controller == null) throw Exception('Controller not initialized');
    final routePoints = [start, end];
    await addPolyline(routePoints); // Simple straight-line route
    await addMarker(start, iconImage: 'start');
    await addMarker(end, iconImage: 'end');
  }

  /// Gets the current map style.
  String get style => styleNotifier.value;

  /// Sets a new map style.
  Future<void> setStyle(String newStyle) async {
    if (_controller != null) {
      lastCameraPosition = _controller!.cameraPosition;
    }
    styleNotifier.value = newStyle;
  }

  /// Adds a listener for style changes.
  void addStyleListener(VoidCallback listener) {
    styleNotifier.addListener(listener);
  }

  /// Removes a listener for style changes.
  void removeStyleListener(VoidCallback listener) {
    styleNotifier.removeListener(listener);
  }

  /// Draws a route on the map using the BaatoRouteResponse.
  void drawRoute(BaatoRouteResponse route) {
    if ((route.data ?? []).isEmpty)
      throw Exception("No result found");
    else {
      final routeData = route.data?[0];
      if (routeData == null) throw Exception("No route data found");
      //decode the encoded polyline
      List geoCoordinates = BaatoUtils().decodeEncodedPolyline(
        routeData.encodedPolyline!,
      );

      //convert the list into list of LatLng to be used by Mapbox
      List<LatLng> latLngList = [];
      for (GeoCoord geoCoord in geoCoordinates)
        latLngList.add(LatLng(geoCoord.lat, geoCoord.lon));

      //show routes from the points decoded
      rawController?.clearLines();
      rawController?.addLine(
        LineOptions(
          geometry: latLngList,
          lineColor: "#081E2A",
          lineWidth: 10.0,
          lineOpacity: 0.5,
        ),
      );
    }
  }

  /// Gets the raw MapLibreMapController.
  MapLibreMapController? get rawController => _controller;

  /// Disposes the controller and its resources.
  void dispose() {
    styleNotifier.dispose();
  }
}
