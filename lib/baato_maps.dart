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
library;

export 'src/map/baato_map.dart';
export 'src/map/baato_map_controller.dart';
export 'src/widgets/widgets.dart';
export 'package:baato_api/baato_api.dart';
export 'src/model/baato_model.dart';
export 'src/baato.dart';
export 'src/constants/baato_map_style.dart';
export 'package:maplibre_gl/maplibre_gl.dart' hide Annotation;
