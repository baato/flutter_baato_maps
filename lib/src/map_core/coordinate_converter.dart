import 'dart:math';
import 'dart:ui';
import 'package:baato_api/baato_api.dart';
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
class CoordinateConverter {
  /// The underlying MapLibre map controller used for coordinate conversions
  final MapLibreMapController _mapLibreMapController;

  /// Creates a new CoordinateConverter with the specified MapLibre controller
  ///
  /// [_mapLibreMapController] is the MapLibre controller that will be used
  /// for all coordinate conversion operations
  CoordinateConverter(this._mapLibreMapController);

  /// Converts a screen location to geographic coordinates.
  ///
  /// This method translates a point on the screen (such as a tap location) to its
  /// corresponding geographic location on the map.
  ///
  /// Parameters:
  /// - [screenLocation]: The screen position as an [Offset]
  ///
  /// Returns a [Future] that completes with the corresponding [BaatoCoordinate],
  /// or null if the conversion fails.
  ///
  /// Example:
  /// ```dart
  /// void onTap(Offset tapPosition) async {
  ///   final coordinate = await coordinateConverter.toLatLng(tapPosition);
  ///   if (coordinate != null) {
  ///     // Use the geographic coordinate
  ///   }
  /// }
  /// ```
  Future<BaatoCoordinate?> toLatLng(Offset screenLocation) async {
    final point = await _mapLibreMapController.toLatLng(
      Point(screenLocation.dx, screenLocation.dy),
    );
    return BaatoCoordinate(
      latitude: point.latitude,
      longitude: point.longitude,
    );
  }

  /// Converts geographic coordinates to a screen location.
  ///
  /// This method translates a geographic location to its corresponding
  /// position on the screen, which is useful for positioning UI elements
  /// over specific map locations.
  ///
  /// Parameters:
  /// - [coordinate]: The geographic position as a [BaatoCoordinate]
  ///
  /// Returns a [Future] that completes with the corresponding screen [Offset],
  /// or null if the conversion fails.
  ///
  /// Example:
  /// ```dart
  /// void positionCustomMarker(BaatoCoordinate location) async {
  ///   final screenPosition = await coordinateConverter.toScreenLocation(location);
  ///   if (screenPosition != null) {
  ///     // Position a custom UI element at this screen location
  ///   }
  /// }
  /// ```
  Future<Offset?> toScreenLocation(BaatoCoordinate coordinate) async {
    final latLng = LatLng(coordinate.latitude, coordinate.longitude);
    final point = await _mapLibreMapController.toScreenLocation(latLng);
    return Offset(point.x.toDouble(), point.y.toDouble());
  }
}
