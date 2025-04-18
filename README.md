# Baato Maps Flutter Package

A comprehensive Flutter package for integrating Baato Maps into your applications. This package provides a powerful set of tools for displaying interactive maps, handling map operations, and integrating with Baato's mapping services.

## Features

- **Interactive Map Display**: Easily integrate interactive maps with the `BaatoMap` widget
- **Custom Map Styles**: Support for multiple map styles including breeze and monochrome
- **Location Services**: Built-in support for user location tracking and updates
- **Place Search**: Integrated place search with auto-suggestions using `BaatoPlaceAutoSuggestion`
- **Marker Management**: Add, remove, and customize map markers
- **Route Management**: Handle route display and navigation features
- **Shape Drawing**: Draw circles, polygons, and other shapes on the map
- **GeoJSON Support**: Visualize GeoJSON data on the map
- **Coordinate Conversion**: Convert between screen and geographic coordinates
- **Layer Management**: Add and manage multiple map layers
- **Cross-Platform**: Works seamlessly on both iOS and Android

## Installation

1. Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  baato_maps: ^latest_version
```

2. Import the package in your Dart code:

```dart
import 'package:baato_maps/baato_maps.dart';
```

## Configuration

Before using Baato Maps, you need to configure it with your API key:

```dart
void main() {
  // Initialize Baato Maps with your API key
  Baato.configure(
    apiKey: 'YOUR_BAATO_API_KEY',
    enableLogging: true, // Optional: Enable logging for debugging
  );

  runApp(MyApp());
}
```

## Basic Usage

### Display a Simple Map

```dart
BaatoMap(
  initialPosition: BaatoCoordinate(
    latitude: 27.7172,
    longitude: 85.3240,
  ),
  initialZoom: 12.0,
  myLocationEnabled: true,
  onMapCreated: (BaatoMapController controller) {
    // Store controller for later use
  },
)
```

### Add a Marker

```dart
mapController.markerManager.addMarker(
  BaatoSymbolOption(
    geometry: BaatoCoordinate(
      latitude: 27.7172,
      longitude: 85.3240,
    ),
    textField: "My Location",
  ),
);
```

### Implement Place Search

```dart
BaatoPlaceAutoSuggestion(
  onPlaceSelected: (place) {
    print('Selected place: ${place.name}');
  },
  onPlaceDetailsRetrieved: (placeDetails) {
    print('Place details: ${placeDetails.name}');
  },
  currentCoordinate: BaatoCoordinate(
    latitude: 27.7172,
    longitude: 85.3240,
  ),
)
```

### Draw Shapes

```dart
// Add a circle
mapController.shapeManager.addCircle(
  BaatoCircleOptions(
    center: BaatoCoordinate(
      latitude: 27.7172,
      longitude: 85.3240,
    ),
    circleRadius: 100,
    circleColor: "#FF0000",
    circleOpacity: 0.5,
  ),
);
```

## Available Map Styles

Baato Maps provides several built-in map styles that can be accessed through the `BaatoMapStyle` class:

1. Breeze Style:

   - A light and airy map style with subtle colors and clear typography
   - Access via `BaatoMapStyle.breeze`

2. Dark Style:

   - A dark-themed map style with high contrast and reduced eye strain
   - Access via `BaatoMapStyle.dark`

3. Monochrome Style:

   - A grayscale map style that uses only black, white, and shades of gray
   - Access via `BaatoMapStyle.monochrome`

4. Black and White Style:

   - A high-contrast map style using only black and white colors
   - Access via `BaatoMapStyle.blackWhite`

5. Roads Style:

   - A map style that emphasizes road networks and transportation features
   - Access via `BaatoMapStyle.roads`

6. Retro Style:
   - A vintage-inspired map style with a classic cartographic look
   - Access via `BaatoMapStyle.retro`

You can also create a custom style using:

## Advanced Features

### Custom Layer Management

```dart
mapController.sourceAndLayerManager.addSource(
  "custom-source",
  BaatoVectorSourceProperties(
    url: "your-tileset-url",
  ),
);

mapController.sourceAndLayerManager.addLayer(
  "custom-source",
  "custom-layer",
  // Layer properties
);
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This package is available under the MIT license. See the LICENSE file for more info.
