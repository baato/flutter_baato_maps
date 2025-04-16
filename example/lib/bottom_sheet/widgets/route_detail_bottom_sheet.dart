import 'package:example/bottom_sheet/bottom_sheet_position.dart';
import 'package:flutter/material.dart';
import 'package:baato_maps/baato_maps.dart';
import 'package:example/bottom_sheet/bottom_sheet_controller.dart';
import 'package:example/bottom_sheet/bottom_sheet_type.dart';

class RouteDetailBottomSheet extends BottomSheetType {
  final LatLng destinationCoordinates;

  RouteDetailBottomSheet({required this.destinationCoordinates});
}

class RouteDetailBottomSheetWidget extends StatefulWidget {
  final BottomSheetController controller;
  final BaatoMapController mapController;
  final LatLng destinationCoordinates;
  final Function(LatLng, LatLng, String)? onRouteRequest;

  const RouteDetailBottomSheetWidget({
    Key? key,
    required this.controller,
    required this.mapController,
    required this.destinationCoordinates,
    this.onRouteRequest,
  }) : super(key: key);

  @override
  State<RouteDetailBottomSheetWidget> createState() =>
      _RouteDetailBottomSheetWidgetState();
}

class _RouteDetailBottomSheetWidgetState
    extends State<RouteDetailBottomSheetWidget> {
  LatLng? _startCoordinates;
  LatLng? _endCoordinates;
  String _selectedMode = 'car';
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _endCoordinates = widget.destinationCoordinates;
  }

  @override
  void dispose() {
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }

  void _requestRoute() async {
    if (_startCoordinates != null && _endCoordinates != null) {
      widget.onRouteRequest?.call(
        _startCoordinates!,
        _endCoordinates!,
        _selectedMode,
      );

      final route = await Baato.api.direction.getRoutes(
        startCoordinate: BaatoCoordinate(
          latitude: _startCoordinates!.latitude,
          longitude: _startCoordinates!.longitude,
        ),
        endCoordinate: BaatoCoordinate(
          latitude: _endCoordinates!.latitude,
          longitude: _endCoordinates!.longitude,
        ),
        mode: BaatoDirectionMode.car,
        decodePolyline: true,
      );
      widget.mapController.routeManager.drawRoute(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Route Details',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Start location input
          BaatoPlaceAutoSuggestion(
            hintText: 'Search for a place',
            onPlaceSelected: (suggestion) {},
            suggestionsHeader: Container(
              color: Colors.white.withOpacity(0.8),
              child: Text('Suggestions'),
            ),
            suggestionsFooter: Container(
              color: Colors.white.withOpacity(0.8),
              child: Text('Footer'),
            ),
            inputDecoration: InputDecoration(
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
            onFocusChanged: (hasFocus) {
              if (hasFocus) {
                widget.controller.snapToPosition(BottomSheetPosition.expanded);
              } else {
                widget.controller.snapToPosition(BottomSheetPosition.base);
              }
            },
            onPlaceDetailsRetrieved: (place) {
              setState(() {
                _startCoordinates = LatLng(
                  place.centroid.latitude,
                  place.centroid.longitude,
                );
                _startController.text = place.name;
              });
              _requestRoute();
            },
          ),

          const SizedBox(height: 12),

          // End location input
          BaatoPlaceAutoSuggestion(
            hintText: 'Search for a place',
            onPlaceSelected: (suggestion) {},
            suggestionsHeader: Container(
              color: Colors.white.withOpacity(0.8),
              child: Text('Suggestions'),
            ),
            suggestionsFooter: Container(
              color: Colors.white.withOpacity(0.8),
              child: Text('Footer'),
            ),
            inputDecoration: InputDecoration(
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
            onFocusChanged: (hasFocus) {
              if (hasFocus) {
                widget.controller.snapToPosition(BottomSheetPosition.expanded);
              } else {
                widget.controller.snapToPosition(BottomSheetPosition.base);
              }
            },
            onPlaceDetailsRetrieved: (place) {
              setState(() {
                _endCoordinates = LatLng(
                  place.centroid.latitude,
                  place.centroid.longitude,
                );
                _endController.text = place.name;
              });
              _requestRoute();
            },
          ),

          const SizedBox(height: 24),

          // Transportation mode selector
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildModeTab('car', Icons.directions_car),
                _buildModeTab('walk', Icons.directions_walk),
                _buildModeTab('bike', Icons.pedal_bike),
                _buildModeTab('cycle', Icons.directions_bike),
                _buildModeTab('bus', Icons.directions_bus),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Route button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _requestRoute,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Get Directions',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeTab(String mode, IconData icon) {
    final isSelected = _selectedMode == mode;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMode = mode;
        });
        _requestRoute();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.black54,
          size: 24,
        ),
      ),
    );
  }
}
