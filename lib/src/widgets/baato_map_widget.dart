import 'dart:math';

import 'package:baato_maps/src/model/baato_map_feature.dart';
import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:baato_maps/src/baato_map_controller.dart';

class BaatoMapWidget extends StatefulWidget {
  final LatLng initialPosition;
  final double initialZoom;
  final String initialStyle;
  final bool myLocationEnabled;
  final List<String> poiLayerContainIds;
  final Function(BaatoMapController)? onMapCreated;
  final void Function(Point<double>, LatLng, List<BaatoMapFeature>)? onTap;
  final void Function(Point<double>, LatLng, List<BaatoMapFeature>)?
  onLongPress;

  const BaatoMapWidget({
    super.key,
    required this.initialPosition,
    this.initialZoom = 10.0,
    this.initialStyle = 'https://tiles.stadiamaps.com/styles/outdoors.json',
    this.myLocationEnabled = false,
    this.poiLayerContainIds = const ["Poi", "BusStop"],
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
    _baatoController = BaatoMapController(
      widget.initialStyle,
      lastCameraPosition: CameraPosition(
        target: widget.initialPosition,
        zoom: widget.initialZoom,
      ),
    );
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
      valueListenable: _baatoController.styleNotifier,
      builder: (context, style, child) {
        return MapLibreMap(
          key: ValueKey(style),
          initialCameraPosition:
              _baatoController.lastCameraPosition ??
              CameraPosition(
                target: widget.initialPosition,
                zoom: widget.initialZoom,
              ),
          styleString: style,
          myLocationEnabled: widget.myLocationEnabled,
          trackCameraPosition: true,
          onMapCreated: (controller) async {
            await _baatoController.setController(controller);
            await findPOILayers();
            widget.onMapCreated?.call(_baatoController);
          },
          onMapClick: (point, latLng) async {
            final features = await _queryPOI(point);
            widget.onTap?.call(point, latLng, features);
          },
          onMapLongClick: (point, latLng) async {
            final features = await _queryPOI(point);
            widget.onLongPress?.call(point, latLng, features);
          },
          onCameraIdle: () {
            final position = _baatoController.rawController?.cameraPosition;
            if (position != null) {
              _baatoController.lastCameraPosition = position;
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
