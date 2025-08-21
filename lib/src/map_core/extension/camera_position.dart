import 'package:baato_maps/baato_maps.dart';
import 'package:baato_maps/src/map_core/extension/coordinate.dart';

extension InterConversion on CameraPosition {
  BaatoCameraPosition get toBaatoCameraPosition =>
      BaatoCameraPosition(target: target.toBaatoCoordinate, zoom: zoom);
}


extension InterConversionX on BaatoCameraPosition {
  CameraPosition get toCameraPosition =>
      CameraPosition(target: target.toLatLng, zoom: zoom);
}