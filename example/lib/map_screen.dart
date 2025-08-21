import 'package:example/baato_map_view.dart';
import 'package:example/bottom_sheet/bottom_sheet_controller.dart';
import 'package:example/bottom_sheet/widgets/search_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:baato_maps/baato_maps.dart';

/// A widget that displays the main map interface with a bottom sheet.
///
/// This screen combines the [BaatoMapView] with an interactive bottom sheet
/// that can show search, place details, or route information.
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  MapScreenState createState() => MapScreenState();
}

/// State for the [MapScreen] widget.
///
/// Manages the map style and bottom sheet controller, and builds
/// the UI combining the map view with the appropriate bottom sheet content.
class MapScreenState extends State<MapScreen> {
  final BaatoMapStyle _currentStyle = BaatoMapStyle.defaultStyle;

  final BottomSheetController _sheetController = BottomSheetController(
    bottomSheetType: SearchBottomSheet(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BaatoMapView(
            initialPosition: BaatoCoordinate(
              latitude: 27.7172,
              longitude: 85.3240,
            ),
            style: _currentStyle,
          ),
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Colors.white,
                height: 270,
                child: SearchBottomSheetWidget(
                  controller: _sheetController,
                  onSearch: (query) {},
                  onSuggestionSelected: (suggestion) {},
                  getSuggestions: (query) => [],
                ),
              ))
        ],
      ),
    );
  }
}
