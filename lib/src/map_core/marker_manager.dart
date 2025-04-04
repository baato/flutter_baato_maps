import 'dart:ui';

import 'package:baato_maps/baato_maps.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class MarkerManager {
  final MapLibreMapController _mapLibreMapController;

  MarkerManager(this._mapLibreMapController);

  Future<Symbol> addMarker(
    BaatoCoordinate position, {
    String? iconImage,
    double? iconSize,
    String? title,
    String? textColor,
    String? textHaloColor,
    double? textHaloWidth,
    double? textSize,
    Offset? textOffset,
  }) async {
    return await _mapLibreMapController.addSymbol(
      SymbolOptions(
        geometry: LatLng(position.latitude, position.longitude),
        iconImage: "custom_marker",
        iconSize: iconSize,
        textField: title,
        textSize: textSize,
        textOffset: textOffset ?? const Offset(0, 2),
        textColor: textColor ?? "#FF0000",
        textHaloColor: textHaloColor ?? "#FFFFFF",
        textHaloWidth: textHaloWidth ?? 2.0,
        fontNames: ["OpenSans"],
      ),
    );
  }

  Future<void> clearMarkers() async {
    await _mapLibreMapController.clearSymbols();
  }

  Future<void> removeSymbol(Symbol symbol) async {
    await _mapLibreMapController.removeSymbol(symbol);
  }

  Future<void> updateSymbol(Symbol symbol, SymbolOptions changes) async {
    await _mapLibreMapController.updateSymbol(symbol, changes);
  }
}
