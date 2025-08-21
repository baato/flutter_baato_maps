import 'dart:ui';
import 'package:baato_maps/src/map_core/map_core.dart';
import 'package:baato_maps/src/model/baato_model.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class MarkerManagerImpl implements MarkerManager {
  /// The underlying MapLibre map controller used for marker operations
  final MapLibreMapController _mapLibreMapController;

  MarkerManagerImpl(
    this._mapLibreMapController,
  );

  @override
  Future<Symbol> addMarker(BaatoSymbolOption option,
      {Map<dynamic, dynamic>? data}) async {
    option = option.copyWith(
        iconOffset: option.iconOffset ?? const Offset(0, -10),
        textOffset: option.textOffset ?? const Offset(0, 0.8));

    return await _mapLibreMapController.addSymbol(
        option.toSymbolOptions(), data);
  }

  @override
  Future<void> clearMarkers() async {
    await _mapLibreMapController.clearSymbols();
  }

  @override
  Future<void> removeSymbol(Symbol symbol) async {
    await _mapLibreMapController.removeSymbol(symbol);
  }

  @override
  Future<void> updateSymbol(Symbol symbol, SymbolOptions changes) async {
    await _mapLibreMapController.updateSymbol(symbol, changes);
  }
}
