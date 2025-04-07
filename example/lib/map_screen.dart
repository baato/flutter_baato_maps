import 'package:example/baato_map_view.dart';
import 'package:example/bottom_sheet/bottom_sheet_controller.dart';
import 'package:example/bottom_sheet/flutter_bottom_sheet.dart';
import 'package:example/bottom_sheet/widgets/place_detail_bottom_sheet.dart';
import 'package:example/bottom_sheet/widgets/route_detail_bottom_sheet.dart';
import 'package:example/bottom_sheet/widgets/search_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:baato_maps/baato_maps.dart';
import 'dart:async';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late ServerManager _serverManager;
  String _currentStyle = 'd';
  bool _isServerRunning = true;

  @override
  void initState() {
    super.initState();
    _serverManager = ServerManager();
    // Set the context after the widget is built
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _serverManager.setContext(context);
    //   _startServerAndLoadStyle();
    // });
  }

  @override
  void dispose() {
    _serverManager.stopServer();
    super.dispose();
  }

  Future<void> _startServerAndLoadStyle() async {
    // Start the server
    await _serverManager.startServer();
    setState(() {
      _isServerRunning = _serverManager.isRunning;
    });

    // Load the style from the local server
    if (_isServerRunning) {
      await _loadLocalStyle();
    }
  }

  Future<void> _loadLocalStyle() async {
    try {
      const styleUrl = 'http://localhost:8080/styles/breeze.json';
      setState(() {
        _currentStyle = styleUrl;
      });
      print("Using local server style: $styleUrl");
    } catch (e) {
      print("Error loading local style: $e");
      setState(() {
        _currentStyle = '';
      });
    }
  }

  Future<void> _toggleServer() async {
    if (_isServerRunning) {
      await _serverManager.stopServer();
    } else {
      await _serverManager.startServer();
      if (_serverManager.isRunning) {
        await _loadLocalStyle();
      }
    }
    setState(() {
      _isServerRunning = _serverManager.isRunning;
    });
  }

  final BottomSheetController _sheetController = BottomSheetController(
    bottomSheetType: SearchBottomSheet(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _currentStyle.isNotEmpty
              ? FlutterBottomSheet(
                body: BaatoMapView(
                  initialPosition: BaatoCoordinate(27.7172, 85.3240),
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
              )
              : const Center(child: CircularProgressIndicator()),
    );
  }
}
