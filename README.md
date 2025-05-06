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
    enableLogging: true, // [Optional]: Enable logging for debugging
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
  onTap: (point, coordinate, feature) {
   // Perform adding marker, reverse geocoding,
   // and other callbacks   
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

### Camera Managemant

##### Move to My location

```dart
mapController.cameraManager.moveToMyLocation();
```

##### Move to location

```dart
mapController.cameraManager
            .moveTo(coordinate,//[Required] geographic coordinates of location
            zoom: //[Optional] Zoom the map on that location
            animate: //[default true]
            );
```

##### Get Current Camera Position
Returns a CameraPosition containing the current camera coordinates and zoom level.
If the camera position is not available, returns default values (0,0) with zoom 0.

```dart
BaatoCameraPosition cameraPosition= mapController.cameraManager.getCameraPosition();
```

##### Zoom In
Increases the map zoom level by 1.
Animates the camera to zoom in and updates the last camera position.

```dart
mapController.cameraManager.zoomIn();
```

##### Zoom Out
Decreases the map zoom level by 1.
Animates the camera to zoom out and updates the last camera position.

```dart
mapController.cameraManager.zoomOut();
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

4. Retro Style:
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
## Baato API's

### Place Search
Searches for places based on a query string
```dart
 BaatoSearchPlaceResponse response = await Baato.api.
  place.search(query, //[Required] search query text
  limit: //[Optional] Maximum number of results to return
  type: // [Optional] Filter for place types
  radius: // [Optional] Search radius in meters
  currentCoordinate: // [Optional] Current location coordinates
  );
```

### Reverse GeoCoding
Performs reverse geocoding to find places near specified coordinates
```dart
BaatoPlaceResponse response = await Baato.api.
    place.reverseGeocode(baatoCoordinate,//[Required] geographic coordinates to search around
    limit: //[Optional] maximum number of results to return
    radius: //[Optional] search radius in meters 
    );
```

### Get and Draw Routes
Get routes between start and destination point

```dart
    BaatoRouteResponse route = await Baato.api.
      direction.getRoutes(
        startCoordinate: //[Required] Start Position Coordinate
        endCoordinate: // [Required] End Position Coordinate,
        mode: BaatoDirectionMode.foot, // [Optional] [car,bike,foot]
        decodePolyline: // [Optional] 
        alternatives:  //[Optional] Provides alternative routes to reach destination
        instructions: // [Optional] Provides Instructions to reach destination
        );

//Draw Route on the map
    mapController.routeManager.drawRouteFromResponse(
      route,
      lineLayerProperties: BaatoLineLayerProperties() //Customize line property
    );
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This package is available under the MIT license. See the LICENSE file for more info.
