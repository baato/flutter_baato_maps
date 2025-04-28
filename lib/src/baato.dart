import 'package:baato_api/baato_api.dart';
import 'package:baato_maps/src/map/map_configuration.dart';
import 'package:baato_maps/src/services/glyphs_service.dart';
import 'package:baato_maps/src/services/sprite_service.dart';

/// The main entry point for the Baato package.
///
/// This class provides access to Baato Maps functionality and handles
/// configuration of the Baato API. It must be configured before using
/// any Baato Maps features.
///
/// Example usage:
/// ```dart
/// Baato.configure(
///   apiKey: 'your_api_key_here',
///   enableLogging: true,
/// );
///
/// // Now you can use the API
/// final places = await Baato.api.searchPlaces('Kathmandu');
/// ```
class Baato {
  /// Internal instance of the BaatoAPI client
  static BaatoAPI? _api;

  /// Gets the initialized BaatoAPI instance.
  ///
  /// This getter provides access to the BaatoAPI client for making
  /// API requests such as search, reverse geocoding, and directions.
  ///
  /// Throws an [Exception] if accessed before calling [configure].
  static BaatoAPI get api {
    if (_api == null) {
      throw Exception(
        'BaatoAPI must be initialized before use. Call BaatoMaps.configure().',
      );
    }
    return _api!;
  }

  /// Configures the Baato Maps package with the provided parameters.
  ///
  /// This method must be called before using any Baato Maps functionality.
  /// It initializes both the map configuration and the API client.
  ///
  /// Parameters:
  /// - [apiKey]: Required API key for authenticating with Baato services
  /// - [appId]: Optional application ID for additional authentication
  /// - [securityCode]: Optional security code for enhanced API security
  /// - [connectTimeoutInSeconds]: Timeout for establishing API connections (default: 10)
  /// - [receiveTimeoutInSeconds]: Timeout for receiving API responses (default: 10)
  /// - [enableLogging]: Whether to enable debug logging (default: false)
  static Future<void> configure({
    required String apiKey,
    String? appId,
    String? securityCode,
    int connectTimeoutInSeconds = 10,
    int receiveTimeoutInSeconds = 10,
    bool enableLogging = false,
  }) async {
    await GlyphsService().copyGlyphsToCacheDir();
    await SpriteService().copyspritesToCacheDir();
    // Configure the BaatoMapConfig
    BaatoMapConfig.configure(
      apiKey: apiKey,
      appId: appId,
      securityCode: securityCode,
      connectTimeoutInSeconds: connectTimeoutInSeconds,
      receiveTimeoutInSeconds: receiveTimeoutInSeconds,
      enableLogging: enableLogging,
    );

    // Initialize the BaatoAPI with the configured parameters
    _api = BaatoAPI.initialize(
      apiKey: BaatoMapConfig.instance.apiKey,
      appId: BaatoMapConfig.instance.appId,
      securityCode: BaatoMapConfig.instance.securityCode,
      connectTimeoutInSeconds: BaatoMapConfig.instance.connectTimeoutInSeconds,
      receiveTimeoutInSeconds: BaatoMapConfig.instance.receiveTimeoutInSeconds,
      enableLogging: BaatoMapConfig.instance.enableLogging,
    );
  }
}
