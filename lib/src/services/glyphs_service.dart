// ignore: depend_on_referenced_packages
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class GlyphsService {
  /// Copies the glyphs files to cache dir to allow native code to access it
  Future<void> copyGlyphsToCacheDir() async {
    var dir = (await getApplicationCacheDirectory()).path;

    /* Check if the files are present */

    var directory = Directory(dir);

    var glyphFilesInDirectory = directory
        .listSync(recursive: true)
        .where((file) => p.basename(file.path).startsWith('glyph'))
        .map((file) => p.basename(file.path));

    if (glyphFilesInDirectory.isNotEmpty) {
      debugPrint('Glyph files directories are already present');
      // Exits here if glyph files already exist
      return;
    }

    /* If not present, copy */

    final List<String> glyphsAssets = await _getGlyphAssets();
    final int glyphAmount = glyphsAssets.length;
    for (var i = 0; i < glyphAmount; i++) {
      final String asset = glyphsAssets[i];
      final String assetPath = p.dirname(asset);
      final String assetDir = p.join(dir, assetPath);
      final String assetFileName = p.basename(asset);

      // Create the directory structure if it's not present
      await Directory(assetDir).create(recursive: true);

      final ByteData data = await rootBundle.load(asset);
      final String path = p.join(assetDir, assetFileName);
      await _writeAssetToFile(data, path);
      debugPrint('[${i + 1}/$glyphAmount] "$asset" copied to "$path".');
    }
  }

  Future<List<String>> _getGlyphAssets() {
    return rootBundle
        .loadString('AssetManifest.json')
        .then<List<String>>((String manifestJson) {
      Map<String, dynamic> manifestMap = jsonDecode(manifestJson);
      return manifestMap.keys
          .where((String key) =>
              key.contains('packages/baato_maps/lib/assets/map_res/glyphs'))
          .toList();
    });
  }

  Future<void> _writeAssetToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }
}
