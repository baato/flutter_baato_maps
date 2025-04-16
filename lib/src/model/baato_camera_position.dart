import 'package:baato_api/baato_api.dart';

/// A class that represents a camera position for Baato Maps.
///
/// This class defines the position of the camera on the map, including
/// the target coordinate (center point) and zoom level.
class BaatoCameraPosition {
  /// The geographical coordinate that the camera is pointing at.
  ///
  /// This coordinate represents the center point of the map view.
  final BaatoCoordinate target;

  /// The zoom level of the camera.
  ///
  /// Higher values indicate a more zoomed-in view, while lower values
  /// indicate a more zoomed-out view. The default value is 0.0.
  final double zoom;

  /// Creates a new BaatoCameraPosition with the specified target and zoom.
  ///
  /// [target] is the coordinate that the camera will center on.
  /// [zoom] is the zoom level, defaulting to 0.0 if not specified.
  BaatoCameraPosition({required this.target, this.zoom = 0.0});
}
