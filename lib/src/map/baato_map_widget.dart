import 'dart:math';

import 'package:baato_api/baato_api.dart';
import 'package:baato_maps/src/model/baato_map_feature.dart';
import 'package:baato_maps/src/model/camera_position.dart';
import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:baato_maps/src/map/baato_map_controller.dart';

class BaatoMapWidget extends StatefulWidget {
  final BaatoCoordinate initialPosition;
  final double initialZoom;
  final String initialStyle;
  final bool myLocationEnabled;
  final List<String> poiLayerContainIds;
  final bool enableLayerDetection;
  final Function(BaatoMapController)? onMapCreated;
  final void Function(Point<double>, BaatoCoordinate, List<BaatoMapFeature>)?
  onTap;
  final void Function(Point<double>, BaatoCoordinate, List<BaatoMapFeature>)?
  onLongPress;

  const BaatoMapWidget({
    super.key,
    required this.initialPosition,
    this.initialZoom = 10.0,
    this.initialStyle = 'https://tiles.stadiamaps.com/styles/outdoors.json',
    this.myLocationEnabled = false,
    this.poiLayerContainIds = const ["Poi", "BusStop"],
    this.enableLayerDetection = true,
    this.onMapCreated,
    this.onTap,
    this.onLongPress,
  });

  @override
  State<BaatoMapWidget> createState() => _BaatoMapWidgetState();
}

class _BaatoMapWidgetState extends State<BaatoMapWidget> {
  late BaatoMapController _baatoController;
  List<String> poiLayers = [];

  @override
  void initState() {
    _baatoController = BaatoMapController(widget.initialStyle);

    super.initState();
  }

  @override
  void dispose() {
    _baatoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: _baatoController.styleManager.styleNotifier,
      builder: (context, style, child) {
        final lastCameraPosition = null;
        final cameraPosition = CameraPosition(
          target: LatLng(
            lastCameraPosition?.target.latitude ??
                widget.initialPosition.latitude,
            lastCameraPosition?.target.longitude ??
                widget.initialPosition.longitude,
          ),
          zoom: lastCameraPosition?.zoom ?? widget.initialZoom,
        );
        return MapLibreMap(
          key: ValueKey(style),
          initialCameraPosition: cameraPosition,
          styleString: style,
          myLocationEnabled: widget.myLocationEnabled,
          trackCameraPosition: true,
          onMapCreated: (controller) async {
            await _baatoController.setController(controller);
            if (widget.enableLayerDetection) {
              await findPOILayers();
            }
            widget.onMapCreated?.call(_baatoController);
          },
          onMapClick: (point, latLng) async {
            final List<BaatoMapFeature> features =
                widget.enableLayerDetection ? (await _queryPOI(point)) : [];
            widget.onTap?.call(
              point,
              BaatoCoordinate(latLng.latitude, latLng.longitude),
              features,
            );
          },
          onMapLongClick: (point, latLng) async {
            final List<BaatoMapFeature> features =
                widget.enableLayerDetection ? await _queryPOI(point) : [];
            widget.onLongPress?.call(
              point,
              BaatoCoordinate(latLng.latitude, latLng.longitude),
              features,
            );
          },
          onCameraIdle: () {
            final position = _baatoController.rawController?.cameraPosition;
            if (position != null) {
              _baatoController.cameraManager?.setLastCameraPosition(
                BaatoCameraPosition(
                  target: BaatoCoordinate(
                    position.target.latitude,
                    position.target.longitude,
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }

  Future<List<BaatoMapFeature>> _queryPOI(Point<double> point) async {
    final mapLibreController = _baatoController.rawController;
    if (mapLibreController == null) return [];

    List<dynamic> mapFeatures = await mapLibreController.queryRenderedFeatures(
      point,
      poiLayers,
      null,
    );

    final features =
        mapFeatures
            .map(
              (e) => BaatoMapFeature.fromMapFeature(e, null),
            ) //TODO: Add user location
            .toList();

    return features;
  }

  Future<void> findPOILayers() async {
    this.poiLayers = [];
    final mapLibreController = _baatoController.rawController;
    if (mapLibreController == null) return;

    List<String> layers =
        (await mapLibreController.getLayerIds())
            .map((e) => e.toString())
            .toList();

    List<String> poiLayers =
        layers
            .where(
              (layer) => widget.poiLayerContainIds.any(
                (text) => layer.startsWith(text),
              ),
            )
            .toList();

    if (poiLayers.isEmpty) {
      return;
    }

    this.poiLayers = poiLayers;
  }
}
