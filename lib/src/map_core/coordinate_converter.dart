import 'dart:ui';
import 'package:baato_api/baato_api.dart';

/// Abstract interface for converting between screen positions and geographic coordinates.
abstract class CoordinateConverter {
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
  Future<BaatoCoordinate?> toLatLng(Offset screenLocation);

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
  Future<Offset?> toScreenLocation(BaatoCoordinate coordinate);
}
