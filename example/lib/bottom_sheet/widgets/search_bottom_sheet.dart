import 'package:baato_maps/baato_maps.dart';
import 'package:example/baato_map_view.dart';
import 'package:example/bottom_sheet/bottom_sheet_controller.dart';
import 'package:example/bottom_sheet/bottom_sheet_position.dart';
import 'package:example/bottom_sheet/widgets/place_detail_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:example/bottom_sheet/bottom_sheet_type.dart';

class SearchBottomSheet extends BottomSheetType {}

class SearchBottomSheetWidget extends StatefulWidget {
  final BottomSheetController controller;
  final Function(String) onSearch;
  final Function(String) onSuggestionSelected;
  final List<String> Function(String) getSuggestions;

  const SearchBottomSheetWidget({
    Key? key,
    required this.onSearch,
    required this.onSuggestionSelected,
    required this.getSuggestions,
    required this.controller,
  }) : super(key: key);

  @override
  State<SearchBottomSheetWidget> createState() =>
      _SearchBottomSheetWidgetState();
}

class _SearchBottomSheetWidgetState extends State<SearchBottomSheetWidget> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _suggestions = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    if (query.isNotEmpty) {
      setState(() {
        _isSearching = true;
        _suggestions = widget.getSuggestions(query);
      });
    } else {
      setState(() {
        _isSearching = false;
        _suggestions = [];
      });
    }
  }

  void _handleSearch() {
    if (_searchController.text.isNotEmpty) {
      widget.onSearch(_searchController.text);
      FocusScope.of(context).unfocus();
    }
  }

  void _handleSuggestionTap(String suggestion) {
    _searchController.text = suggestion;
    widget.onSuggestionSelected(suggestion);
    setState(() {
      _suggestions = [];
      _isSearching = false;
    });
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final topPadding = MediaQuery.of(context).padding.top;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: BaatoPlaceAutoSuggestion(
            hintText: 'Search for a place',
            onPlaceSelected: (suggestion) {},
            currentCoordinate: BaatoCoordinate(
              latitude: 27.7172,
              longitude: 85.3240,
            ),
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
              BaatoMapView.mapController.cameraManager?.moveTo(
                BaatoCoordinate(
                  latitude: place.centroid.latitude,
                  longitude: place.centroid.longitude,
                ),
              );
              widget.controller.updateBottomSheetType(
                PlaceDetailBottomSheet(
                  title: place.name,
                  address: place.address,
                  distance: '100m',
                  coordinates: LatLng(
                    place.centroid.latitude,
                    place.centroid.longitude,
                  ),
                ),
              );
              // Adjust bottom sheet position when keyboard is visible
              if (MediaQuery.of(context).viewInsets.bottom > 0) {
                widget.controller.snapToPosition(BottomSheetPosition.base);
              }
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.add_location),
              onPressed: () {
                if (BaatoMapView.markers.length < 3) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please add at least three markers'),
                    ),
                  );
                  return;
                }
                BaatoMapView.mapController.shapeManager.addFill(
                  BaatoMapView.markers,
                  options: BaatoFillOptions(
                    fillColor: "#00FF00",
                    fillOpacity: 0.3,
                    fillOutlineColor: "#00FF00",
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.circle),
              onPressed: () {
                if (BaatoMapView.markers.length < 1) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please add at least one marker'),
                    ),
                  );
                  return;
                }
                final index = BaatoMapView.markers.length - 1;
                BaatoMapView.mapController.shapeManager.addCircle(
                  BaatoCircleOptions(
                    center: BaatoMapView.markers[index],
                    circleRadius: 100,
                    circleColor: "#00FF00",
                    circleOpacity: 0.3,
                    circleStrokeColor: "#00FF00",
                    circleStrokeWidth: 10,
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.timeline),
              onPressed: () {
                if (BaatoMapView.markers.length < 3) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please add at least three markers'),
                    ),
                  );
                  return;
                }
                final index = BaatoMapView.markers.length - 1;
                BaatoMapView.mapController.shapeManager.addMultiLine(
                  [
                    BaatoCoordinate(
                      latitude: BaatoMapView.markers[index - 2].latitude,
                      longitude: BaatoMapView.markers[index - 2].longitude,
                    ),
                    BaatoCoordinate(
                      latitude: BaatoMapView.markers[index - 1].latitude,
                      longitude: BaatoMapView.markers[index - 1].longitude,
                    ),
                    BaatoCoordinate(
                      latitude: BaatoMapView.markers[index].latitude,
                      longitude: BaatoMapView.markers[index].longitude,
                    ),
                  ],
                  options: BaatoLineOptions(
                    lineColor: '#081E2A',
                    lineWidth: 10.0,
                    lineOpacity: 0.5,
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.linear_scale),
              onPressed: () {
                // Add a line to the map
                if (BaatoMapView.markers.length < 2) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please add at least two markers'),
                    ),
                  );
                  return;
                }
                final index = BaatoMapView.markers.length - 1;
                BaatoMapView.mapController.shapeManager.addLine(
                  BaatoCoordinate(
                    latitude: BaatoMapView.markers[index - 1].latitude,
                    longitude: BaatoMapView.markers[index - 1].longitude,
                  ),
                  BaatoCoordinate(
                    latitude: BaatoMapView.markers[index].latitude,
                    longitude: BaatoMapView.markers[index].longitude,
                  ),
                  options: BaatoLineOptions(
                    lineColor: '#081E2A',
                    lineWidth: 10.0,
                    lineOpacity: 0.5,
                    draggable: true,
                  ),
                );
              },
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.directions_car),
              onPressed: () async {
                if (BaatoMapView.markers.length < 2) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please add at least two markers'),
                    ),
                  );
                  return;
                }
                final index = BaatoMapView.markers.length - 1;
                final route = await Baato.api.direction.getRoutes(
                  startCoordinate: BaatoCoordinate(
                    latitude: BaatoMapView.markers[index - 1].latitude,
                    longitude: BaatoMapView.markers[index - 1].longitude,
                  ),
                  endCoordinate: BaatoCoordinate(
                    latitude: BaatoMapView.markers[index].latitude,
                    longitude: BaatoMapView.markers[index].longitude,
                  ),
                  mode: BaatoDirectionMode.car,
                  decodePolyline: true,
                );
                BaatoMapView.mapController.routeManager.drawRoute(route);
              },
            ),
          ],
        ),
        Spacer(),
        IconButton(
          icon: Icon(Icons.clear),
          color: Colors.red,
          iconSize: 32,
          onPressed: () {
            BaatoMapView.markers.clear();
            BaatoMapView.mapController.shapeManager.clearLines();
            BaatoMapView.mapController.markerManager.clearMarkers();
            BaatoMapView.mapController.shapeManager.clearFills();
            BaatoMapView.mapController.shapeManager.clearCircles();
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
