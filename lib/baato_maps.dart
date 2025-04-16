/// A Flutter package for integrating Baato Maps into Flutter applications.
///
/// This package provides widgets and utilities for displaying interactive maps,
/// handling map operations, and integrating with Baato's mapping services.
///
/// The main components include:
/// - [BaatoMapWidget]: The core widget for displaying maps
/// - [BaatoMapController]: Controller for map operations
/// - Various utility widgets and style configurations
/// - Integration with the Baato API for additional services

export 'src/map/baato_map_widget.dart';
export 'src/map/baato_map_controller.dart';
export 'src/widgets/widgets.dart';
export 'package:baato_api/baato_api.dart';
export 'src/model/baato_model.dart';
export 'src/baato.dart';

export 'package:maplibre_gl/maplibre_gl.dart'
    show
        LatLng,
        CameraPosition,
        LineOptions,
        FillOptions,
        SymbolOptions,
        Symbol;
