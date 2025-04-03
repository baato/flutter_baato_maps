/// Configuration class for Baato Maps
///
/// This class stores the API key required for Baato Maps services.
/// Initialize this class with your API key before using any Baato Maps features.
class BaatoMapConfiguration {
  /// The API key for Baato Maps services
  static String? _apiKey;

  /// Get the current API key
  static String? get apiKey => _apiKey;

  /// Initialize Baato Maps with the API key
  ///
  /// This method should be called before using any Baato Maps features.
  ///
  /// Example:
  /// ```dart
  /// void main() {
  ///   BaatoMapConfiguration.initialize(apiKey: 'your-api-key-here');
  ///   runApp(MyApp());
  /// }
  /// ```
  static void configure({required String apiKey}) {
    _apiKey = apiKey;
  }

  /// Checks if the API key has been initialized
  static bool get isInitialized => _apiKey != null && _apiKey!.isNotEmpty;
}
