import 'package:flutter/material.dart';

class StyleManager {
  final ValueNotifier<String> _styleNotifier;

  StyleManager({required String initialStyle})
    : _styleNotifier = ValueNotifier(initialStyle);

  ValueNotifier<String> get styleNotifier => _styleNotifier;

  Future<void> setStyle(String newStyle) async {
    _styleNotifier.value = newStyle;
  }

  void addStyleListener(VoidCallback listener) {
    _styleNotifier.addListener(listener);
  }

  void removeStyleListener(VoidCallback listener) {
    _styleNotifier.removeListener(listener);
  }

  void dispose() {
    _styleNotifier.dispose();
  }
}
