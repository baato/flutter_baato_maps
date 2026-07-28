## 2.0.0

### **BREAKING**
- Requires Dart `>=3.7.0` and Flutter `>=3.29.0`, as required by `maplibre_gl` 0.26.2
- Android builds now require JDK 21 — `maplibre_gl` 0.26.2 compiles at Java 21, and older JDKs fail with `invalid source release: 21`
- Annotation `data` parameters narrowed from `Map<dynamic, dynamic>?` to `Map<String, dynamic>?` across the marker and shape managers
- `Baato*LayerProperties.toJson()` now takes `{bool skipNulls = true}` to match the upstream `LayerProperties` signature

### **Bug Fixes**
- Markers are visible again. `maplibre_gl` 0.26.0 stopped honouring each symbol's `fontNames` and hardcoded its annotation layers to `["Open Sans Regular", "Arial Unicode MS Regular"]`. A symbol carrying a `textField` cannot build without its glyphs, so the entire symbol was dropped — icon included. The stack is now taken from the active style
- The map no longer flashes black while a bottom sheet or dialog animates over it. `maplibre_gl` 0.26.0 disabled texture mode by default, leaving the map on a `SurfaceView` that does not composite beneath animating Flutter widgets
- Bundled sprites are copied to the cache once rather than on every launch; the previous check never matched the sprite filenames
- Failures while registering the default marker image are now logged instead of vanishing into an unawaited `Future`

### **Features**
- `BaatoMapStyle.fontNames` declares the font stack a style's glyph endpoint serves. `BaatoMapStyle.customStyle(styleURL, [fontNames])` accepts one for custom styles; when unknown, no override is applied and maplibre's default is left in place
- `BaatoMap.symbolFontNames` overrides the active style's font stack
- `BaatoMap.translucentTextureSurface` controls Android `TextureView` vs `SurfaceView` rendering, defaulting to the pre-0.26.0 behaviour

### **Dependencies**
- `maplibre_gl` `^0.24.1` → `^0.26.2`
- `baato_api` `^2.0.1` → `^2.2.0`
- `path_provider` `^2.1.5` → `^2.1.6`
- `path` `^1.8.3` → `^1.9.1`

## 1.1.0
### **BREAKING**
- Migrate sprite discovery to `AssetManifest.loadFromAssetBundle`

### **Bug Fixes**
- Fixed typo in `OnFeatureDragCallback` type name (was incorrectly named `OnFeatureDragnCallback`)

## 1.0.3

- Controller can now be passed externally and initialized using `BaatoMapController()`
- Fixed issues with `onTap` and `onLongPress` handlers not triggering consistently

## 1.0.2

- Default style for iOS setup

## 1.0.1

- Baato lite map style added by default

## 1.0.0

- Initial release of Baato Maps Flutter Package
- Interactive Map Display with `BaatoMapWidget`
- Custom Map Styles including breeze and monochrome
- Location Services for user location tracking and updates
- Place Search with auto-suggestions using `BaatoPlaceAutoSuggestion`
- Marker Management to add, remove, and customize map markers
- Route Management for route display and navigation features
- Shape Drawing to draw circles, polygons, and other shapes on the map
- GeoJSON Support to visualize GeoJSON data on the map
- Coordinate Conversion between screen and geographic coordinates
- Layer Management to add and manage multiple map layers
- Cross-Platform support for both iOS and Android
