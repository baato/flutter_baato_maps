import 'package:flutter/material.dart';
import 'package:baato_maps/baato_maps.dart';

class BaatoMapView extends StatelessWidget {
  final BaatoCoordinate initialPosition;
  final double initialZoom;
  final String? styleUrl;
  final bool myLocationEnabled;
  static late BaatoMapController mapController;
  static List<BaatoCoordinate> markers = [];

  BaatoMapView({
    Key? key,
    required this.initialPosition,
    this.initialZoom = 12.0,
    this.styleUrl,
    this.myLocationEnabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (styleUrl == null) {
      return const Center(
        child: Text('Please provide a style URL'),
      );
    }
    return Stack(
      children: [
        BaatoMapWidget(
          initialPosition: BaatoCoordinate(
            latitude: initialPosition.latitude,
            longitude: initialPosition.longitude,
          ),
          initialZoom: initialZoom,
          initialStyle: styleUrl!,
          myLocationEnabled: true,
          onMapCreated: (controller) {
            BaatoMapView.mapController = controller;
          },
          onTap: (point, coordinate, features) {
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
          onLongPress: (point, coordinate, features) {
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
              mapController.cameraManager?.moveToMyLocation();
            },
            backgroundColor: Colors.white,
            child: const Icon(Icons.my_location, color: Colors.blue),
          ),
        ),
      ],
    );
  }
}
