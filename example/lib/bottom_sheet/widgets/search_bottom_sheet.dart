import 'dart:collection';

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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: BaatoPlaceAutoSuggestion(
            hintText: 'Search for a place',
            onPlaceSelected: (suggestion) {},
            currentCoordinate: BaatoCoordinate(27.7172, 85.3240),
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
                  place.centroid.latitude,
                  place.centroid.longitude,
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
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.add_location),
              onPressed: () {
                // Add GeoJson to the map
                const kathmanduGeoJsonPolygon = {
                  "type": "Feature",
                  "geometry": {
                    "type": "Polygon",
                    "coordinates": [
                      [
                        [27.7172, 85.3240],
                        [85.2911, 27.7000],
                        [85.3333, 27.7000],
                        [85.3333, 27.7500],
                        [85.2911, 27.7500],
                        [85.2911, 27.7000],
                      ],
                    ],
                  },
                  "properties": {"fill": "#088", "fill-opacity": 0.8},
                };
                // BaatoMapView.mapController.addGeoJson(kathmanduGeoJsonPolygon);
              },
            ),
            IconButton(
              icon: Icon(Icons.timeline),
              onPressed: () {
                // Add a polyline to the map
                BaatoMapView.mapController.shapeManager.addLine(
                  LineOptions(
                    geometry: [
                      LatLng(27.7172, 85.3240),
                      LatLng(27.7182, 85.3250),
                      LatLng(27.7192, 85.3260),
                    ],
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.linear_scale),
              onPressed: () {
                // Add a line to the map
                BaatoMapView.mapController.shapeManager.addLine(
                  LineOptions(
                    geometry: [
                      LatLng(27.7172, 85.3240),
                      LatLng(27.7182, 85.3250),
                      LatLng(27.7192, 85.3260),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
