import 'package:flutter/material.dart';
import 'package:baato_maps/baato_maps.dart';

class BaatoMapView extends StatelessWidget {
  final LatLng initialPosition;
  final double initialZoom;
  final String? styleUrl;
  final bool myLocationEnabled;
  static late BaatoMapController mapController;

  BaatoMapView({
    Key? key,
    this.initialPosition = const LatLng(27.7172, 85.3240),
    this.initialZoom = 12.0,
    this.styleUrl,
    this.myLocationEnabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BaatoMapWidget(
          initialPosition: initialPosition,
          initialZoom: initialZoom,
          initialStyle: styleUrl ?? "http://localhost:8080/styles/breeze.json",
          myLocationEnabled: myLocationEnabled,
          onMapCreated: (controller) {
            BaatoMapView.mapController = controller;
          },
          onTap: (point, latLng, features) {
            if (features.isNotEmpty) {
              final firstFeature = features.first;
              mapController.addMarker(latLng, title: firstFeature.name);
            } else {
              mapController.addMarker(latLng, title: "Drop a pin");
            }
          },
          onLongPress: (point, latLng, features) {
            if (features.isNotEmpty) {
              final firstFeature = features.first;
              mapController.addMarker(
                latLng,
                title: firstFeature.name ?? "N/A",
              );
            } else {
              mapController.addMarker(latLng, title: "Drop a pin");
            }
          },
        ),
        Positioned(
          bottom: 286.0,
          right: 16.0,
          child: FloatingActionButton(
            onPressed: () {
              mapController.clearMarkers();
            },
            backgroundColor: Colors.white,
            child: const Icon(Icons.my_location, color: Colors.blue),
          ),
        ),
      ],
    );
  }
}
