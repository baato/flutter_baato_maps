import 'package:baato_maps/baato_maps.dart';
import 'package:flutter/material.dart';

/// A manager class that handles map style operations for Baato Maps.
///
/// This class provides methods to set and listen to changes in the map style.
/// It uses a ValueNotifier to notify listeners when the style changes.
class StyleManager {
  /// The ValueNotifier that holds the current map style URL or definition
  final ValueNotifier<BaatoMapStyle> _styleNotifier;

  /// Creates a new StyleManager with the specified initial style
  ///
  /// [initialStyle] is the starting style URL or definition for the map
  StyleManager({required BaatoMapStyle initialStyle})
      : _styleNotifier = ValueNotifier(initialStyle);

  /// Gets the ValueNotifier that can be used to observe style changes
  ValueNotifier<BaatoMapStyle> get styleNotifier => _styleNotifier;

  /// Sets a new map style
  ///
  /// [newStyle] is the new style URL or definition to apply to the map
  ///
  /// Returns a [Future] that completes when the style has been set
  Future<void> setStyle(BaatoMapStyle newStyle) async {
    if (_styleNotifier.value != newStyle) {
      _styleNotifier.value = newStyle;
    }
  }

  /// Adds a listener that will be called when the map style changes
  ///
  /// [listener] is the callback function to be called on style changes
  void addStyleListener(VoidCallback listener) {
    _styleNotifier.addListener(listener);
  }

  /// Removes a previously added style change listener
  ///
  /// [listener] is the callback function to be removed
  void removeStyleListener(VoidCallback listener) {
    _styleNotifier.removeListener(listener);
  }

  /// Disposes of resources used by the StyleManager
  ///
  /// This should be called when the StyleManager is no longer needed
  /// to prevent memory leaks
  void dispose() {
    _styleNotifier.dispose();
  }
}
