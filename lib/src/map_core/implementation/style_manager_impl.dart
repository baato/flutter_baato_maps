

import 'package:baato_maps/baato_maps.dart';
import 'package:baato_maps/src/map_core/style_manager.dart';
import 'package:flutter/material.dart';


class StyleManagerImpl implements StyleManager{
  /// The ValueNotifier that holds the current map style URL or definition
  final ValueNotifier<BaatoMapStyle> _styleNotifier;


  StyleManagerImpl({required BaatoMapStyle initialStyle})
      : _styleNotifier = ValueNotifier(initialStyle);


  @override
  ValueNotifier<BaatoMapStyle> get styleNotifier => _styleNotifier;

  @override
  Future<void> setStyle(BaatoMapStyle newStyle) async {
    if (_styleNotifier.value != newStyle) {
      _styleNotifier.value = newStyle;
    }
  }


  @override
  void addStyleListener(VoidCallback listener) {
    _styleNotifier.addListener(listener);
  }

  @override
  void removeStyleListener(VoidCallback listener) {
    _styleNotifier.removeListener(listener);
  }

  @override
  void dispose() {
    _styleNotifier.dispose();
  }
}
