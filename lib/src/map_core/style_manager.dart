import 'package:baato_maps/baato_maps.dart';
import 'package:flutter/material.dart';

/// An abstract interface that handles map style operations for Baato Maps.
///
/// Provides methods to set and listen to changes in the map style.
abstract class StyleManager {
  /// Gets the ValueNotifier that can be used to observe style changes
  ValueNotifier<BaatoMapStyle> get styleNotifier;

  /// Sets a new map style
  ///
  /// [newStyle] is the new style URL or definition to apply to the map
  ///
  /// Returns a [Future] that completes when the style has been set
  Future<void> setStyle(BaatoMapStyle newStyle);

  /// Adds a listener that will be called when the map style changes
  ///
  /// [listener] is the callback function to be called on style changes
  void addStyleListener(VoidCallback listener);

  /// Removes a previously added style change listener
  ///
  /// [listener] is the callback function to be removed
  void removeStyleListener(VoidCallback listener);

  /// Disposes of resources used by the StyleManager
  ///
  /// This should be called when the StyleManager is no longer needed
  /// to prevent memory leaks
  void dispose();
}
