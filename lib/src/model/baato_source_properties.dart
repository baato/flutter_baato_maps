import 'package:maplibre_gl/maplibre_gl.dart';

/// Base interface for all Baato source properties
///
/// This interface is implemented by various source property classes that define
/// different types of map sources such as vector, raster, GeoJSON, etc.
abstract class BaatoSourceProperties implements SourceProperties {}

/// Properties for vector tile sources in Baato maps
///
/// Vector tiles represent geographic data as vectors, allowing for efficient
/// styling and rendering at different zoom levels.
class BaatoVectorSourceProperties implements BaatoSourceProperties {
  /// A URL to a TileJSON resource. Supported protocols are `http:` and
  /// `https:`
  ///
  /// Type: string
  final String? url;

  /// An array of one or more tile source URLs, as in the TileJSON spec.
  ///
  /// Type: array
  final List<String>? tiles;

  /// An array containing the longitude and latitude of the southwest and
  /// northeast corners of the source's bounding box in the following order:
  /// `[sw.lng, sw.lat, ne.lng, ne.lat]`. When this property is included in
  /// a source, no tiles outside of the given bounds are requested by
  /// MapLibre.
  ///
  /// Type: array
  ///   default: [-180, -85.051129, 180, 85.051129]
  final List<double>? bounds;

  /// Influences the y direction of the tile coordinates. The
  /// global-mercator (aka Spherical Mercator) profile is assumed.
  ///
  /// Type: enum
  ///   default: xyz
  /// Options:
  ///   "xyz"
  ///      Slippy map tilenames scheme.
  ///   "tms"
  ///      OSGeo spec scheme.
  final String? scheme;

  /// Minimum zoom level for which tiles are available, as in the TileJSON
  /// spec.
  ///
  /// Type: number
  ///   default: 0
  final double? minzoom;

  /// Maximum zoom level for which tiles are available, as in the TileJSON
  /// spec. Data from tiles at the maxzoom are used when displaying the map
  /// at higher zoom levels.
  ///
  /// Type: number
  ///   default: 22
  final double? maxzoom;

  /// Contains an attribution to be displayed when the map is shown to a
  /// user.
  ///
  /// Type: string
  final String? attribution;

  /// A property to use as a feature id (for feature state). Either a
  /// property name, or an object of the form `{<sourceLayer>:
  /// <propertyName>}`. If specified as a string for a vector tile source,
  /// the same property is used across all its source layers.
  ///
  /// Type: promoteId
  final String? promoteId;

  /// Creates a new vector source properties instance
  const BaatoVectorSourceProperties({
    this.url,
    this.tiles,
    this.bounds = const [-180, -85.051129, 180, 85.051129],
    this.scheme = "xyz",
    this.minzoom = 0,
    this.maxzoom = 22,
    this.attribution,
    this.promoteId,
  });

  /// Creates a copy of this instance with specified properties replaced
  BaatoVectorSourceProperties copyWith(
    String? url,
    List<String>? tiles,
    List<double>? bounds,
    String? scheme,
    double? minzoom,
    double? maxzoom,
    String? attribution,
    String? promoteId,
  ) {
    return BaatoVectorSourceProperties(
      url: url ?? this.url,
      tiles: tiles ?? this.tiles,
      bounds: bounds ?? this.bounds,
      scheme: scheme ?? this.scheme,
      minzoom: minzoom ?? this.minzoom,
      maxzoom: maxzoom ?? this.maxzoom,
      attribution: attribution ?? this.attribution,
      promoteId: promoteId ?? this.promoteId,
    );
  }

  /// Converts this object to a JSON representation
  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};

    void addIfPresent(String fieldName, dynamic value) {
      if (value != null) {
        json[fieldName] = value;
      }
    }

    json["type"] = "vector";
    addIfPresent('url', url);
    addIfPresent('tiles', tiles);
    addIfPresent('bounds', bounds);
    addIfPresent('scheme', scheme);
    addIfPresent('minzoom', minzoom);
    addIfPresent('maxzoom', maxzoom);
    addIfPresent('attribution', attribution);
    addIfPresent('promoteId', promoteId);
    return json;
  }

  /// Creates a new instance from a JSON representation
  factory BaatoVectorSourceProperties.fromJson(Map<String, dynamic> json) {
    return BaatoVectorSourceProperties(
      url: json['url'],
      tiles: json['tiles'],
      bounds: json['bounds'],
      scheme: json['scheme'],
      minzoom: json['minzoom'],
      maxzoom: json['maxzoom'],
      attribution: json['attribution'],
      promoteId: json['promoteId'],
    );
  }
}

/// Properties for raster tile sources in Baato maps
///
/// Raster tiles are pre-rendered images that are displayed directly on the map.
class BaatoRasterSourceProperties implements BaatoSourceProperties {
  /// A URL to a TileJSON resource. Supported protocols are `http:` and
  /// `https:`.
  ///
  /// Type: string
  final String? url;

  /// An array of one or more tile source URLs, as in the TileJSON spec.
  ///
  /// Type: array
  final List<String>? tiles;

  /// An array containing the longitude and latitude of the southwest and
  /// northeast corners of the source's bounding box in the following order:
  /// `[sw.lng, sw.lat, ne.lng, ne.lat]`. When this property is included in
  /// a source, no tiles outside of the given bounds are requested by
  /// MapLibre.
  ///
  /// Type: array
  ///   default: [-180, -85.051129, 180, 85.051129]
  final List<double>? bounds;

  /// Minimum zoom level for which tiles are available, as in the TileJSON
  /// spec.
  ///
  /// Type: number
  ///   default: 0
  final double? minzoom;

  /// Maximum zoom level for which tiles are available, as in the TileJSON
  /// spec. Data from tiles at the maxzoom are used when displaying the map
  /// at higher zoom levels.
  ///
  /// Type: number
  ///   default: 22
  final double? maxzoom;

  /// The minimum visual size to display tiles for this layer. Only
  /// configurable for raster layers.
  ///
  /// Type: number
  ///   default: 512
  final double? tileSize;

  /// Influences the y direction of the tile coordinates. The
  /// global-mercator (aka Spherical Mercator) profile is assumed.
  ///
  /// Type: enum
  ///   default: xyz
  /// Options:
  ///   "xyz"
  ///      Slippy map tilenames scheme.
  ///   "tms"
  ///      OSGeo spec scheme.
  final String? scheme;

  /// Contains an attribution to be displayed when the map is shown to a
  /// user.
  ///
  /// Type: string
  final String? attribution;

  /// Creates a new raster source properties instance
  const BaatoRasterSourceProperties({
    this.url,
    this.tiles,
    this.bounds = const [-180, -85.051129, 180, 85.051129],
    this.minzoom = 0,
    this.maxzoom = 22,
    this.tileSize = 512,
    this.scheme = "xyz",
    this.attribution,
  });

  /// Creates a copy of this instance with specified properties replaced
  BaatoRasterSourceProperties copyWith(
    String? url,
    List<String>? tiles,
    List<double>? bounds,
    double? minzoom,
    double? maxzoom,
    double? tileSize,
    String? scheme,
    String? attribution,
  ) {
    return BaatoRasterSourceProperties(
      url: url ?? this.url,
      tiles: tiles ?? this.tiles,
      bounds: bounds ?? this.bounds,
      minzoom: minzoom ?? this.minzoom,
      maxzoom: maxzoom ?? this.maxzoom,
      tileSize: tileSize ?? this.tileSize,
      scheme: scheme ?? this.scheme,
      attribution: attribution ?? this.attribution,
    );
  }

  /// Converts this object to a JSON representation
  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};

    void addIfPresent(String fieldName, dynamic value) {
      if (value != null) {
        json[fieldName] = value;
      }
    }

    json["type"] = "raster";
    addIfPresent('url', url);
    addIfPresent('tiles', tiles);
    addIfPresent('bounds', bounds);
    addIfPresent('minzoom', minzoom);
    addIfPresent('maxzoom', maxzoom);
    addIfPresent('tileSize', tileSize);
    addIfPresent('scheme', scheme);
    addIfPresent('attribution', attribution);
    return json;
  }

  /// Creates a new instance from a JSON representation
  factory BaatoRasterSourceProperties.fromJson(Map<String, dynamic> json) {
    return BaatoRasterSourceProperties(
      url: json['url'],
      tiles: json['tiles'],
      bounds: json['bounds'],
      minzoom: json['minzoom'],
      maxzoom: json['maxzoom'],
      tileSize: json['tileSize'],
      scheme: json['scheme'],
      attribution: json['attribution'],
    );
  }
}

/// Properties for raster DEM (Digital Elevation Model) sources in Baato maps
///
/// Raster DEM sources provide elevation data that can be used for terrain visualization
/// and hillshading effects.
class BaatoRasterDemSourceProperties implements BaatoSourceProperties {
  /// A URL to a TileJSON resource. Supported protocols are `http:` and
  /// `https:`.
  ///
  /// Type: string
  final String? url;

  /// An array of one or more tile source URLs, as in the TileJSON spec.
  ///
  /// Type: array
  final List<String>? tiles;

  /// An array containing the longitude and latitude of the southwest and
  /// northeast corners of the source's bounding box in the following order:
  /// `[sw.lng, sw.lat, ne.lng, ne.lat]`. When this property is included in
  /// a source, no tiles outside of the given bounds are requested by
  /// MapLibre.
  ///
  /// Type: array
  ///   default: [-180, -85.051129, 180, 85.051129]
  final List<double>? bounds;

  /// Minimum zoom level for which tiles are available, as in the TileJSON
  /// spec.
  ///
  /// Type: number
  ///   default: 0
  final double? minzoom;

  /// Maximum zoom level for which tiles are available, as in the TileJSON
  /// spec. Data from tiles at the maxzoom are used when displaying the map
  /// at higher zoom levels.
  ///
  /// Type: number
  ///   default: 22
  final double? maxzoom;

  /// The minimum visual size to display tiles for this layer. Only
  /// configurable for raster layers.
  ///
  /// Type: number
  ///   default: 512
  final double? tileSize;

  /// Contains an attribution to be displayed when the map is shown to a
  /// user.
  ///
  /// Type: string
  final String? attribution;

  /// The encoding used by this source. Mapbox Terrain RGB is used by
  /// default
  ///
  /// Type: enum
  ///   default: mapbox
  /// Options:
  ///   "terrarium"
  ///      Terrarium format PNG tiles. See
  ///      https://aws.amazon.com/es/public-datasets/terrain/ for more info.
  ///   "mapbox"
  ///      Mapbox Terrain RGB tiles. See
  ///      https://www.mapbox.com/help/access-elevation-data/#mapbox-terrain-rgb
  ///      for more info.
  final String? encoding;

  /// Creates a new raster DEM source properties instance
  const BaatoRasterDemSourceProperties({
    this.url,
    this.tiles,
    this.bounds = const [-180, -85.051129, 180, 85.051129],
    this.minzoom = 0,
    this.maxzoom = 22,
    this.tileSize = 512,
    this.attribution,
    this.encoding = "mapbox",
  });

  /// Creates a copy of this instance with specified properties replaced
  BaatoRasterDemSourceProperties copyWith(
    String? url,
    List<String>? tiles,
    List<double>? bounds,
    double? minzoom,
    double? maxzoom,
    double? tileSize,
    String? attribution,
    String? encoding,
  ) {
    return BaatoRasterDemSourceProperties(
      url: url ?? this.url,
      tiles: tiles ?? this.tiles,
      bounds: bounds ?? this.bounds,
      minzoom: minzoom ?? this.minzoom,
      maxzoom: maxzoom ?? this.maxzoom,
      tileSize: tileSize ?? this.tileSize,
      attribution: attribution ?? this.attribution,
      encoding: encoding ?? this.encoding,
    );
  }

  /// Converts this object to a JSON representation
  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};

    void addIfPresent(String fieldName, dynamic value) {
      if (value != null) {
        json[fieldName] = value;
      }
    }

    json["type"] = "raster-dem";
    addIfPresent('url', url);
    addIfPresent('tiles', tiles);
    addIfPresent('bounds', bounds);
    addIfPresent('minzoom', minzoom);
    addIfPresent('maxzoom', maxzoom);
    addIfPresent('tileSize', tileSize);
    addIfPresent('attribution', attribution);
    addIfPresent('encoding', encoding);
    return json;
  }

  /// Creates a new instance from a JSON representation
  factory BaatoRasterDemSourceProperties.fromJson(Map<String, dynamic> json) {
    return BaatoRasterDemSourceProperties(
      url: json['url'],
      tiles: json['tiles'],
      bounds: json['bounds'],
      minzoom: json['minzoom'],
      maxzoom: json['maxzoom'],
      tileSize: json['tileSize'],
      attribution: json['attribution'],
      encoding: json['encoding'],
    );
  }
}

/// Properties for GeoJSON sources in Baato maps
///
/// GeoJSON sources provide vector data in GeoJSON format, which can be loaded from a URL
/// or directly from a GeoJSON object.
class BaatoGeojsonSourceProperties implements BaatoSourceProperties {
  /// A URL to a GeoJSON file, or inline GeoJSON.
  ///
  /// Type: *
  final Object? data;

  /// Maximum zoom level at which to create vector tiles (higher means
  /// greater detail at high zoom levels).
  ///
  /// Type: number
  ///   default: 18
  final double? maxzoom;

  /// Contains an attribution to be displayed when the map is shown to a
  /// user.
  ///
  /// Type: string
  final String? attribution;

  /// Size of the tile buffer on each side. A value of 0 produces no buffer.
  /// A value of 512 produces a buffer as wide as the tile itself. Larger
  /// values produce fewer rendering artifacts near tile edges and slower
  /// performance.
  ///
  /// Type: number
  ///   default: 128
  ///   minimum: 0
  ///   maximum: 512
  final double? buffer;

  /// Douglas-Peucker simplification tolerance (higher means simpler
  /// geometries and faster performance).
  ///
  /// Type: number
  ///   default: 0.375
  final double? tolerance;

  /// If the data is a collection of point features, setting this to true
  /// clusters the points by radius into groups. Cluster groups become new
  /// `Point` features in the source with additional properties:
  /// * `cluster` Is `true` if the point is a cluster
  /// * `cluster_id` A unqiue id for the cluster to be used in conjunction
  /// with the [cluster inspection
  /// methods](https://maplibre.org/maplibre-gl-js/docs/API/classes/maplibregl.GeoJSONSource/#getclusterexpansionzoom)
  /// * `point_count` Number of original points grouped into this cluster
  /// * `point_count_abbreviated` An abbreviated point count
  ///
  /// Type: boolean
  ///   default: false
  final bool? cluster;

  /// Radius of each cluster if clustering is enabled. A value of 512
  /// indicates a radius equal to the width of a tile.
  ///
  /// Type: number
  ///   default: 50
  ///   minimum: 0
  final double? clusterRadius;

  /// Max zoom on which to cluster points if clustering is enabled. Defaults
  /// to one zoom less than maxzoom (so that last zoom features are not
  /// clustered).
  ///
  /// Type: number
  final double? clusterMaxZoom;

  /// An object defining custom properties on the generated clusters if
  /// clustering is enabled, aggregating values from clustered points. Has
  /// the form `{"property_name": [operator, map_expression]}`. `operator`
  /// is any expression function that accepts at least 2 operands (e.g.
  /// `"+"` or `"max"`) — it accumulates the property value from
  /// clusters/points the cluster contains; `map_expression` produces the
  /// value of a single point.Example: `{"sum": ["+", ["get",
  /// "scalerank"]]}`.For more advanced use cases, in place of `operator`,
  /// you can use a custom reduce expression that references a special
  /// `["accumulated"]` value, e.g.:`{"sum": [["+", ["accumulated"],
  /// ["get", "sum"]], ["get", "scalerank"]]}`
  ///
  /// Type: *
  final Object? clusterProperties;

  /// Whether to calculate line distance metrics. This is required for line
  /// layers that specify `line-gradient` values.
  ///
  /// Type: boolean
  ///   default: false
  final bool? lineMetrics;

  /// Whether to generate ids for the geojson features. When enabled, the
  /// `feature.id` property will be auto assigned based on its index in the
  /// `features` array, over-writing any previous values.
  ///
  /// Type: boolean
  ///   default: false
  final bool? generateId;

  /// A property to use as a feature id (for feature state). Either a
  /// property name, or an object of the form `{<sourceLayer>:
  /// <propertyName>}`.
  ///
  /// Type: promoteId
  final String? promoteId;

  /// Creates a new GeoJSON source properties instance
  const BaatoGeojsonSourceProperties({
    this.data,
    this.maxzoom = 18,
    this.attribution,
    this.buffer = 128,
    this.tolerance = 0.375,
    this.cluster = false,
    this.clusterRadius = 50,
    this.clusterMaxZoom,
    this.clusterProperties,
    this.lineMetrics = false,
    this.generateId = false,
    this.promoteId,
  });

  /// Creates a copy of this instance with specified properties replaced
  BaatoGeojsonSourceProperties copyWith(
    Object? data,
    double? maxzoom,
    String? attribution,
    double? buffer,
    double? tolerance,
    bool? cluster,
    double? clusterRadius,
    double? clusterMaxZoom,
    Object? clusterProperties,
    bool? lineMetrics,
    bool? generateId,
    String? promoteId,
  ) {
    return BaatoGeojsonSourceProperties(
      data: data ?? this.data,
      maxzoom: maxzoom ?? this.maxzoom,
      attribution: attribution ?? this.attribution,
      buffer: buffer ?? this.buffer,
      tolerance: tolerance ?? this.tolerance,
      cluster: cluster ?? this.cluster,
      clusterRadius: clusterRadius ?? this.clusterRadius,
      clusterMaxZoom: clusterMaxZoom ?? this.clusterMaxZoom,
      clusterProperties: clusterProperties ?? this.clusterProperties,
      lineMetrics: lineMetrics ?? this.lineMetrics,
      generateId: generateId ?? this.generateId,
      promoteId: promoteId ?? this.promoteId,
    );
  }

  /// Converts this object to a JSON representation
  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};

    void addIfPresent(String fieldName, dynamic value) {
      if (value != null) {
        json[fieldName] = value;
      }
    }

    json["type"] = "geojson";
    addIfPresent('data', data);
    addIfPresent('maxzoom', maxzoom);
    addIfPresent('attribution', attribution);
    addIfPresent('buffer', buffer);
    addIfPresent('tolerance', tolerance);
    addIfPresent('cluster', cluster);
    addIfPresent('clusterRadius', clusterRadius);
    addIfPresent('clusterMaxZoom', clusterMaxZoom);
    addIfPresent('clusterProperties', clusterProperties);
    addIfPresent('lineMetrics', lineMetrics);
    addIfPresent('generateId', generateId);
    addIfPresent('promoteId', promoteId);
    return json;
  }

  /// Creates a new instance from a JSON representation
  factory BaatoGeojsonSourceProperties.fromJson(Map<String, dynamic> json) {
    return BaatoGeojsonSourceProperties(
      data: json['data'],
      maxzoom: json['maxzoom'],
      attribution: json['attribution'],
      buffer: json['buffer'],
      tolerance: json['tolerance'],
      cluster: json['cluster'],
      clusterRadius: json['clusterRadius'],
      clusterMaxZoom: json['clusterMaxZoom'],
      clusterProperties: json['clusterProperties'],
      lineMetrics: json['lineMetrics'],
      generateId: json['generateId'],
      promoteId: json['promoteId'],
    );
  }
}

/// Properties for video sources in Baato maps
///
/// Video sources allow displaying video content as a map layer, positioned
/// at specific geographic coordinates.
class BaatoVideoSourceProperties implements BaatoSourceProperties {
  /// URLs to video content in order of preferred format.
  ///
  /// Type: array
  final List<String>? urls;

  /// Corners of video specified in longitude, latitude pairs.
  ///
  /// Type: array
  final List<List>? coordinates;

  /// Creates a new video source properties instance
  const BaatoVideoSourceProperties({
    this.urls,
    this.coordinates,
  });

  /// Creates a copy of this instance with specified properties replaced
  BaatoVideoSourceProperties copyWith(
    List<String>? urls,
    List<List>? coordinates,
  ) {
    return BaatoVideoSourceProperties(
      urls: urls ?? this.urls,
      coordinates: coordinates ?? this.coordinates,
    );
  }

  /// Converts this object to a JSON representation
  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};

    void addIfPresent(String fieldName, dynamic value) {
      if (value != null) {
        json[fieldName] = value;
      }
    }

    json["type"] = "video";
    addIfPresent('urls', urls);
    addIfPresent('coordinates', coordinates);
    return json;
  }

  /// Creates a new instance from a JSON representation
  factory BaatoVideoSourceProperties.fromJson(Map<String, dynamic> json) {
    return BaatoVideoSourceProperties(
      urls: json['urls'],
      coordinates: json['coordinates'],
    );
  }
}

/// Properties for image sources in Baato maps
///
/// Image sources allow displaying raster images as a map layer, positioned
/// at specific geographic coordinates.
class BaatoImageSourceProperties implements BaatoSourceProperties {
  /// URL that points to an image.
  ///
  /// Type: string
  final String? url;

  /// Corners of image specified in longitude, latitude pairs.
  ///
  /// Type: array
  final List<List>? coordinates;

  /// Creates a new image source properties instance
  const BaatoImageSourceProperties({
    this.url,
    this.coordinates,
  });

  /// Creates a copy of this instance with specified properties replaced
  BaatoImageSourceProperties copyWith(
    String? url,
    List<List>? coordinates,
  ) {
    return BaatoImageSourceProperties(
      url: url ?? this.url,
      coordinates: coordinates ?? this.coordinates,
    );
  }

  /// Converts this object to a JSON representation
  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};

    void addIfPresent(String fieldName, dynamic value) {
      if (value != null) {
        json[fieldName] = value;
      }
    }

    json["type"] = "image";
    addIfPresent('url', url);
    addIfPresent('coordinates', coordinates);
    return json;
  }

  /// Creates a new instance from a JSON representation
  factory BaatoImageSourceProperties.fromJson(Map<String, dynamic> json) {
    return BaatoImageSourceProperties(
      url: json['url'],
      coordinates: json['coordinates'],
    );
  }
}
