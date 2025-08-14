import 'package:baato_maps/baato_maps.dart';

/// Abstract interface for managing shape operations for Baato Maps.
///
/// Provides methods to add, remove, and clear various shapes on the map,
/// such as lines, circles, and fills (polygons).
abstract class ShapeManager {
  /// Retrieves the list of shape IDs for lines currently managed.
  List<String> get shapeLineIds;

  /// Retrieves the list of shape IDs for fills currently managed.
  List<String> get shapeFillIds;

  /// Retrieves the list of shape IDs for circles currently managed.
  List<String> get shapeCircleIds;

  /// Retrieves all fills (polygons) currently on the map.
  Set<Fill> get fills;

  /// Retrieves all lines currently on the map.
  Set<Line> get lines;

  /// Retrieves all circles currently on the map.
  Set<Circle> get circles;

  /// Callbacks triggered when a fill is tapped.
  ArgumentCallbacks<Fill> get onFillTapped;

  /// Callbacks triggered when a line is tapped.
  ArgumentCallbacks<Line> get onLineTapped;

  /// Callbacks triggered when a circle is tapped.
  ArgumentCallbacks<Circle> get onCircleTapped;

  /// Adds a line to the map between two points.
  ///
  /// Returns the created [Line] object.
  Future<Line> addLine(
    BaatoCoordinate startPoint,
    BaatoCoordinate endPoint, {
    BaatoLineOptions? options,
    Map<dynamic, dynamic>? data,
  });

  /// Adds a multi-point line to the map.
  ///
  /// Throws [ArgumentError] if fewer than 3 points are provided.
  Future<Line> addMultiLine(
    List<BaatoCoordinate> points, {
    BaatoLineOptions? options,
    Map<dynamic, dynamic>? data,
  });

  /// Removes a line from the map.
  Future<void> removeLine(Line line);

  /// Clears all lines from the map.
  Future<void> clearLines();

  /// Adds a circle to the map.
  ///
  /// Returns the created [Circle] object.
  Future<Circle> addCircle(
    BaatoCircleOptions options, {
    Map<dynamic, dynamic>? data,
  });

  /// Removes a circle from the map.
  Future<void> removeCircle(Circle circle);

  /// Clears all circles from the map.
  Future<void> clearCircles();

  /// Adds a fill (polygon) to the map.
  ///
  /// Returns the created [Fill] object.
  Future<Fill> addFill(
    List<BaatoCoordinate> points, {
    BaatoFillOptions? options,
    Map<dynamic, dynamic>? data,
  });

  /// Adds a multi-polygon fill to the map.
  ///
  /// Returns the created [Fill] object.
  Future<Fill> addMultiFill(
    List<List<BaatoCoordinate>> points, {
    BaatoFillOptions? options,
    Map<dynamic, dynamic>? data,
  });

  /// Removes a fill from the map.
  Future<void> removeFill(Fill fill);

  /// Clears all fills from the map.
  Future<void> clearFills();

  /// Adds a line to the map with a specific shape ID.
  Future<Line> addLineWithId(
    String shapeId,
    BaatoCoordinate startPoint,
    BaatoCoordinate endPoint, {
    BaatoLineOptions? options,
  });

  /// Adds a multi-point line to the map with a specific shape ID.
  Future<Line> addMultiLineWithId(
    String shapeId,
    List<BaatoCoordinate> points, {
    BaatoLineOptions? options,
  });

  /// Adds a fill (polygon) to the map with a specific shape ID.
  Future<Fill> addFillWithId(
    String shapeId,
    List<BaatoCoordinate> points, {
    BaatoFillOptions? options,
  });

  /// Adds a multi-polygon fill to the map with a specific shape ID.
  Future<Fill> addMultiFillWithId(
    String shapeId,
    List<List<BaatoCoordinate>> points, {
    BaatoFillOptions? options,
  });

  /// Adds a circle to the map with a specific shape ID.
  Future<Circle> addCircleWithId(
    String shapeId,
    BaatoCircleOptions options, {
    Map<dynamic, dynamic>? data,
  });

  /// Removes a line from the map with a specific shape ID.
  Future<Line?> removeLineWithId(String shapeId);

  /// Removes a fill from the map with a specific shape ID.
  Future<Fill?> removeFillWithId(String shapeId);

  /// Removes a circle from the map with a specific shape ID.
  Future<Circle?> removeCircleWithId(String shapeId);
}
