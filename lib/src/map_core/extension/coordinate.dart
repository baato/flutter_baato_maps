import 'package:baato_maps/baato_maps.dart';

extension Conversion on BaatoCoordinate {
  LatLng get toLatLng => LatLng(latitude, longitude);
}

extension ConversionX on LatLng {
  BaatoCoordinate get toBaatoCoordinate =>
      BaatoCoordinate(latitude: latitude, longitude: longitude);
}
