/// The default route source name
const String defaultRouteSourceName = "baato_route_source";

/// The default route layer name
const String defaultRouteLayerName = "baato_route_layer";

/// Enum representing different marker assets available in the Baato Maps package.
///
/// This enum provides access to marker image assets that can be used on the map.
/// Each enum value corresponds to a specific marker image with its asset path.
enum BaatoMarker {
  /// The default Baato marker icon.
  ///
  /// This is automatically loaded when initializing the map.
  baatoDefault('packages/baato_maps/lib/assets/markers/baato_marker.png');

  /// The asset path to the marker image.
  ///
  /// This path is used to load the marker image from the assets.
  final String assetPath;

  /// Creates a [BaatoMarker] with the specified asset path.
  const BaatoMarker(this.assetPath);
}
