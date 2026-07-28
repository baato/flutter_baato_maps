// ignore: depend_on_referenced_packages
import 'package:flutter/foundation.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class SpriteService {
  /// Copies the sprites files to cache dir to allow native code to access it
  Future<void> copyspritesToCacheDir() async {
    var dir = (await getApplicationCacheDirectory()).path;

    final List<String> spritesAssets = await _getspriteAssets();

    /* Check if the files are present */

    // The copy below writes each asset to `<cacheDir>/<assetKey>`, so those are
    // the paths checked here. Matching on the resolved paths keeps this correct
    // whatever the sprite files happen to be named.
    var allSpritesPresent = spritesAssets.isNotEmpty &&
        spritesAssets.every((asset) => File(p.join(dir, asset)).existsSync());

    if (allSpritesPresent) {
      debugPrint('Sprite files are already present');
      // Exits here if sprite files already exist
      return;
    }

    /* If not present, copy */

    final int spriteAmount = spritesAssets.length;
    for (var i = 0; i < spriteAmount; i++) {
      final String asset = spritesAssets[i];
      final String assetPath = p.dirname(asset);
      final String assetDir = p.join(dir, assetPath);
      final String assetFileName = p.basename(asset);

      // Create the directory structure if it's not present
      await Directory(assetDir).create(recursive: true);

      final ByteData data = await rootBundle.load(asset);
      final String path = p.join(assetDir, assetFileName);
      await _writeAssetToFile(data, path);
      debugPrint('[${i + 1}/$spriteAmount] "$asset" copied to "$path".');
    }
  }

  Future<List<String>> _getspriteAssets() async {
    final assetManifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    return assetManifest
        .listAssets()
        .where((String key) =>
            key.contains('packages/baato_maps/lib/assets/map_res/sprites'))
        .toList();
  }

  Future<void> _writeAssetToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }
}
