import 'package:flutter/material.dart';
import 'package:baato_maps/baato_maps.dart';

class BaatoMapView extends StatelessWidget {
  final BaatoCoordinate initialPosition;
  final double initialZoom;
  final BaatoMapStyle? style;
  final bool myLocationEnabled;
  static BaatoMapController mapController = BaatoMapController();
  static List<BaatoCoordinate> markers = [];

  const BaatoMapView({
    super.key,
    required this.initialPosition,
    this.initialZoom = 12.0,
    this.style,
    this.myLocationEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    if (style == null) {
      return const Center(
        child: Text('Please provide a style'),
      );
    }
    return Stack(
      children: [
        BaatoMap(
          key: const ValueKey("baato_map"),
          controller: mapController,
          initialPosition: BaatoCoordinate(
            latitude: initialPosition.latitude,
            longitude: initialPosition.longitude,
          ),
          initialZoom: initialZoom,
          style: style ?? BaatoMapStyle.defaultStyle,
          myLocationEnabled: true,
          onMapCreated: (controller) {
            BaatoMapView.mapController = controller;
          },
          onMapClick: (point, coordinate, features) {
            BaatoMapView.markers.add(coordinate);
            if (features.isNotEmpty) {
              final firstFeature = features.first;
              mapController.markerManager.addMarker(
                BaatoSymbolOption(
                    geometry: coordinate, textField: firstFeature.name),
              );
            } else {
              mapController.markerManager.addMarker(
                BaatoSymbolOption(
                    geometry: coordinate, textField: "Drop a pin"),
              );
            }
          },
          onMapLongClick: (point, coordinate, features) {
            if (features.isNotEmpty) {
              final firstFeature = features.first;
              mapController.markerManager.addMarker(
                BaatoSymbolOption(
                    geometry: coordinate,
                    textField: firstFeature.name ?? "N/A"),
              );
            } else {
              mapController.markerManager.addMarker(
                BaatoSymbolOption(
                    geometry: coordinate, textField: "Drop a pin"),
              );
            }
          },
        ),
        Positioned(
          bottom: 286.0,
          right: 16.0,
          child: FloatingActionButton(
            onPressed: () {
              mapController.cameraManager.moveToMyLocation();
            },
            backgroundColor: Colors.white,
            child: const Icon(Icons.my_location, color: Colors.blue),
          ),
        ),
      ],
    );
  }
}
