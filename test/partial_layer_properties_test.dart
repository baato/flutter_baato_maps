import 'package:baato_maps/src/map_core/partial_layer_properties.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

void main() {
  group('PartialLayerProperties', () {
    test('emits only the properties the delegate set', () {
      // Arrange
      const delegate = SymbolLayerProperties(iconSize: 1.2);

      // Act
      final json = const PartialLayerProperties(delegate).toJson();

      // Assert
      expect(json, {'icon-size': 1.2});
    });

    test(
      'still omits unset properties when the caller passes skipNulls false',
      () {
        // MapLibreMapController.setLayerProperties calls toJson(skipNulls: false)
        // since maplibre_gl 0.26.0. Honouring it would null out `icon-image` on
        // the annotation layer and drop every symbol drawn from it.
        // Arrange
        const delegate = SymbolLayerProperties(iconSize: 1.2);

        // Act
        final json = const PartialLayerProperties(
          delegate,
        ).toJson(skipNulls: false);

        // Assert
        expect(json, {'icon-size': 1.2});
        expect(json.containsKey('icon-image'), isFalse);
        expect(json.containsKey('text-font'), isFalse);
        expect(json.containsKey('icon-allow-overlap'), isFalse);
      },
    );

    test('an unwrapped delegate does null out unset properties', () {
      // Guards the premise above: if this ever stops holding upstream, the
      // wrapper is no longer needed and this test says so.
      // Arrange
      const delegate = SymbolLayerProperties(iconSize: 1.2);

      // Act
      final json = delegate.toJson(skipNulls: false);

      // Assert
      expect(json['icon-image'], isNull);
      expect(json.containsKey('icon-image'), isTrue);
    });

    test('preserves an expression value verbatim', () {
      // Arrange
      const zoomInterpolation = [
        'interpolate',
        ['linear'],
        ['zoom'],
        11,
        [
          '*',
          0.7,
          ['get', 'iconSize'],
        ],
        18,
        ['get', 'iconSize'],
      ];

      // Act
      final json = const PartialLayerProperties(
        SymbolLayerProperties(iconSize: zoomInterpolation),
      ).toJson(skipNulls: false);

      // Assert
      expect(json, {'icon-size': zoomInterpolation});
    });

    test('carries the font stack as a bare string array', () {
      // The Android converter only takes the textFont(String[]) overload when
      // the value is a JSON array of strings; anything else goes through
      // Expression.Converter and fails for a plain font stack.
      // Arrange
      const fontNames = ['OpenSans'];

      // Act
      final json = const PartialLayerProperties(
        SymbolLayerProperties(textFont: fontNames),
      ).toJson(skipNulls: false);

      // Assert
      expect(json, {'text-font': fontNames});
    });
  });
}
