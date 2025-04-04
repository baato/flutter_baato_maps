import 'package:baato_api/baato_api.dart';

class BaatoCameraPosition {
  final BaatoCoordinate target;
  final double zoom;

  BaatoCameraPosition({required this.target, this.zoom = 0.0});
}
