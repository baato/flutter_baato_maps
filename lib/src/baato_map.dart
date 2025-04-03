import 'package:baato_api/baato_api.dart';
import 'package:baato_maps/src/baato_map_configuration.dart';

class BaatoMap {
  static final BaatoAPI api = BaatoAPI.initialize(
    apiKey: BaatoMapConfiguration.apiKey!,
  );
}
