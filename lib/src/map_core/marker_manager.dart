import 'dart:ui';
import 'package:baato_maps/src/model/baato_model.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

/// A manager class that handles marker operations for Baato Maps.
///
/// This class provides methods to add, remove, update, and clear markers on the map.
/// It works with the underlying MapLibre map controller to manage map symbols.
class MarkerManager {
  /// The underlying MapLibre map controller used for marker operations
  final MapLibreMapController _mapLibreMapController;

  /// Creates a new MarkerManager with the specified controllers
  ///
  /// [_mapLibreMapController] is the MapLibre controller used for marker operations
  MarkerManager(
    this._mapLibreMapController,
  );

  /// Adds a marker to the map with the specified options.
  ///
  /// This method places a symbol on the map based on the provided options.
  /// It automatically applies default offsets if none are specified.
  ///
  /// Parameters:
  /// - [option]: The [BaatoSymbolOption] defining the marker's appearance and position
  /// - [data]: Optional additional data to associate with the marker
  ///
  /// Returns a [Future] that completes with the created [Symbol] object,
  /// which can be used to update or remove the marker later.
  Future<Symbol> addMarker(BaatoSymbolOption option,
      {Map<dynamic, dynamic>? data}) async {
    option = option.copyWith(
        iconOffset: option.iconOffset ?? const Offset(0, -10),
        textOffset: option.textOffset ?? const Offset(0, 0.8));
    return await _mapLibreMapController.addSymbol(
        option.toSymbolOptions(), data);
  }

  /// Removes all markers from the map.
  ///
  /// This method clears all symbols that have been added to the map.
  /// Returns a [Future] that completes when all markers have been removed.
  Future<void> clearMarkers() async {
    await _mapLibreMapController.clearSymbols();
  }

  /// Removes a specific marker from the map.
  ///
  /// Parameters:
  /// - [symbol]: The [Symbol] object to remove from the map
  ///
  /// Returns a [Future] that completes when the marker has been removed.
  Future<void> removeSymbol(Symbol symbol) async {
    await _mapLibreMapController.removeSymbol(symbol);
  }

  /// Updates an existing marker with new options.
  ///
  /// Parameters:
  /// - [symbol]: The [Symbol] object to update
  /// - [changes]: The [SymbolOptions] containing the properties to change
  ///
  /// Returns a [Future] that completes when the marker has been updated.
  Future<void> updateSymbol(Symbol symbol, SymbolOptions changes) async {
    await _mapLibreMapController.updateSymbol(symbol, changes);
  }
}
