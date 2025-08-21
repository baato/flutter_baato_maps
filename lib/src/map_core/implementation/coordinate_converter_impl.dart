import 'dart:math';
import 'dart:ui';
import 'package:baato_api/baato_api.dart';
import 'package:baato_maps/src/map_core/map_core.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

/// A utility class that handles coordinate conversions between screen positions and geographic coordinates.
///
/// This class provides methods to convert between screen coordinates (as [Offset]s) and
/// geographic coordinates (as [BaatoCoordinate]s) using the MapLibre map controller.
///
/// The coordinate converter is an essential component for interactive map features
/// such as placing markers at tap locations, determining what geographic features
/// are under a user's finger, and implementing custom UI overlays that need to
/// align with map features.
class CoordinateConverterImpl implements CoordinateConverter {
  /// The underlying MapLibre map controller used for coordinate conversions
  final MaplibreMapController _mapLibreMapController;

  /// Creates a new CoordinateConverter with the specified MapLibre controller
  ///
  /// [_mapLibreMapController] is the MapLibre controller that will be used
  /// for all coordinate conversion operations
  CoordinateConverterImpl(this._mapLibreMapController);

  @override
  Future<BaatoCoordinate?> toLatLng(Offset screenLocation) async {
    final point = await _mapLibreMapController.toLatLng(
      Point(screenLocation.dx, screenLocation.dy),
    );
    return BaatoCoordinate(
      latitude: point.latitude,
      longitude: point.longitude,
    );
  }

  @override
  Future<Offset?> toScreenLocation(BaatoCoordinate coordinate) async {
    final latLng = LatLng(coordinate.latitude, coordinate.longitude);
    final point = await _mapLibreMapController.toScreenLocation(latLng);
    return Offset(point.x.toDouble(), point.y.toDouble());
  }
}
