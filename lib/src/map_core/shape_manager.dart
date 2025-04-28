import 'package:baato_maps/baato_maps.dart';

/// Manages shape operations for Baato Maps.
///
/// Provides methods to add, remove, and clear various shapes on the map,
/// such as lines, circles, and fills (polygons), using the MapLibre map controller.
class ShapeManager {
  /// The MapLibre map controller for shape operations.
  final MapLibreMapController _mapLibreMapController;

  /// Constructs a ShapeManager with the given MapLibre controller.
  ///
  /// [_mapLibreMapController] is the MapLibre controller for shape operations.
  ShapeManager(this._mapLibreMapController);

  final Map<String, Line> _lineIds = {};
  final Map<String, Fill> _fillIds = {};
  final Map<String, Circle> _circleIds = {};

  /// Retrieves the list of shape IDs for lines currently managed by the ShapeManager.
  List<String> get shapeLineIds => _lineIds.keys.toList();

  /// Retrieves the list of shape IDs for fills currently managed by the ShapeManager.
  List<String> get shapeFillIds => _fillIds.keys.toList();

  /// Retrieves the list of shape IDs for circles currently managed by the ShapeManager.
  List<String> get shapeCircleIds => _circleIds.keys.toList();

  /// Retrieves all fills (polygons) currently on the map.
  Set<Fill> get fills => _mapLibreMapController.fills;

  /// Retrieves all lines currently on the map.
  Set<Line> get lines => _mapLibreMapController.lines;

  /// Retrieves all circles currently on the map.
  Set<Circle> get circles => _mapLibreMapController.circles;

  /// Callbacks triggered when a fill is tapped.
  ArgumentCallbacks<Fill> get onFillTapped =>
      _mapLibreMapController.onFillTapped;

  /// Callbacks triggered when a line is tapped.
  ArgumentCallbacks<Line> get onLineTapped =>
      _mapLibreMapController.onLineTapped;

  /// Callbacks triggered when a circle is tapped.
  ArgumentCallbacks<Circle> get onCircleTapped =>
      _mapLibreMapController.onCircleTapped;

  /// Adds a line to the map between two points.
  ///
  /// Parameters:
  /// - [startPoint]: The starting coordinate of the line.
  /// - [endPoint]: The ending coordinate of the line.
  /// - [options]: Optional styling options for the line.
  /// - [data]: Optional additional data to associate with the line.
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
  /// - [points]: A list of coordinates that define the line path.
  /// - [options]: Optional styling options for the line.
  /// - [data]: Optional additional data to associate with the line.
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
  /// - [line]: The [Line] object to remove from the map.
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
  /// - [options]: The [BaatoCircleOptions] defining the circle's appearance and position.
  /// - [data]: Optional additional data to associate with the circle.
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
  /// - [circle]: The [Circle] object to remove from the map.
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
  /// - [points]: A list of coordinates that define the polygon boundary.
  /// - [options]: Optional styling options for the fill.
  /// - [data]: Optional additional data to associate with the fill.
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
  /// - [points]: A list of lists of coordinates that define multiple polygon boundaries.
  /// - [options]: Optional styling options for the fill.
  /// - [data]: Optional additional data to associate with the fill.
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
  /// - [fill]: The [Fill] object to remove from the map.
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

  /// Adds a line to the map with a specific shape ID.
  ///
  /// Parameters:
  /// - [shapeId]: The ID of the shape to add the line to.
  /// - [startPoint]: The starting coordinate of the line.
  /// - [endPoint]: The ending coordinate of the line.
  /// - [options]: Optional styling options for the line.
  ///
  /// Returns a [Future] that completes when the line has been added.
  Future<Line> addLineWithId(
    String shapeId,
    BaatoCoordinate startPoint,
    BaatoCoordinate endPoint, {
    BaatoLineOptions? options,
  }) async {
    final line = await addLine(
      startPoint,
      endPoint,
      options: options,
    );
    _lineIds[shapeId] = line;
    return line;
  }

  /// Adds a multi-point line to the map with a specific shape ID.
  ///
  /// Parameters:
  /// - [shapeId]: The ID of the shape to add the line to.
  /// - [points]: A list of coordinates that define the line path.
  /// - [options]: Optional styling options for the line.
  ///
  /// Returns a [Future] that completes when the line has been added.
  Future<Line> addMultiLineWithId(
    String shapeId,
    List<BaatoCoordinate> points, {
    BaatoLineOptions? options,
  }) async {
    final line = await addMultiLine(points, options: options);
    _lineIds[shapeId] = line;
    return line;
  }

  /// Adds a fill (polygon) to the map with a specific shape ID.
  ///
  /// Parameters:
  /// - [shapeId]: The ID of the shape to add the fill to.
  /// - [points]: A list of coordinates that define the polygon boundary.
  /// - [options]: Optional styling options for the fill.
  ///
  /// Returns a [Future] that completes when the fill has been added.
  Future<Fill> addFillWithId(
    String shapeId,
    List<BaatoCoordinate> points, {
    BaatoFillOptions? options,
  }) async {
    final fill = await addFill(points, options: options);
    _fillIds[shapeId] = fill;
    return fill;
  }

  /// Adds a multi-polygon fill to the map with a specific shape ID.
  ///
  /// Parameters:
  /// - [shapeId]: The ID of the shape to add the fill to.
  /// - [points]: A list of lists of coordinates that define multiple polygon boundaries.
  /// - [options]: Optional styling options for the fill.
  ///
  /// Returns a [Future] that completes when the fill has been added.
  Future<Fill> addMultiFillWithId(
    String shapeId,
    List<List<BaatoCoordinate>> points, {
    BaatoFillOptions? options,
  }) async {
    final fill = await addMultiFill(points, options: options);
    _fillIds[shapeId] = fill;
    return fill;
  }

  /// Adds a circle to the map with a specific shape ID.
  ///
  /// Parameters:
  /// - [shapeId]: The ID of the shape to add the circle to.
  /// - [options]: The [BaatoCircleOptions] defining the circle's appearance and position.
  /// - [data]: Optional additional data to associate with the circle.
  ///
  /// Returns a [Future] that completes when the circle has been added.
  Future<Circle> addCircleWithId(
    String shapeId,
    BaatoCircleOptions options, {
    Map<dynamic, dynamic>? data,
  }) async {
    final circle = await addCircle(options, data: data);
    _circleIds[shapeId] = circle;
    return circle;
  }

  /// Removes a line from the map with a specific shape ID.
  ///
  /// Parameters:
  /// - [shapeId]: The ID of the shape to remove from the map.
  ///
  /// Returns a [Future] that completes when the shape has been removed.
  Future<Line?> removeLineWithId(String shapeId) async {
    if (_lineIds.containsKey(shapeId)) {
      final line = _lineIds[shapeId];
      await removeLine(line!);
      _lineIds.remove(shapeId);
      return line;
    }
    return null;
  }

  /// Removes a fill from the map with a specific shape ID.
  ///
  /// Parameters:
  /// - [shapeId]: The ID of the shape to remove from the map.
  ///
  /// Returns a [Future] that completes when the shape has been removed.
  Future<Fill?> removeFillWithId(String shapeId) async {
    if (_fillIds.containsKey(shapeId)) {
      final fill = _fillIds[shapeId];
      await removeFill(fill!);
      _fillIds.remove(shapeId);
      return fill;
    }
    return null;
  }

  /// Removes a circle from the map with a specific shape ID.
  ///
  /// Parameters:
  /// - [shapeId]: The ID of the shape to remove from the map.
  ///
  /// Returns a [Future] that completes when the shape has been removed.
  Future<Circle?> removeCircleWithId(String shapeId) async {
    if (_circleIds.containsKey(shapeId)) {
      final circle = _circleIds[shapeId];
      await removeCircle(circle!);
      _circleIds.remove(shapeId);
      return circle;
    }
    return null;
  }
}
