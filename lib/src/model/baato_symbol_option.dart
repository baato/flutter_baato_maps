import 'package:baato_api/baato_api.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:flutter/material.dart';

/// Configuration options for Baato map symbols.
///
/// This class provides a convenient way to configure symbols (markers) on a Baato map.
class BaatoSymbolOption {
  /// The size of the icon.
  final double? iconSize;

  /// The name of the icon image to use.
  final String? iconImage;

  /// The rotation angle of the icon in degrees clockwise.
  final double? iconRotate;

  /// The offset of the icon from its anchor position.
  final Offset? iconOffset;

  /// The anchor position of the icon.
  final String? iconAnchor;

  /// Font names for the text. Not supported on web.
  final List<String>? fontNames;

  /// The text to display with the symbol.
  final String? textField;

  /// The size of the text.
  final double? textSize;

  /// The maximum width of the text.
  final double? textMaxWidth;

  /// The letter spacing of the text.
  final double? textLetterSpacing;

  /// The text justification.
  final String? textJustify;

  /// The anchor position of the text.
  final String? textAnchor;

  /// The rotation angle of the text in degrees clockwise.
  final double? textRotate;

  /// The text transformation.
  final String? textTransform;

  /// The offset of the text from its anchor position.
  final Offset? textOffset;

  /// The opacity of the icon.
  final double? iconOpacity;

  /// The color of the icon.
  final String? iconColor;

  /// The color of the icon's halo.
  final String? iconHaloColor;

  /// The width of the icon's halo.
  final double? iconHaloWidth;

  /// The blur radius of the icon's halo.
  final double? iconHaloBlur;

  /// The opacity of the text.
  final double? textOpacity;

  /// The color of the text.
  final String? textColor;

  /// The color of the text's halo.
  final String? textHaloColor;

  /// The width of the text's halo.
  final double? textHaloWidth;

  /// The blur radius of the text's halo.
  final double? textHaloBlur;

  /// The geographical position of the symbol.
  final BaatoCoordinate? geometry;

  /// The z-index of the symbol.
  final int? zIndex;

  /// Whether the symbol is draggable.
  final bool? draggable;

  /// Creates a set of symbol configuration options.
  ///
  /// By default, every non-specified field is null, meaning no desire to change
  /// symbol defaults or current configuration.
  const BaatoSymbolOption({
    this.iconSize,
    this.iconImage = "baato_marker",
    this.iconRotate,
    this.iconOffset,
    this.iconAnchor,
    this.fontNames = const ["OpenSans"],
    this.textField,
    this.textSize,
    this.textMaxWidth,
    this.textLetterSpacing,
    this.textJustify,
    this.textAnchor,
    this.textRotate,
    this.textTransform,
    this.textOffset,
    this.iconOpacity,
    this.iconColor,
    this.iconHaloColor,
    this.iconHaloWidth,
    this.iconHaloBlur,
    this.textOpacity,
    this.textColor,
    this.textHaloColor,
    this.textHaloWidth,
    this.textHaloBlur,
    this.geometry,
    this.zIndex,
    this.draggable,
  });

  /// Converts this BaatoSymbolOption to a MapLibre SymbolOptions object.
  SymbolOptions toSymbolOptions() {
    return SymbolOptions(
      iconSize: iconSize,
      iconImage: iconImage,
      iconRotate: iconRotate,
      iconOffset: iconOffset,
      iconAnchor: iconAnchor,
      fontNames: fontNames,
      textField: textField,
      textSize: textSize,
      textMaxWidth: textMaxWidth,
      textLetterSpacing: textLetterSpacing,
      textJustify: textJustify,
      textAnchor: textAnchor,
      textRotate: textRotate,
      textTransform: textTransform,
      textOffset: textOffset,
      iconOpacity: iconOpacity,
      iconColor: iconColor,
      iconHaloColor: iconHaloColor,
      iconHaloWidth: iconHaloWidth,
      iconHaloBlur: iconHaloBlur,
      textOpacity: textOpacity,
      textColor: textColor,
      textHaloColor: textHaloColor,
      textHaloWidth: textHaloWidth,
      textHaloBlur: textHaloBlur,
      geometry: geometry != null
          ? LatLng(geometry!.latitude, geometry!.longitude)
          : null,
      zIndex: zIndex,
      draggable: draggable,
    );
  }

  /// Creates a copy of this BaatoSymbolOption with the given fields replaced with new values.
  ///
  /// This method allows you to create a new instance with modified properties while
  /// keeping all other properties the same as the original instance.
  BaatoSymbolOption copyWith({
    double? iconSize,
    String? iconImage,
    double? iconRotate,
    Offset? iconOffset,
    String? iconAnchor,
    List<String>? fontNames,
    String? textField,
    double? textSize,
    double? textMaxWidth,
    double? textLetterSpacing,
    String? textJustify,
    String? textAnchor,
    double? textRotate,
    String? textTransform,
    Offset? textOffset,
    double? iconOpacity,
    String? iconColor,
    String? iconHaloColor,
    double? iconHaloWidth,
    double? iconHaloBlur,
    double? textOpacity,
    String? textColor,
    String? textHaloColor,
    double? textHaloWidth,
    double? textHaloBlur,
    BaatoCoordinate? geometry,
    int? zIndex,
    bool? draggable,
  }) {
    return BaatoSymbolOption(
      iconSize: iconSize ?? this.iconSize,
      iconImage: iconImage ?? this.iconImage,
      iconRotate: iconRotate ?? this.iconRotate,
      iconOffset: iconOffset ?? this.iconOffset,
      iconAnchor: iconAnchor ?? this.iconAnchor,
      fontNames: fontNames ?? this.fontNames,
      textField: textField ?? this.textField,
      textSize: textSize ?? this.textSize,
      textMaxWidth: textMaxWidth ?? this.textMaxWidth,
      textLetterSpacing: textLetterSpacing ?? this.textLetterSpacing,
      textJustify: textJustify ?? this.textJustify,
      textAnchor: textAnchor ?? this.textAnchor,
      textRotate: textRotate ?? this.textRotate,
      textTransform: textTransform ?? this.textTransform,
      textOffset: textOffset ?? this.textOffset,
      iconOpacity: iconOpacity ?? this.iconOpacity,
      iconColor: iconColor ?? this.iconColor,
      iconHaloColor: iconHaloColor ?? this.iconHaloColor,
      iconHaloWidth: iconHaloWidth ?? this.iconHaloWidth,
      iconHaloBlur: iconHaloBlur ?? this.iconHaloBlur,
      textOpacity: textOpacity ?? this.textOpacity,
      textColor: textColor ?? this.textColor,
      textHaloColor: textHaloColor ?? this.textHaloColor,
      textHaloWidth: textHaloWidth ?? this.textHaloWidth,
      textHaloBlur: textHaloBlur ?? this.textHaloBlur,
      geometry: geometry ?? this.geometry,
      zIndex: zIndex ?? this.zIndex,
      draggable: draggable ?? this.draggable,
    );
  }

  /// Creates a BaatoSymbolOption from a MapLibre SymbolOptions object.
  ///
  /// This factory constructor allows conversion from the MapLibre native format
  /// to the Baato format, making it easier to work with existing MapLibre symbols.
  factory BaatoSymbolOption.fromSymbolOptions(SymbolOptions symbolOptions) {
    return BaatoSymbolOption(
      iconSize: symbolOptions.iconSize,
      iconImage: symbolOptions.iconImage,
      iconRotate: symbolOptions.iconRotate,
      iconOffset: symbolOptions.iconOffset,
      iconAnchor: symbolOptions.iconAnchor,
      fontNames: symbolOptions.fontNames,
      textField: symbolOptions.textField,
      textSize: symbolOptions.textSize,
      textMaxWidth: symbolOptions.textMaxWidth,
      textLetterSpacing: symbolOptions.textLetterSpacing,
      textJustify: symbolOptions.textJustify,
      textAnchor: symbolOptions.textAnchor,
      textRotate: symbolOptions.textRotate,
      textTransform: symbolOptions.textTransform,
      textOffset: symbolOptions.textOffset,
      iconOpacity: symbolOptions.iconOpacity,
      iconColor: symbolOptions.iconColor,
      iconHaloColor: symbolOptions.iconHaloColor,
      iconHaloWidth: symbolOptions.iconHaloWidth,
      iconHaloBlur: symbolOptions.iconHaloBlur,
      textOpacity: symbolOptions.textOpacity,
      textColor: symbolOptions.textColor,
      textHaloColor: symbolOptions.textHaloColor,
      textHaloWidth: symbolOptions.textHaloWidth,
      textHaloBlur: symbolOptions.textHaloBlur,
      geometry: symbolOptions.geometry != null
          ? BaatoCoordinate(
              latitude: symbolOptions.geometry!.latitude,
              longitude: symbolOptions.geometry!.longitude,
            )
          : null,
      zIndex: symbolOptions.zIndex,
      draggable: symbolOptions.draggable,
    );
  }
}
