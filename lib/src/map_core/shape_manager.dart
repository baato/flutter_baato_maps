import 'package:baato_maps/baato_maps.dart';
import 'package:baato_maps/src/map_core/geo_json_manager.dart';

/// A manager class that handles shape operations for Baato Maps.
///
/// This class provides methods to add, remove, and clear various shapes on the map,
/// including lines, circles, and fills (polygons). It works with the underlying
/// MapLibre map controller to manage these map elements.
class ShapeManager {
  /// The underlying MapLibre map controller used for shape operations
  final MapLibreMapController _mapLibreMapController;

  /// The source and layer manager for handling map sources and layers
  final GeoJsonManager _geoJsonManager;

  /// Creates a new ShapeManager with the specified MapLibre controller
  ///
  /// [_mapLibreMapController] is the MapLibre controller used for shape operations
  ShapeManager(this._mapLibreMapController, this._geoJsonManager);

  /// Gets the set of all fills (polygons) currently on the map
  Set<Fill> get fills => _mapLibreMapController.fills;

  /// Gets the set of all lines currently on the map
  Set<Line> get lines => _mapLibreMapController.lines;

  /// Gets the set of all circles currently on the map
  Set<Circle> get circles => _mapLibreMapController.circles;

  /// Callbacks that are triggered when a fill is tapped
  ArgumentCallbacks<Fill> get onFillTapped =>
      _mapLibreMapController.onFillTapped;

  /// Callbacks that are triggered when a line is tapped
  ArgumentCallbacks<Line> get onLineTapped =>
      _mapLibreMapController.onLineTapped;

  /// Callbacks that are triggered when a circle is tapped
  ArgumentCallbacks<Circle> get onCircleTapped =>
      _mapLibreMapController.onCircleTapped;

  /// Adds a line to the map between two points.
  ///
  /// Parameters:
  /// - [startPoint]: The starting coordinate of the line
  /// - [endPoint]: The ending coordinate of the line
  /// - [options]: Optional styling options for the line
  /// - [data]: Optional additional data to associate with the line
  ///
  /// Returns a [Future] that completes with the created [Line] object,
  /// which can be used to update or remove the line later.
  Future<Line> addLine(
    BaatoCoordinate startPoint,
    BaatoCoordinate endPoint, {
    BaatoLineOptions? options,
    Map<dynamic, dynamic>? data,
  }) async {
    final lineOptions =
        (options ?? BaatoLineOptions()).toLineOptions([startPoint, endPoint]);
    return await _mapLibreMapController.addLine(lineOptions, data);
  }

  /// Adds a multi-point line to the map.
  ///
  /// Parameters:
  /// - [points]: A list of coordinates that define the line path
  /// - [options]: Optional styling options for the line
  /// - [data]: Optional additional data to associate with the line
  ///
  /// Returns a [Future] that completes with the created [Line] object.
  /// Throws an [ArgumentError] if fewer than 3 points are provided.
  Future<Line> addMultiLine(
    List<BaatoCoordinate> points, {
    BaatoLineOptions? options,
    Map<dynamic, dynamic>? data,
  }) async {
    if (points.length <= 2) {
      throw ArgumentError('Points must have at least 3 coordinates');
    }
    final lineOptions = (options ?? BaatoLineOptions()).toLineOptions(points);

    return await _mapLibreMapController.addLine(lineOptions, data);
  }

  /// Removes a line from the map.
  ///
  /// Parameters:
  /// - [line]: The [Line] object to remove from the map
  ///
  /// Returns a [Future] that completes when the line has been removed.
  Future<void> removeLine(Line line) async {
    await _mapLibreMapController.removeLine(line);
  }

  /// Clears all lines from the map.
  ///
  /// Returns a [Future] that completes when all lines have been removed.
  Future<void> clearLines() async {
    await _mapLibreMapController.clearLines();
  }

  /// Adds a circle to the map.
  ///
  /// Parameters:
  /// - [options]: The [BaatoCircleOptions] defining the circle's appearance and position
  /// - [data]: Optional additional data to associate with the circle
  ///
  /// Returns a [Future] that completes with the created [Circle] object,
  /// which can be used to update or remove the circle later.
  Future<Circle> addCircle(
    BaatoCircleOptions options, {
    Map<dynamic, dynamic>? data,
  }) async {
    final circleOptions = options.toCircleOptions();
    return await _mapLibreMapController.addCircle(circleOptions, data);
  }

  /// Removes a circle from the map.
  ///
  /// Parameters:
  /// - [circle]: The [Circle] object to remove from the map
  ///
  /// Returns a [Future] that completes when the circle has been removed.
  Future<void> removeCircle(Circle circle) async {
    await _mapLibreMapController.removeCircle(circle);
  }

  /// Clears all circles from the map.
  ///
  /// Returns a [Future] that completes when all circles have been removed.
  Future<void> clearCircles() async {
    await _mapLibreMapController.clearCircles();
  }

  /// Adds a fill (polygon) to the map.
  ///
  /// Parameters:
  /// - [points]: A list of coordinates that define the polygon boundary
  /// - [options]: Optional styling options for the fill
  /// - [data]: Optional additional data to associate with the fill
  ///
  /// Returns a [Future] that completes with the created [Fill] object,
  /// which can be used to update or remove the fill later.
  Future<Fill> addFill(
    List<BaatoCoordinate> points, {
    BaatoFillOptions? options,
    Map<dynamic, dynamic>? data,
  }) async {
    final fillOptions = (options ?? BaatoFillOptions()).toFillOptions([points]);
    return await _mapLibreMapController.addFill(fillOptions, data);
  }

  /// Adds a multi-polygon fill to the map.
  ///
  /// Parameters:
  /// - [points]: A list of lists of coordinates that define multiple polygon boundaries
  /// - [options]: Optional styling options for the fill
  /// - [data]: Optional additional data to associate with the fill
  ///
  /// Returns a [Future] that completes with the created [Fill] object.
  Future<Fill> addMultiFill(
    List<List<BaatoCoordinate>> points, {
    BaatoFillOptions? options,
    Map<dynamic, dynamic>? data,
  }) async {
    final fillOptions = (options ?? BaatoFillOptions()).toFillOptions(points);
    return await _mapLibreMapController.addFill(fillOptions, data);
  }

  /// Removes a fill from the map.
  ///
  /// Parameters:
  /// - [fill]: The [Fill] object to remove from the map
  ///
  /// Returns a [Future] that completes when the fill has been removed.
  Future<void> removeFill(Fill fill) async {
    await _mapLibreMapController.removeFill(fill);
  }

  /// Clears all fills from the map.
  ///
  /// Returns a [Future] that completes when all fills have been removed.
  Future<void> clearFills() async {
    await _mapLibreMapController.clearFills();
  }

  /// Adds a line to the map with a specific layer ID.
  ///
  /// Parameters:
  /// - [layerId]: The ID of the layer to add the line to
  /// - [startPoint]: The starting coordinate of the line
  /// - [endPoint]: The ending coordinate of the line
  /// - [lineLayerProperties]: Optional styling options for the line
  ///
  /// Returns a [Future] that completes when the line has been added.
  Future<void> addLineWithLayerId(
    String layerId,
    BaatoCoordinate startPoint,
    BaatoCoordinate endPoint, {
    BaatoLineLayerProperties? lineLayerProperties,
  }) async {
    await addMultiLineWithLayerId(
      layerId,
      [startPoint, endPoint],
      lineLayerProperties: lineLayerProperties,
    );
  }

  /// Adds a multi-line to the map with a specific layer ID.
  ///
  /// Parameters:
  /// - [layerId]: The ID of the layer to add the multi-line to
  /// - [points]: A list of coordinates that define the line path
  /// - [lineLayerProperties]: Optional styling options for the line
  ///
  /// Returns a [Future] that completes when the multi-line has been added.
  Future<void> addMultiLineWithLayerId(
    String layerId,
    List<BaatoCoordinate> points, {
    BaatoLineLayerProperties? lineLayerProperties,
  }) async {
    final geoJson = {
      "type": "FeatureCollection",
      "features": [
        {
          "type": "Feature",
          "geometry": {
            "type": "LineString",
            "coordinates": points
                .map((coord) => [coord.longitude, coord.latitude])
                .toList(),
          },
          "properties": (lineLayerProperties ??
                  BaatoLineLayerProperties(
                    lineColor: "#000000",
                    lineWidth: 6,
                    lineOpacity: 1,
                    lineCap: "round",
                    lineJoin: "round",
                    lineDasharray: [],
                  ))
              .toJson(),
        },
      ],
    };
    await _geoJsonManager.addGeoJson(layerId, geoJson);
  }

  /// Removes a layer from the map with a specific layer ID.
  ///
  /// Parameters:
  /// - [layerId]: The ID of the layer to remove from the map
  ///
  /// Returns a [Future] that completes when the layer has been removed.
  Future<void> removeLayer(String layerId) async {
    await _geoJsonManager.removeGeoJson(layerId);
  }
}
