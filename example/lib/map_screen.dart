import 'package:example/baato_map_view.dart';
import 'package:example/bottom_sheet/bottom_sheet_controller.dart';
import 'package:example/bottom_sheet/flutter_bottom_sheet.dart';
import 'package:example/bottom_sheet/widgets/place_detail_bottom_sheet.dart';
import 'package:example/bottom_sheet/widgets/route_detail_bottom_sheet.dart';
import 'package:example/bottom_sheet/widgets/search_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:baato_maps/baato_maps.dart';

/// A widget that displays the main map interface with a bottom sheet.
///
/// This screen combines the [BaatoMapView] with an interactive bottom sheet
/// that can show search, place details, or route information.
class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

/// State for the [MapScreen] widget.
///
/// Manages the map style and bottom sheet controller, and builds
/// the UI combining the map view with the appropriate bottom sheet content.
class _MapScreenState extends State<MapScreen> {
  final BaatoMapStyle _currentStyle = BaatoMapStyle.breeze;

  final BottomSheetController _sheetController = BottomSheetController(
    bottomSheetType: SearchBottomSheet(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FlutterBottomSheet(
      body: BaatoMapView(
        initialPosition: BaatoCoordinate(
          latitude: 27.7172,
          longitude: 85.3240,
        ),
        style: _currentStyle,
      ),
      controller: _sheetController,
      builder: (context, type) {
        if (type is SearchBottomSheet) {
          return SearchBottomSheetWidget(
            controller: _sheetController,
            onSearch: (query) {},
            onSuggestionSelected: (suggestion) {},
            getSuggestions: (query) => [],
          );
        } else if (type is PlaceDetailBottomSheet) {
          return PlaceDetailBottomSheetWidget(
            controller: _sheetController,
            title: type.title,
            address: type.address,
            distance: type.distance,
            coordinates: type.coordinates,
          );
        } else if (type is RouteDetailBottomSheet) {
          return RouteDetailBottomSheetWidget(
            controller: _sheetController,
            mapController: BaatoMapView.mapController,
            destinationCoordinates: type.destinationCoordinates,
          );
        }

        return Container();
      },
    ));
  }
}
