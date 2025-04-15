import 'package:flutter/material.dart';
import 'package:baato_maps/baato_maps.dart';

class BaatoMapView extends StatelessWidget {
  final BaatoCoordinate initialPosition;
  final double initialZoom;
  final String? styleUrl;
  final bool myLocationEnabled;
  static late BaatoMapController mapController;

  BaatoMapView({
    Key? key,
    required this.initialPosition,
    this.initialZoom = 12.0,
    this.styleUrl,
    this.myLocationEnabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BaatoMapWidget(
          initialPosition: BaatoCoordinate(
            initialPosition.latitude,
            initialPosition.longitude,
          ),
          initialZoom: initialZoom,
          initialStyle: styleUrl ?? "http://localhost:8080/styles/breeze.json",
          myLocationEnabled: false,
          onMapCreated: (controller) {
            BaatoMapView.mapController = controller;
          },
          onTap: (point, latLng, features) {
            if (features.isNotEmpty) {
              final firstFeature = features.first;
              mapController.markerManager.addMarker(
                latLng,
                title: firstFeature.name,
              );
            } else {
              mapController.markerManager.addMarker(
                latLng,
                title: "Drop a pin",
              );
            }
          },
          onLongPress: (point, latLng, features) {
            if (features.isNotEmpty) {
              final firstFeature = features.first;
              mapController.markerManager.addMarker(
                latLng,
                title: firstFeature.name ?? "N/A",
              );
            } else {
              mapController.markerManager.addMarker(
                latLng,
                title: "Drop a pin",
              );
            }
          },
        ),
        Positioned(
          bottom: 286.0,
          right: 16.0,
          child: FloatingActionButton(
            onPressed: () {
              mapController.markerManager.clearMarkers();
            },
            backgroundColor: Colors.white,
            child: const Icon(Icons.my_location, color: Colors.blue),
          ),
        ),
      ],
    );
  }
}
