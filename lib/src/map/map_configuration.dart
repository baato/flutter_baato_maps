import 'package:baato_maps/baato_maps.dart';

/// Configuration class for Baato Maps.
///
/// This class manages the configuration settings required for Baato Maps to function,
/// including API credentials and network settings. It follows a singleton pattern
/// to ensure consistent configuration throughout the application.
class BaatoMapConfig {
  /// The API key required for authenticating with Baato services.
  final String apiKey;

  /// Optional application ID for additional authentication.
  final String? appId;

  /// Optional security code for enhanced API security.
  final String? securityCode;

  /// Connection timeout in seconds for API requests.
  /// Defaults to 10 seconds.
  final int connectTimeoutInSeconds;

  /// Receive timeout in seconds for API responses.
  /// Defaults to 10 seconds.
  final int receiveTimeoutInSeconds;

  /// Whether to enable detailed logging of API operations.
  /// Useful for debugging but should be disabled in production.
  final bool enableLogging;

  /// Creates a new configuration instance with the specified parameters.
  ///
  /// [apiKey] is required for authentication with Baato services.
  /// [appId] and [securityCode] are optional additional authentication parameters.
  /// [connectTimeoutInSeconds] and [receiveTimeoutInSeconds] control network timeouts.
  /// [enableLogging] toggles detailed logging for debugging purposes.
  BaatoMapConfig({
    required this.apiKey,
    this.appId,
    this.securityCode,
    this.connectTimeoutInSeconds = 10,
    this.receiveTimeoutInSeconds = 10,
    this.enableLogging = false,
  });

  // Static instance to hold the configuration
  static BaatoMapConfig? _instance;

  /// Gets the current configuration instance.
  ///
  /// Throws an exception if the configuration hasn't been initialized.
  /// Use [configure] before accessing this getter.
  static BaatoMapConfig get instance {
    if (_instance == null) {
      throw Exception(
        'BaatoMapConfig must be initialized before use. Call BaatoMaps.configure().',
      );
    }
    return _instance!;
  }

  /// Configures the BaatoMapConfig with the provided parameters.
  ///
  /// This method must be called before using any Baato Maps functionality,
  /// typically at application startup.
  ///
  /// [apiKey] is required for authentication with Baato services.
  /// [appId] and [securityCode] are optional additional authentication parameters.
  /// [connectTimeoutInSeconds] and [receiveTimeoutInSeconds] control network timeouts.
  /// [enableLogging] toggles detailed logging for debugging purposes.
  static void configure({
    required String apiKey,
    String? appId,
    String? securityCode,
    int connectTimeoutInSeconds = 10,
    int receiveTimeoutInSeconds = 10,
    bool enableLogging = false,
  }) {
    _instance = BaatoMapConfig(
      apiKey: apiKey,
      appId: appId,
      securityCode: securityCode,
      connectTimeoutInSeconds: connectTimeoutInSeconds,
      receiveTimeoutInSeconds: receiveTimeoutInSeconds,
      enableLogging: enableLogging,
    );
    BaatoMapStyle.defaultStyle.loadDefaultStyle();
  }
}
