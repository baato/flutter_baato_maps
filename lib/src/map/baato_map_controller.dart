import 'package:baato_maps/src/constants/baato_markers.dart';
import 'package:baato_maps/src/map_core/camera_manager.dart';
import 'package:baato_maps/src/map_core/coordinate_converter.dart';
import 'package:baato_maps/src/map_core/geo_json_manager.dart';
import 'package:baato_maps/src/map_core/marker_manager.dart';
import 'package:baato_maps/src/map_core/route_manager.dart';
import 'package:baato_maps/src/map_core/shape_manager.dart';
import 'package:baato_maps/src/map_core/style_manager.dart';
import 'package:flutter/services.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

/// Base controller for managing the Baato map.
class BaatoMapController {
  MapLibreMapController? _controller;

  late final CameraManager? cameraManager;
  late final MarkerManager markerManager;
  late final ShapeManager shapeManager;
  late final GeoJsonManager geoJsonManager;
  late final StyleManager styleManager;
  late final CoordinateConverter coordinateConverter;
  late final RouteManager routeManager;

  BaatoMapController(String initialStyle) {
    styleManager = StyleManager(initialStyle: initialStyle);
  }

  Future<void> setController(MapLibreMapController controller) async {
    _controller = controller;
    if (_controller == null) throw Exception('Controller not initialized');
    cameraManager = CameraManager(_controller!);
    markerManager = MarkerManager(_controller!);
    shapeManager = ShapeManager(_controller!);
    geoJsonManager = GeoJsonManager(_controller!);
    coordinateConverter = CoordinateConverter(_controller!);
    routeManager = RouteManager(_controller!);
    await _addDefaultAssets();
  }

  Future<void> _addDefaultAssets() async {
    final ByteData bytes = await rootBundle.load(
      BaatoMarker.baatoDefault.assetPath,
    );
    final Uint8List imageBytes = bytes.buffer.asUint8List();
    await _controller!.addImage("custom_marker", imageBytes);
  }

  MapLibreMapController? get rawController => _controller;

  void dispose() {
    styleManager.dispose();
  }
}
