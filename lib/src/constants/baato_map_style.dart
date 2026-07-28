import 'dart:io';

import 'package:baato_maps/src/constants/base_constant.dart';
import 'package:baato_maps/src/map/default_style.dart';
import 'package:baato_maps/src/map/map_configuration.dart';

/// Abstract class representing different map styles available in the Baato Maps package.
///
/// This class provides access to different map style URLs that can be used with the map.
/// Each style has its own URL that includes the API key for authentication.
abstract class BaatoMapStyle {
  /// Allows subclasses to keep their const constructors.
  const BaatoMapStyle();

  /// The URL for the map style.
  ///
  /// This URL is used to load the map style from the Baato Maps API.
  String get styleURL;

  /// The font stack this style's glyph endpoint serves, if known.
  ///
  /// maplibre_gl 0.26.0 stopped honouring the per-symbol `fontNames` and
  /// hardcoded its annotation layers to `["Open Sans Regular", "Arial Unicode
  /// MS Regular"]`. A symbol carrying a `textField` cannot build without its
  /// glyphs, so when a style does not serve that stack the whole symbol is
  /// dropped — icon included. [BaatoMap] re-applies this stack to the symbol
  /// annotation layers once the style has loaded.
  ///
  /// Returns null when the stack is unknown, in which case no override is
  /// applied and maplibre's own default is left in place.
  List<String>? get fontNames => const ["OpenSans"];

  /// The baato lite style map.
  ///
  /// A light and airy map style with subtle colors and clear typography.
  static var defaultStyle = _DefaultStyle();

  /// The baato lite style map.
  ///
  /// A light and airy map style with subtle colors and clear typography.
  static const baatoLite = _BaatoLiteStyle();

  /// The breeze style map.
  ///
  /// A light and airy map style with subtle colors and clear typography.
  static const breeze = _BreezeStyle();

  /// The dark style map.
  ///
  /// A dark-themed map style with high contrast and reduced eye strain.
  static const dark = _DarkStyle();

  /// The monochrome style map.
  ///
  /// A grayscale map style that uses only black, white, and shades of gray.
  static const monochrome = _MonochromeStyle();

  /// The roads style map.
  ///
  /// A map style that emphasizes road networks and transportation features.
  static const roads = _RoadsStyle();

  /// The retro style map.
  ///
  /// A vintage-inspired map style with a classic cartographic look.
  static const retro = _RetroStyle();

  /// Creates a custom style map with the provided style URL.
  ///
  /// [styleURL] is the URL of the custom map style to be used.
  /// [fontNames] is the font stack this style's glyph endpoint serves. Leave it
  /// unset unless symbol labels fail to appear — see [BaatoMapStyle.fontNames].
  /// Returns a [_CustomStyle] instance with the specified style URL.
  // ignore: library_private_types_in_public_api
  static _CustomStyle customStyle(String styleURL, [List<String>? fontNames]) =>
      _CustomStyle(styleURL, fontNames);
}

/// Implementation of the baato lite style map.
class _BaatoLiteStyle extends BaatoMapStyle {
  const _BaatoLiteStyle();

  @override
  String get styleURL =>
      '${BaatoConstant.baseMapStyleUrl}baato_lite?key=${BaatoMapConfig.instance.apiKey}';
}

/// Implementation of the breeze style map.
class _BreezeStyle extends BaatoMapStyle {
  const _BreezeStyle();

  @override
  String get styleURL =>
      '${BaatoConstant.baseMapStyleUrl}breeze?key=${BaatoMapConfig.instance.apiKey}';
}

/// Implementation of the dark style map.
class _DarkStyle extends BaatoMapStyle {
  const _DarkStyle();

  @override
  String get styleURL =>
      '${BaatoConstant.baseMapStyleUrl}dark?key=${BaatoMapConfig.instance.apiKey}';
}

/// Implementation of the monochrome style map.
class _MonochromeStyle extends BaatoMapStyle {
  const _MonochromeStyle();

  @override
  String get styleURL =>
      '${BaatoConstant.baseMapStyleUrl}monochrome?key=${BaatoMapConfig.instance.apiKey}';
}

/// Implementation of the roads style map.
class _RoadsStyle extends BaatoMapStyle {
  const _RoadsStyle();

  @override
  String get styleURL =>
      '${BaatoConstant.baseMapStyleUrl}roads?key=${BaatoMapConfig.instance.apiKey}';
}

/// Implementation of the retro style map.
class _RetroStyle extends BaatoMapStyle {
  const _RetroStyle();

  @override
  String get styleURL =>
      '${BaatoConstant.baseMapStyleUrl}retro?key=${BaatoMapConfig.instance.apiKey}';
}

/// Implementation of a custom style map.
///
/// This class allows using a custom map style URL instead of the predefined styles.
class _CustomStyle extends BaatoMapStyle {
  /// Creates a new custom style with the specified style URL.
  ///
  /// [customStyleURL] is the URL of the custom map style to be used.
  /// [fontNames] is the font stack the style's glyph endpoint serves.
  const _CustomStyle(this.customStyleURL, [this.fontNames]);

  /// The URL of the custom map style.
  final String customStyleURL;

  /// Unknown unless the caller supplies it, so by default no font stack is
  /// forced onto the symbol layers and maplibre's own default is left alone.
  @override
  final List<String>? fontNames;

  @override
  String get styleURL => customStyleURL;
}

class _DefaultStyle extends BaatoMapStyle {
  String? styleFromAsset;

  /// The default style map.
  _DefaultStyle() {
    if (Platform.isIOS) {
      styleFromAsset = BaatoMapStyle.baatoLite.styleURL;
    } else if (Platform.isAndroid) {
      loadDefaultStyle();
    }
  }

  Future<void> loadDefaultStyle() async {
    // load the default style from the map
    // await Future.delayed(Duration(seconds: 3));
    styleFromAsset = await DefaultStyle().loadStyle();
  }

  @override
  String get styleURL => styleFromAsset ?? '';
}
