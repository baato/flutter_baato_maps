/// Configuration class for Baato Maps.
class BaatoMapConfig {
  final String apiKey;
  final String? appId;
  final String? securityCode;
  final int connectTimeoutInSeconds;
  final int receiveTimeoutInSeconds;
  final bool enableLogging;

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
  static BaatoMapConfig get instance {
    if (_instance == null) {
      throw Exception(
        'BaatoMapConfig must be initialized before use. Call BaatoMaps.configure().',
      );
    }
    return _instance!;
  }

  /// Configures the BaatoMapConfig with the provided parameters.
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
  }
}
