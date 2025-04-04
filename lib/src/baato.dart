import 'package:baato_api/baato_api.dart';
import 'package:baato_maps/src/map/map_configuration.dart';

/// The main entry point for the Baato package.
class Baato {
  static BaatoAPI? _api;

  /// Gets the initialized BaatoAPI instance.
  static BaatoAPI get api {
    if (_api == null) {
      throw Exception(
        'BaatoAPI must be initialized before use. Call BaatoMaps.configure().',
      );
    }
    return _api!;
  }

  /// Configures the Baato Maps package with the provided parameters.
  static void configure({
    required String apiKey,
    String? appId,
    String? securityCode,
    int connectTimeoutInSeconds = 10,
    int receiveTimeoutInSeconds = 10,
    bool enableLogging = false,
  }) {
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
