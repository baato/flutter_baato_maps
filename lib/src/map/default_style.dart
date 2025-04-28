import 'package:baato_maps/src/map/map_configuration.dart';
import 'package:path_provider/path_provider.dart';

class DefaultStyle {
  Future<String> loadStyle() async {
    final String cacheDirPath = (await getApplicationCacheDirectory()).path;
    //    "sprite": "file://$cacheDirPath/packages/baato_maps/lib/assets/map_res/sprites/warm_svgs",
    // WhereIterable ((Directory: 'file://$cacheDirPath/packages/baato_maps/lib/assets/map_res/glyphs'))
    var styleJson = '''{
      "owner": "Baato Maps",
      "metadata": {
        "openmaptiles:version": "3.x",
        "maputnik:renderer": "mbgljs",
        "openmaptiles:mapbox:source:url": "mapbox://openmaptiles.4qljc88t",
        "mapbox:autocomposite": false,
        "mapbox:type": "template",
        "openmaptiles:mapbox:owner": "openmaptiles"
      },
      "sources": {
        "all_data": {
          "tiles": [
            "https://api.baato.io/api/v1/maps/{z}/{x}/{y}.pbf?key=${BaatoMapConfig.instance.apiKey}"
          ],
          "maxzoom": 14,
          "type": "vector",
          "minzoom": 0
        },
        "boundary_tiles": {
          "tiles": [
            "https://osmchatbot.klldev.org/services/boundaries/tiles/{z}/{x}/{y}.pbf"
          ],
          "maxZoom": 14,
          "maxzoom": 8,
          "minZoom": 0,
          "type": "vector"
        },
        "buildings": {
          "tiles": [
            "https://baatooffline.sgp1.cdn.digitaloceanspaces.com/buildings_updated_dec_6_2023/{z}/{x}/{y}.pbf"
          ],
          "maxZoom": 14,
          "maxzoom": 14,
          "minZoom": 0,
          "type": "vector",
          "minzoom": 16
        },
        "airport_label": {
          "data":
              "https://baatocdn.sgp1.cdn.digitaloceanspaces.com/boundaries/lite/Airport.json",
          "type": "geojson"
        },
        "baato_inhouse": {
          "tiles": [
            "https://baatocdn.sgp1.digitaloceanspaces.com/pois/vector/{z}/{x}/{y}.pbf"
          ],
          "maxzoom": 14,
          "type": "vector",
          "minzoom": 15
        }
      },
      "name": "Warm",
      "sprite": "file://$cacheDirPath/packages/baato_maps/lib/assets/map_res/sprites/warm_svgs",
      "layers": [
        {
          "filter": ["all"],
          "layout": {"visibility": "visible"},
          "maxzoom": 24,
          "paint": {"background-color": "rgba(243, 243, 238, 1)"},
          "id": "Base_Background",
          "type": "background",
          "minzoom": 0
        },
        {
          "filter": [
            "all",
            ["==", "\$type", "Polygon"]
          ],
          "layout": {"visibility": "visible"},
          "maxzoom": 24,
          "paint": {"fill-color": "rgba(215, 215, 202, 1)", "fill-opacity": 1},
          "id": "Airport-area",
          "source": "all_data",
          "source-layer": "aeroway",
          "type": "fill",
          "minzoom": 7
        },
        {
          "filter": [
            "all",
            ["==", "class", "runway"],
            ["==", "\$type", "LineString"]
          ],
          "layout": {"visibility": "visible"},
          "maxzoom": 24,
          "paint": {
            "line-width": {
              "stops": [
                [9, 1],
                [13, 2],
                [16, 15]
              ]
            },
            "line-color": "rgba(255, 255, 255, 1)"
          },
          "id": "Airport-runway",
          "source": "all_data",
          "source-layer": "aeroway",
          "type": "line",
          "minzoom": 10
        },
        {
          "filter": [
            "all",
            ["==", "class", "taxiway"]
          ],
          "layout": {"visibility": "visible"},
          "maxzoom": 24,
          "paint": {
            "line-width": {
              "stops": [
                [13, 2],
                [14, 3],
                [15, 4],
                [16, 6]
              ]
            },
            "line-color": "rgba(255, 255, 255, 1)"
          },
          "id": "Airport-taxiway",
          "source": "all_data",
          "source-layer": "aeroway",
          "type": "line",
          "minzoom": 10
        },
        {
          "filter": [
            "all",
            ["in", "class", "school", "university", "kindergarten", "college"]
          ],
          "paint": {
            "fill-color": "rgba(209, 197, 247, 0.44)",
            "fill-opacity": {
              "stops": [
                [13, 0.5],
                [20, 1]
              ]
            },
            "fill-translate-anchor": "map"
          },
          "id": "Landuse-Education-area",
          "source": "all_data",
          "source-layer": "landuse",
          "type": "fill",
          "minzoom": 13
        },
        {
          "filter": [
            "all",
            ["==", "class", "hospital"]
          ],
          "layout": {"visibility": "visible"},
          "paint": {
            "fill-color": "rgba(233, 181, 181, 1)",
            "fill-opacity": 0.7
          },
          "id": "Landuse-Health-area",
          "source": "all_data",
          "source-layer": "landuse",
          "type": "fill",
          "minzoom": 14
        },
        {
          "filter": [
            "any",
            ["in", "class", "swimming_pool", "swimming"]
          ],
          "layout": {"visibility": "visible"},
          "maxzoom": 24,
          "paint": {"fill-color": "rgba(160, 196, 233, 1)"},
          "id": "Landuse-swimmingpool",
          "source": "all_data",
          "source-layer": "landuse",
          "type": "fill",
          "minzoom": 10
        },
        {
          "filter": [
            "any",
            ["==", "class", "industrial"]
          ],
          "layout": {"visibility": "visible"},
          "maxzoom": 24,
          "paint": {
            "fill-color": {
              "stops": [
                [6, "rgba(248, 69, 248, 0.16)"],
                [10, "rgba(248, 69, 248, 0.16)"]
              ]
            }
          },
          "id": "Landuse-industrial",
          "source": "all_data",
          "source-layer": "landuse",
          "type": "fill",
          "minzoom": 14
        },
        {
          "filter": [
            "any",
            ["==", "class", "commercial"]
          ],
          "layout": {"visibility": "visible"},
          "maxzoom": 24,
          "paint": {"fill-color": "rgba(175, 158, 176, 0.19)"},
          "id": "Landuse-commercial",
          "source": "all_data",
          "source-layer": "landuse",
          "type": "fill",
          "minzoom": 10
        },
        {
          "filter": [
            "any",
            ["==", "class", "residential"]
          ],
          "layout": {"visibility": "visible"},
          "maxzoom": 24,
          "paint": {
            "fill-color": {
              "stops": [
                [6, "rgba(211, 220, 216, 0.95)"],
                [16, "rgba(188, 203, 196, 0.42)"]
              ]
            }
          },
          "id": "Landuse-residential",
          "source": "all_data",
          "source-layer": "landuse",
          "type": "fill",
          "minzoom": 14
        },
        {
          "filter": [
            "any",
            ["==", "class", "military"]
          ],
          "layout": {"visibility": "visible"},
          "maxzoom": 24,
          "paint": {"fill-color": "rgba(120, 207, 106, 0.46)"},
          "id": "Landuse-military",
          "source": "all_data",
          "source-layer": "landuse",
          "type": "fill",
          "minzoom": 10
        },
        {
          "filter": [
            "any",
            ["in", "class", "parking"]
          ],
          "layout": {"visibility": "visible"},
          "maxzoom": 24,
          "paint": {
            "fill-outline-color": "rgba(169, 183, 197, 0.52)",
            "fill-color": "rgba(175, 214, 239, 0.3)"
          },
          "id": "Landuse-parking",
          "source": "all_data",
          "source-layer": "landuse",
          "type": "fill",
          "minzoom": 6
        },
        {
          "filter": [
            "any",
            [
              "in",
              "class",
              "park",
              "dog_park",
              "playground",
              "garden",
              "garden_centre",
              "zoo",
              "pitch",
              "stadium"
            ]
          ],
          "layout": {"visibility": "visible"},
          "maxzoom": 24,
          "paint": {
            "fill-outline-color": "rgba(157, 238, 184, 1)",
            "fill-color": "rgba(187, 236, 190, 1)",
            "fill-antialias": true
          },
          "id": "Landuse-outdoor/sports",
          "source": "all_data",
          "source-layer": "landuse",
          "type": "fill",
          "minzoom": 10
        },
        {
          "filter": [
            "all",
            ["in", "class", "grass"]
          ],
          "layout": {"visibility": "visible"},
          "maxzoom": 24,
          "paint": {"fill-color": "rgba(138, 234, 50, 0.27)"},
          "id": "Landuse-grass",
          "source": "all_data",
          "source-layer": "landcover",
          "type": "fill",
          "minzoom": 6
        },
        {
          "filter": [
            "any",
            ["in", "class", "farmland"]
          ],
          "layout": {"visibility": "visible"},
          "maxzoom": 24,
          "paint": {"fill-color": "rgba(197, 226, 206, 1)"},
          "id": "Landuse-farmland",
          "source": "all_data",
          "source-layer": "landcover",
          "type": "fill",
          "minzoom": 6
        },
        {
          "filter": [
            "any",
            ["==", "subclass", "forest"],
            ["==", "class", "wood"]
          ],
          "layout": {"visibility": "visible"},
          "maxzoom": 24,
          "paint": {
            "fill-color": {
              "stops": [
                [6, "rgba(225, 241, 227, 1)"],
                [10, "rgba(198, 235, 203, 1)"]
              ]
            },
            "fill-opacity": 1
          },
          "id": "Landuse-forest",
          "source": "all_data",
          "source-layer": "landcover",
          "type": "fill",
          "minzoom": 13
        },
        {
          "layout": {"visibility": "visible"},
          "maxzoom": 24,
          "paint": {
            "fill-outline-color": "rgba(166, 240, 221, 1)",
            "fill-color": "rgba(180, 234, 199, 0.8)",
            "fill-antialias": true,
            "fill-translate-anchor": "map"
          },
          "id": "Landuse-NationalPark",
          "source": "boundary_tiles",
          "source-layer": "baato_boundary_national_park",
          "type": "fill",
          "minzoom": 5
        },
        {
          "filter": [
            "any",
            ["==", "class", "ice"]
          ],
          "layout": {"visibility": "visible"},
          "maxzoom": 24,
          "paint": {
            "fill-outline-color": "rgba(188, 242, 241, 1)",
            "fill-color": "rgba(255, 255, 255, 1)"
          },
          "id": "Landuse-glacier",
          "source": "all_data",
          "source-layer": "landcover",
          "type": "fill",
          "minzoom": 6
        },
        {
          "filter": ["all"],
          "layout": {"visibility": "visible"},
          "maxzoom": 24,
          "paint": {
            "fill-color": "rgba(203, 203, 190, 0.26)",
            "fill-opacity": {
              "stops": [
                [10, 0],
                [16, 0.7],
                [18, 1]
              ]
            },
            "fill-antialias": true,
            "fill-translate-anchor": "map"
          },
          "id": "Building",
          "source": "buildings",
          "source-layer": "building",
          "type": "fill",
          "minzoom": 18
        },
        {
          "filter": [
            "all",
            ["==", "\$type", "Polygon"],
            ["!=", "waterway", "river"]
          ],
          "layout": {"visibility": "visible"},
          "maxzoom": 24,
          "paint": {
            "fill-outline-color": "rgba(104, 223, 219, 0)",
            "fill-color": "rgba(140, 180, 230, 1)"
          },
          "id": "Waterway-lake",
          "source": "all_data",
          "source-layer": "water",
          "type": "fill",
          "minzoom": 9
        },
        {
          "filter": [
            "all",
            ["==", "class", "river"],
            ["==", "\$type", "Polygon"]
          ],
          "layout": {"visibility": "visible"},
          "maxzoom": 24,
          "paint": {"fill-color": "rgba(140, 180, 230, 1)"},
          "id": "Waterway-riverbank",
          "source": "all_data",
          "source-layer": "water",
          "type": "fill",
          "minzoom": 12
        },
        {
          "filter": [
            "all",
            ["in", "class", "stream", "canal"]
          ],
          "layout": {"visibility": "visible"},
          "maxzoom": 24,
          "paint": {
            "line-width": {
              "stops": [
                [13, 1],
                [15, 2],
                [16, 3],
                [17, 4],
                [18, 5]
              ]
            },
            "line-color": "rgba(140, 180, 230, 1)"
          },
          "id": "Waterway-stream",
          "source": "all_data",
          "source-layer": "waterway",
          "type": "line",
          "minzoom": 12
        },
        {
          "filter": [
            "all",
            ["==", "class", "river"]
          ],
          "layout": {"visibility": "visible"},
          "maxzoom": 24,
          "paint": {
            "line-width": {
              "stops": [
                [10, 0.5],
                [11, 1],
                [13, 3],
                [15, 5],
                [16, 7],
                [18, 10]
              ]
            },
            "line-color": "rgba(140, 180, 230, 1)"
          },
          "id": "Waterway-river",
          "source": "all_data",
          "source-layer": "waterway",
          "type": "line",
          "minzoom": 8
        },
        {
          "layout": {
            "visibility": "visible",
            "line-cap": "round",
            "line-join": "bevel"
          },
          "maxzoom": 24,
          "paint": {
            "line-translate-anchor": "map",
            "line-width": {
              "stops": [
                [12, 1],
                [14, 1],
                [17, 4],
                [18, 5]
              ]
            },
            "line-offset": 0,
            "line-opacity": {
              "stops": [
                [12, 0],
                [14, 1]
              ]
            },
            "line-color": "rgba(203, 201, 196, 1)"
          },
          "id": "HighwayCasing-path",
          "source": "all_data",
          "source-layer": "highway_path",
          "type": "line",
          "minzoom": 13
        },
        {
          "layout": {
            "visibility": "visible",
            "line-cap": "round",
            "line-join": "bevel"
          },
          "maxzoom": 24,
          "paint": {
            "line-translate-anchor": "map",
            "line-width": {
              "stops": [
                [13, 2],
                [15, 3.5],
                [16, 7],
                [17, 8.5],
                [18, 11],
                [19, 12]
              ]
            },
            "line-offset": 0,
            "line-opacity": {
              "stops": [
                [12, 0],
                [14, 1]
              ]
            },
            "line-color": "rgba(203, 201, 196, 1)"
          },
          "id": "HighwayCasing-pedestrian",
          "source": "all_data",
          "source-layer": "highway_pedestrian",
          "type": "line",
          "minzoom": 12
        },
        {
          "filter": [
            "all",
            ["in", "brunnel", "bridge"]
          ],
          "layout": {
            "visibility": "visible",
            "line-cap": "round",
            "line-join": "bevel"
          },
          "maxzoom": 24,
          "paint": {
            "line-translate-anchor": "map",
            "line-width": {
              "stops": [
                [13, 2],
                [15, 3.5],
                [16, 7],
                [17, 8.5],
                [18, 11],
                [19, 12]
              ]
            },
            "line-offset": 0,
            "line-opacity": {
              "stops": [
                [12, 0],
                [14, 1]
              ]
            },
            "line-color": "rgba(101, 103, 110, 1)"
          },
          "id": "HighwayCasing-pedestrian-bridge",
          "source": "all_data",
          "source-layer": "highway_pedestrian",
          "type": "line",
          "minzoom": 12
        },
        {
          "layout": {
            "visibility": "visible",
            "line-cap": "round",
            "line-join": "bevel"
          },
          "maxzoom": 24,
          "paint": {
            "line-translate-anchor": "map",
            "line-width": {
              "stops": [
                [13, 2],
                [15, 3.5],
                [16, 7],
                [17, 8.5],
                [18, 11],
                [19, 12]
              ]
            },
            "line-offset": 0,
            "line-opacity": {
              "stops": [
                [12, 0],
                [14, 1]
              ]
            },
            "line-color": "rgba(203, 201, 196, 1)"
          },
          "id": "HighwayCasing-track",
          "source": "all_data",
          "source-layer": "highway_track",
          "type": "line",
          "minzoom": 12
        },
        {
          "filter": [
            "all",
            ["in", "brunnel", "bridge"]
          ],
          "layout": {
            "visibility": "visible",
            "line-cap": "round",
            "line-join": "bevel"
          },
          "maxzoom": 24,
          "paint": {
            "line-translate-anchor": "map",
            "line-width": {
              "stops": [
                [13, 2],
                [15, 3.5],
                [16, 7],
                [17, 8.5],
                [18, 11],
                [19, 15]
              ]
            },
            "line-offset": 0,
            "line-opacity": {
              "stops": [
                [12, 0],
                [14, 1]
              ]
            },
            "line-color": "rgba(101, 103, 110, 1)"
          },
          "id": "HighwayCasing-track-bridge",
          "source": "all_data",
          "source-layer": "highway_track",
          "type": "line",
          "minzoom": 12
        },
        {
          "layout": {
            "visibility": "visible",
            "line-cap": "round",
            "line-join": "bevel"
          },
          "maxzoom": 24,
          "paint": {
            "line-translate-anchor": "map",
            "line-width": {
              "stops": [
                [13, 2],
                [15, 3.5],
                [16, 7],
                [17, 8.5],
                [18, 11],
                [19, 12]
              ]
            },
            "line-offset": 0,
            "line-opacity": {
              "stops": [
                [12, 0],
                [14, 1]
              ]
            },
            "line-color": "rgba(203, 201, 196, 1)"
          },
          "id": "HighwayCasing-service",
          "source": "all_data",
          "source-layer": "highway_service",
          "type": "line",
          "minzoom": 12
        },
        {
          "filter": [
            "all",
            ["in", "brunnel", "bridge"]
          ],
          "layout": {
            "visibility": "visible",
            "line-cap": "round",
            "line-join": "bevel"
          },
          "maxzoom": 24,
          "paint": {
            "line-translate-anchor": "map",
            "line-width": {
              "stops": [
                [13, 2],
                [15, 3.5],
                [16, 7],
                [17, 8.5],
                [18, 11],
                [19, 12]
              ]
            },
            "line-offset": 0,
            "line-opacity": {
              "stops": [
                [12, 0],
                [14, 1]
              ]
            },
            "line-color": "rgba(101, 103, 110, 1)"
          },
          "id": "HighwayCasing-service-bridge",
          "source": "all_data",
          "source-layer": "highway_service",
          "type": "line",
          "minzoom": 12
        },
        {
          "filter": [
            "all",
            [
              "in",
              "class",
              "unclassified",
              "residential",
              "road",
              "living_street"
            ]
          ],
          "layout": {
            "visibility": "visible",
            "line-cap": "round",
            "line-join": "bevel"
          },
          "maxzoom": 24,
          "paint": {
            "line-translate-anchor": "map",
            "line-width": {
              "stops": [
                [13, 3],
                [14, 5],
                [15, 6],
                [16, 12],
                [17, 13],
                [18, 17]
              ]
            },
            "line-offset": 0,
            "line-opacity": {
              "stops": [
                [12, 0],
                [14, 1]
              ]
            },
            "line-color": "rgba(203, 201, 196, 1)"
          },
          "id": "HighwayCasing-minor",
          "source": "all_data",
          "source-layer": "highway_minor",
          "type": "line",
          "minzoom": 12
        },
        {
          "filter": [
            "all",
            [
              "in",
              "class",
              "unclassified",
              "residential",
              "road",
              "living_street"
            ],
            ["in", "brunnel", "bridge"]
          ],
          "layout": {
            "visibility": "visible",
            "line-cap": "round",
            "line-join": "bevel"
          },
          "maxzoom": 24,
          "paint": {
            "line-translate-anchor": "map",
            "line-width": {
              "stops": [
                [13, 3],
                [14, 5],
                [15, 6],
                [16, 12],
                [17, 13],
                [18, 17]
              ]
            },
            "line-offset": 0,
            "line-opacity": {
              "stops": [
                [12, 0],
                [14, 1]
              ]
            },
            "line-color": "rgba(101, 103, 110, 1)"
          },
          "id": "HighwayCasing-minor-bridge",
          "source": "all_data",
          "source-layer": "highway_minor",
          "type": "line",
          "minzoom": 12
        },
        {
          "layout": {
            "visibility": "visible",
            "line-cap": "round",
            "line-join": "bevel"
          },
          "maxzoom": 24,
          "paint": {
            "line-translate-anchor": "map",
            "line-width": {
              "stops": [
                [11, 3.5],
                [12, 5],
                [13, 6],
                [14, 9.3],
                [15, 10.5],
                [16, 18],
                [17, 21],
                [18, 27],
                [19, 42]
              ]
            },
            "line-offset": 0,
            "line-opacity": {
              "stops": [
                [10, 0],
                [12, 1]
              ]
            },
            "line-color": {
              "stops": [
                [6, "rgba(255, 255, 255, 1)"],
                [10, "rgba(203, 201, 196, 1)"]
              ]
            }
          },
          "id": "HighwayCasing-tertiary_link",
          "source": "all_data",
          "source-layer": "highway_tertiary_link",
          "type": "line",
          "minzoom": 10
        },
        {
          "layout": {
            "visibility": "visible",
            "line-cap": "round",
            "line-join": "bevel"
          },
          "maxzoom": 24,
          "paint": {
            "line-translate-anchor": "map",
            "line-width": {
              "stops": [
                [11, 3.5],
                [12, 5],
                [13, 6],
                [14, 9.3],
                [15, 10.5],
                [16, 18],
                [17, 21],
                [18, 27],
                [19, 42]
              ]
            },
            "line-offset": 0,
            "line-opacity": {
              "stops": [
                [10, 0],
                [12, 1]
              ]
            },
            "line-color": {
              "stops": [
                [6, "rgba(255, 255, 255, 1)"],
                [10, "rgba(203, 201, 196, 1)"]
              ]
            }
          },
          "id": "HighwayCasing-tertiary",
          "source": "all_data",
          "source-layer": "highway_tertiary",
          "type": "line",
          "minzoom": 10
        },
        {
          "filter": [
            "all",
            ["in", "brunnel", "bridge"]
          ],
          "layout": {
            "visibility": "visible",
            "line-cap": "round",
            "line-join": "bevel"
          },
          "maxzoom": 24,
          "paint": {
            "line-translate-anchor": "map",
            "line-width": {
              "stops": [
                [11, 3.5],
                [12, 5],
                [13, 6],
                [14, 9.3],
                [15, 10.5],
                [16, 18],
                [17, 21],
                [18, 27],
                [19, 42]
              ]
            },
            "line-offset": 0,
            "line-opacity": {
              "stops": [
                [10, 0],
                [12, 1]
              ]
            },
            "line-color": "rgba(101, 103, 110, 1)"
          },
          "id": "HighwayCasing-tertiary_link-bridge",
          "source": "all_data",
          "source-layer": "highway_tertiary_link",
          "type": "line",
          "minzoom": 11
        },
        {
          "filter": [
            "all",
            ["in", "brunnel", "bridge"]
          ],
          "layout": {
            "visibility": "visible",
            "line-cap": "round",
            "line-join": "bevel"
          },
          "maxzoom": 24,
          "paint": {
            "line-translate-anchor": "map",
            "line-width": {
              "stops": [
                [11, 3.5],
                [12, 5],
                [13, 5.7],
                [14, 9.3],
                [15, 10.5],
                [16, 18],
                [17, 21],
                [18, 27],
                [19, 42]
              ]
            },
            "line-offset": 0,
            "line-opacity": {
              "stops": [
                [10, 0],
                [12, 1]
              ]
            },
            "line-color": "rgba(101, 103, 110, 1)"
          },
          "id": "HighwayCasing-tertiary-bridge",
          "source": "all_data",
          "source-layer": "highway_tertiary",
          "type": "line",
          "minzoom": 11
        },
        {
          "layout": {
            "visibility": "visible",
            "line-cap": "round",
            "line-join": "bevel"
          },
          "maxzoom": 24,
          "paint": {
            "line-translate-anchor": "map",
            "line-width": {
              "stops": [
                [11, 3.5],
                [12, 5],
                [13, 6],
                [14, 9.3],
                [15, 10.5],
                [16, 18],
                [17, 21],
                [18, 27],
                [19, 42]
              ]
            },
            "line-offset": 0,
            "line-opacity": {
              "stops": [
                [10, 0],
                [12, 1]
              ]
            },
            "line-color": {
              "stops": [
                [6, "rgba(255, 255, 255, 1)"],
                [10, "rgba(203, 201, 196, 1)"]
              ]
            }
          },
          "id": "HighwayCasing-secondary_link",
          "source": "all_data",
          "source-layer": "highway_secondary_link",
          "type": "line",
          "minzoom": 10
        },
        {
          "layout": {
            "visibility": "visible",
            "line-cap": "round",
            "line-join": "bevel"
          },
          "maxzoom": 24,
          "paint": {
            "line-translate-anchor": "map",
            "line-width": {
              "stops": [
                [11, 3.5],
                [12, 5],
                [13, 6],
                [14, 9.3],
                [15, 10.5],
                [16, 18],
                [17, 21],
                [18, 27],
                [19, 42]
              ]
            },
            "line-offset": 0,
            "line-opacity": {
              "stops": [
                [10, 0],
                [12, 1]
              ]
            },
            "line-color": {
              "stops": [
                [6, "rgba(255, 255, 255, 1)"],
                [10, "rgba(203, 201, 196, 1)"]
              ]
            }
          },
          "id": "HighwayCasing-secondary",
          "source": "all_data",
          "source-layer": "highway_secondary",
          "type": "line",
          "minzoom": 10
        },
        {
          "filter": [
            "all",
            ["in", "brunnel", "bridge"]
          ],
          "layout": {
            "visibility": "visible",
            "line-cap": "round",
            "line-join": "bevel"
          },
          "maxzoom": 24,
          "paint": {
            "line-translate-anchor": "map",
            "line-width": {
              "stops": [
                [11, 3.5],
                [12, 5],
                [13, 6],
                [14, 9.3],
                [15, 10.5],
                [16, 18],
                [17, 21],
                [18, 27],
                [19, 42]
              ]
            },
            "line-offset": 0,
            "line-opacity": {
              "stops": [
                [10, 0],
                [12, 1]
              ]
            },
            "line-color": "rgba(101, 103, 110, 1)"
          },
          "id": "HighwayCasing-secondary_link-bridge",
          "source": "all_data",
          "source-layer": "highway_secondary_link",
          "type": "line",
          "minzoom": 11
        },
        {
          "filter": [
            "all",
            ["in", "brunnel", "bridge"]
          ],
          "layout": {
            "visibility": "visible",
            "line-cap": "round",
            "line-join": "bevel"
          },
          "maxzoom": 24,
          "paint": {
            "line-translate-anchor": "map",
            "line-width": {
              "stops": [
                [11, 3.5],
                [12, 5],
                [13, 6],
                [14, 9.3],
                [15, 10.5],
                [16, 18],
                [17, 21],
                [18, 27],
                [19, 42]
              ]
            },
            "line-offset": 0,
            "line-opacity": {
              "stops": [
                [10, 0],
                [12, 1]
              ]
            },
            "line-color": "rgba(101, 103, 110, 1)"
          },
          "id": "HighwayCasing-secondary-bridge",
          "source": "all_data",
          "source-layer": "highway_secondary",
          "type": "line",
          "minzoom": 11
        },
        {
          "layout": {
            "visibility": "visible",
            "line-cap": "round",
            "line-join": "bevel"
          },
          "maxzoom": 24,
          "paint": {
            "line-translate-anchor": "map",
            "line-width": {
              "stops": [
                [9, 3],
                [11, 4],
                [12, 5],
                [13, 10],
                [14, 14],
                [15, 18],
                [16, 21],
                [17, 27],
                [18, 32],
                [19, 52]
              ]
            },
            "line-offset": 0,
            "line-color": "rgba(193, 206, 194, 1)"
          },
          "id": "HighwayCasing-primary_link",
          "source": "all_data",
          "source-layer": "highway_primary_link",
          "type": "line",
          "minzoom": 7
        },
        {
          "layout": {
            "visibility": "visible",
            "line-cap": "round",
            "line-join": "bevel"
          },
          "maxzoom": 24,
          "paint": {
            "line-translate-anchor": "map",
            "line-width": {
              "stops": [
                [9, 3],
                [11, 4],
                [12, 5],
                [13, 10],
                [14, 14],
                [15, 18],
                [16, 21],
                [17, 27],
                [18, 32],
                [19, 52]
              ]
            },
            "line-offset": 0,
            "line-color": {
              "stops": [
                [6, "rgba(255, 255, 255, 1)"],
                [9, "rgba(203, 201, 196, 1)"]
              ]
            }
          },
          "id": "HighwayCasing-primary",
          "source": "all_data",
          "source-layer": "highway_primary",
          "type": "line",
          "minzoom": 7
        },
        {
          "filter": [
            "all",
            ["in", "brunnel", "bridge"]
          ],
          "layout": {
            "visibility": "visible",
            "line-cap": "round",
            "line-join": "bevel"
          },
          "maxzoom": 24,
          "paint": {
            "line-translate-anchor": "map",
            "line-width": {
              "stops": [
                [9, 3],
                [11, 4],
                [12, 5],
                [13, 10],
                [14, 14],
                [15, 18],
                [16, 21],
                [17, 27],
                [18, 32],
                [19, 52]
              ]
            },
            "line-offset": 0,
            "line-color": "rgba(101, 103, 110, 1)"
          },
          "id": "HighwayCasing-primary_link-bridge",
          "source": "all_data",
          "source-layer": "highway_primary_link",
          "type": "line",
          "minzoom": 11
        },
        {
          "filter": [
            "all",
            ["in", "brunnel", "bridge"]
          ],
          "layout": {
            "visibility": "visible",
            "line-cap": "round",
            "line-join": "bevel"
          },
          "maxzoom": 24,
          "paint": {
            "line-translate-anchor": "map",
            "line-width": {
              "stops": [
                [9, 3],
                [11, 4],
                [12, 5],
                [13, 10],
                [14, 14],
                [15, 18],
                [16, 21],
                [17, 27],
                [18, 32],
                [19, 52]
              ]
            },
            "line-offset": 0,
            "line-color": "rgba(101, 103, 110, 1)"
          },
          "id": "HighwayCasing-primary-bridge",
          "source": "all_data",
          "source-layer": "highway_primary",
          "type": "line",
          "minzoom": 11
        },
        {
          "layout": {
            "visibility": "visible",
            "line-cap": "round",
            "line-join": "bevel"
          },
          "maxzoom": 24,
          "paint": {
            "line-translate-anchor": "map",
            "line-width": {
              "stops": [
                [7, 2],
                [9, 3],
                [11, 5],
                [12, 5],
                [13, 10],
                [14, 14],
                [15, 18],
                [16, 21],
                [17, 27],
                [18, 32],
                [19, 52]
              ]
            },
            "line-offset": 0,
            "line-color": "rgba(193, 206, 194, 1)"
          },
          "id": "HighwayCasing-trunk_link",
          "source": "all_data",
          "source-layer": "highway_trunk_link",
          "type": "line",
          "minzoom": 7
        },
        {
          "layout": {
            "visibility": "visible",
            "line-cap": "round",
            "line-join": "bevel"
          },
          "maxzoom": 24,
          "paint": {
            "line-translate-anchor": "map",
            "line-width": {
              "stops": [
                [7, 2],
                [9, 3],
                [11, 5],
                [12, 5],
                [13, 10],
                [14, 14],
                [15, 18],
                [16, 21],
                [17, 27],
                [18, 32],
                [19, 52]
              ]
            },
            "line-offset": 0,
            "line-color": {
              "stops": [
                [6, "rgba(255, 255, 255, 1)"],
                [10, "rgba(203, 201, 196, 1)"]
              ]
            }
          },
          "id": "HighwayCasing-trunk",
          "source": "all_data",
          "source-layer": "highway_trunk",
          "type": "line",
          "minzoom": 7
        },
        {
          "filter": [
            "all",
            ["==", "brunnel", "bridge"]
          ],
          "layout": {
            "visibility": "visible",
            "line-cap": "round",
            "line-join": "bevel"
          },
          "maxzoom": 24,
          "paint": {
            "line-translate-anchor": "map",
            "line-width": {
              "stops": [
                [7, 2],
                [9, 3],
                [11, 5],
                [12, 5],
                [13, 10],
                [14, 14],
                [15, 18],
                [16, 21],
                [17, 27],
                [18, 32],
                [19, 52]
              ]
            },
            "line-offset": 0,
            "line-color": "rgba(101, 103, 110, 1)"
          },
          "id": "HighwayCasing-trunk_link-bridge",
          "source": "all_data",
          "source-layer": "highway_trunk_link",
          "type": "line",
          "minzoom": 11
        },
        {
          "filter": [
            "all",
            ["==", "brunnel", "bridge"]
          ],
          "layout": {
            "visibility": "visible",
            "line-cap": "round",
            "line-join": "bevel"
          },
          "maxzoom": 24,
          "paint": {
            "line-translate-anchor": "map",
            "line-width": {
              "stops": [
                [7, 2],
                [9, 3],
                [11, 5],
                [12, 5],
                [13, 10],
                [14, 14],
                [15, 18],
                [16, 21],
                [17, 27],
                [18, 32],
                [19, 52]
              ]
            },
            "line-offset": 0,
            "line-color": "rgba(101, 103, 110, 1)"
          },
          "id": "HighwayCasing-trunk-bridge",
          "source": "all_data",
          "source-layer": "highway_trunk",
          "type": "line",
          "minzoom": 11
        },
        {
          "filter": [
            "all",
            ["==", "class", "steps"]
          ],
          "layout": {
            "visibility": "visible",
            "line-cap": "butt",
            "line-join": "bevel"
          },
          "maxzoom": 24,
          "paint": {
            "line-translate-anchor": "map",
            "line-width": {
              "stops": [
                [12, 0.7],
                [14, 0.9],
                [17, 2.5],
                [18, 4]
              ]
            },
            "line-gap-width": 0.1,
            "line-offset": 0,
            "line-dasharray": [1, 1],
            "line-color": "rgba(193, 187, 187, 1)"
          },
          "id": "Highway-steps",
          "source": "all_data",
          "source-layer": "highway_minor",
          "type": "line",
          "minzoom": 12.5
        },
        {
          "filter": ["all"],
          "layout": {
            "visibility": "visible",
            "line-cap": "round",
            "line-join": "bevel"
          },
          "maxzoom": 24,
          "paint": {
            "line-translate-anchor": "map",
            "line-width": {
              "stops": [
                [12, 1],
                [14, 1],
                [17, 3],
                [18, 4]
              ]
            },
            "line-offset": 0,
            "line-dasharray": {
              "stops": [
                [
                  16,
                  [3, 1]
                ],
                [
                  17,
                  [5, 3]
                ]
              ]
            },
            "line-color": "rgba(248, 248, 248, 1)"
          },
          "id": "Highway-path",
          "source": "all_data",
          "source-layer": "highway_path",
          "type": "line",
          "minzoom": 12.5
        },
        {
          "layout": {
            "visibility": "visible",
            "line-cap": "round",
            "line-join": "bevel"
          },
          "maxzoom": 24,
          "paint": {
            "line-translate-anchor": "map",
            "line-width": {
              "stops": [
                [13, 0.9],
                [15, 2.3],
                [16, 5.4],
                [17, 6.9],
                [18, 9.4],
                [19, 10.4]
              ]
            },
            "line-offset": 0,
            "line-opacity": {
              "stops": [
                [12, 0.3],
                [14, 1]
              ]
            },
            "line-color": "rgba(255, 255, 255, 1)"
          },
          "id": "Highway-pedestrian",
          "source": "all_data",
          "source-layer": "highway_pedestrian",
          "type": "line",
          "minzoom": 13
        },
        {
          "layout": {
            "visibility": "visible",
            "line-cap": "round",
            "line-join": "bevel"
          },
          "maxzoom": 24,
          "paint": {
            "line-translate-anchor": "map",
            "line-width": {
              "stops": [
                [13, 0.9],
                [15, 2.3],
                [16, 5.4],
                [17, 6.9],
                [18, 9.4],
                [19, 10.4]
              ]
            },
            "line-offset": 0,
            "line-opacity": {
              "stops": [
                [12, 0.3],
                [14, 1]
              ]
            },
            "line-color": "rgba(252, 255, 250, 1)"
          },
          "id": "Highway-track",
          "source": "all_data",
          "source-layer": "highway_track",
          "type": "line",
          "minzoom": 13
        },
        {
          "layout": {
            "visibility": "visible",
            "line-cap": "round",
            "line-join": "bevel"
          },
          "maxzoom": 24,
          "paint": {
            "line-translate-anchor": "map",
            "line-width": {
              "stops": [
                [13, 0.9],
                [15, 2.3],
                [16, 5.4],
                [17, 6.9],
                [18, 9.4],
                [19, 10.4]
              ]
            },
            "line-offset": 0,
            "line-opacity": {
              "stops": [
                [12, 0.3],
                [14, 1]
              ]
            },
            "line-color": "rgba(255, 255, 255, 1)"
          },
          "id": "Highway-service",
          "source": "all_data",
          "source-layer": "highway_service",
          "type": "line",
          "minzoom": 13
        },
        {
          "filter": [
            "all",
            [
              "in",
              "class",
              "unclassified",
              "residential",
              "road",
              "living_street"
            ]
          ],
          "layout": {
            "visibility": "visible",
            "line-cap": "round",
            "line-join": "bevel"
          },
          "maxzoom": 24,
          "paint": {
            "line-translate-anchor": "map",
            "line-width": {
              "stops": [
                [12, 1],
                [13, 1.9],
                [14, 3.8],
                [15, 4.8],
                [16, 10.4],
                [17, 11.4],
                [18, 15.4]
              ]
            },
            "line-offset": 0,
            "line-opacity": {
              "stops": [
                [12, 0],
                [14, 1]
              ]
            },
            "line-color": "rgba(255, 255, 255, 1)"
          },
          "id": "Highway-minor",
          "source": "all_data",
          "source-layer": "highway_minor",
          "type": "line",
          "minzoom": 12
        },
        {
          "layout": {
            "visibility": "visible",
            "line-cap": "round",
            "line-join": "bevel"
          },
          "maxzoom": 24,
          "paint": {
            "line-translate-anchor": "map",
            "line-width": {
              "stops": [
                [8, 1],
                [9, 1.1],
                [10, 1.1],
                [11, 2.9],
                [12, 4.3],
                [13, 4.3],
                [14, 7.8],
                [15, 8.8],
                [16, 16],
                [17, 19],
                [18, 25],
                [19, 40]
              ]
            },
            "line-offset": 0,
            "line-opacity": {
              "stops": [
                [10, 0],
                [11, 1]
              ]
            },
            "line-color": {
              "stops": [
                [9, "rgba(255, 255, 255, 1)"],
                [18, "rgba(240, 240, 235, 1)"]
              ]
            }
          },
          "id": "Highway-tertiary_link",
          "source": "all_data",
          "source-layer": "highway_tertiary_link",
          "type": "line",
          "minzoom": 8
        },
        {
          "layout": {
            "visibility": "visible",
            "line-cap": "round",
            "line-join": "bevel"
          },
          "maxzoom": 24,
          "paint": {
            "line-translate-anchor": "map",
            "line-width": {
              "stops": [
                [8, 1],
                [9, 1.1],
                [10, 1.1],
                [11, 2.9],
                [12, 4.3],
                [13, 4.3],
                [14, 7.8],
                [15, 8.8],
                [16, 16],
                [17, 19],
                [18, 25],
                [19, 40]
              ]
            },
            "line-offset": 0,
            "line-opacity": {
              "stops": [
                [10, 0],
                [11, 1]
              ]
            },
            "line-color": {
              "stops": [
                [9, "rgba(255, 255, 255, 1)"],
                [18, "rgba(240, 240, 235, 1)"]
              ]
            }
          },
          "id": "Highway-tertiary",
          "source": "all_data",
          "source-layer": "highway_tertiary",
          "type": "line",
          "minzoom": 8
        },
        {
          "layout": {
            "visibility": "visible",
            "line-cap": "round",
            "line-join": "bevel"
          },
          "maxzoom": 24,
          "paint": {
            "line-translate-anchor": "map",
            "line-width": {
              "stops": [
                [8, 1],
                [9, 1.1],
                [10, 1.1],
                [11, 2.9],
                [12, 4.3],
                [13, 4.3],
                [14, 7.8],
                [15, 8.8],
                [16, 16],
                [17, 19],
                [18, 25],
                [19, 40]
              ]
            },
            "line-offset": 0,
            "line-opacity": {
              "stops": [
                [10, 0],
                [11, 1]
              ]
            },
            "line-color": {
              "stops": [
                [9, "rgba(255, 255, 255, 1)"],
                [18, "rgba(240, 240, 235, 1)"]
              ]
            }
          },
          "id": "Highway-secondary_link",
          "source": "all_data",
          "source-layer": "highway_secondary_link",
          "type": "line",
          "minzoom": 9
        },
        {
          "layout": {
            "visibility": "visible",
            "line-cap": "round",
            "line-join": "bevel"
          },
          "maxzoom": 24,
          "paint": {
            "line-translate-anchor": "map",
            "line-width": {
              "stops": [
                [8, 1],
                [9, 1.1],
                [10, 1.1],
                [11, 2.9],
                [12, 4.3],
                [13, 4.3],
                [14, 7.8],
                [15, 8.8],
                [16, 16],
                [17, 19],
                [18, 25],
                [19, 40]
              ]
            },
            "line-offset": 0,
            "line-opacity": {
              "stops": [
                [10, 0],
                [11, 1]
              ]
            },
            "line-color": {
              "stops": [
                [9, "rgba(255, 255, 255, 1)"],
                [18, "rgba(240, 240, 235, 1)"]
              ]
            }
          },
          "id": "Highway-secondary",
          "source": "all_data",
          "source-layer": "highway_secondary",
          "type": "line",
          "minzoom": 9
        },
        {
          "layout": {
            "visibility": "visible",
            "line-cap": "round",
            "line-join": "bevel"
          },
          "maxzoom": 24,
          "paint": {
            "line-translate-anchor": "map",
            "line-width": {
              "stops": [
                [7, 1.4],
                [8, 1.4],
                [9, 1.8],
                [10, 1.8],
                [11, 2.5],
                [12, 4],
                [13, 8.6],
                [15, 16],
                [16, 19],
                [17, 25],
                [18, 30],
                [19, 50]
              ]
            },
            "line-offset": 0,
            "line-color": {
              "stops": [
                [6, "rgba(242, 242, 236, 1)"],
                [14, "rgba(251,208,80,1)"],
                [15, "rgba(252,227,147,255)"]
              ]
            }
          },
          "id": "Highway-primary_link",
          "source": "all_data",
          "source-layer": "highway_primary_link",
          "type": "line",
          "minzoom": 7
        },
        {
          "layout": {
            "visibility": "visible",
            "line-cap": "round",
            "line-join": "bevel"
          },
          "maxzoom": 24,
          "paint": {
            "line-translate-anchor": "map",
            "line-width": {
              "stops": [
                [7, 1.4],
                [8, 1.4],
                [9, 1.8],
                [10, 1.8],
                [11, 2.5],
                [12, 4],
                [13, 8.6],
                [15, 16],
                [16, 19],
                [17, 25],
                [18, 30],
                [19, 50]
              ]
            },
            "line-offset": 0,
            "line-color": {
              "stops": [
                [6, "rgba(242, 242, 236, 1)"],
                [10, "rgba(251,208,80,1)"],
                [15, "rgba(252,227,147,255)"]
              ]
            }
          },
          "id": "Highway-primary",
          "source": "all_data",
          "source-layer": "highway_primary",
          "type": "line",
          "minzoom": 7
        },
        {
          "layout": {
            "visibility": "visible",
            "line-cap": "round",
            "line-join": "bevel"
          },
          "maxzoom": 24,
          "paint": {
            "line-translate-anchor": "map",
            "line-width": {
              "stops": [
                [7, 1.4],
                [8, 1.4],
                [9, 1.8],
                [10, 1.8],
                [11, 2.5],
                [12, 4],
                [13, 8.6],
                [15, 16],
                [16, 19],
                [17, 25],
                [18, 30],
                [19, 50]
              ]
            },
            "line-offset": 0,
            "line-color": {
              "stops": [
                [6, "rgba(255,210,75,1)"],
                [18, "rgba(252,227,147,255)"]
              ]
            }
          },
          "id": "Highway-trunk_link",
          "source": "all_data",
          "source-layer": "highway_trunk_link",
          "type": "line",
          "minzoom": 7
        },
        {
          "layout": {
            "visibility": "visible",
            "line-cap": "round",
            "line-join": "bevel"
          },
          "maxzoom": 24,
          "paint": {
            "line-translate-anchor": "map",
            "line-width": {
              "stops": [
                [7, 1.4],
                [8, 1.4],
                [9, 1.8],
                [10, 1.8],
                [11, 2.5],
                [12, 4],
                [13, 8.6],
                [15, 16],
                [16, 19],
                [17, 25],
                [18, 30],
                [19, 50]
              ]
            },
            "line-offset": 0,
            "line-color": {
              "stops": [
                [6, "rgba(255,210,75,1)"],
                [18, "rgba(252,227,147,255)"]
              ]
            }
          },
          "id": "Highway-trunk",
          "source": "all_data",
          "source-layer": "highway_trunk",
          "type": "line",
          "minzoom": 7
        },
        {
          "filter": [
            "all",
            ["==", "class", "pier"]
          ],
          "layout": {
            "visibility": "visible",
            "line-cap": "round",
            "line-join": "bevel"
          },
          "metadata": {},
          "paint": {
            "line-width": {
              "stops": [
                [15, 1],
                [17, 4]
              ],
              "base": 1.2
            },
            "line-color": "hsl(47, 26%, 88%)"
          },
          "id": "Highway_pier",
          "source": "all_data",
          "source-layer": "pier",
          "type": "line"
        },
        {
          "filter": [
            "all",
            ["==", "brunnel", "bridge"]
          ],
          "layout": {
            "visibility": "visible",
            "line-cap": "butt",
            "line-join": "bevel"
          },
          "maxzoom": 24,
          "paint": {
            "line-translate-anchor": "map",
            "line-width": {
              "stops": [
                [12, 2],
                [14, 3],
                [17, 4],
                [18, 5]
              ]
            },
            "line-offset": 0,
            "line-opacity": {
              "stops": [
                [12, 0],
                [14, 1]
              ]
            },
            "line-color": "rgba(101, 103, 110, 0.7)"
          },
          "id": "Highway-casing-bridge-path",
          "source": "all_data",
          "source-layer": "highway_path",
          "type": "line",
          "minzoom": 12
        },
        {
          "filter": [
            "all",
            ["==", "brunnel", "bridge"]
          ],
          "layout": {
            "visibility": "visible",
            "line-cap": "butt",
            "line-join": "bevel"
          },
          "maxzoom": 24,
          "paint": {
            "line-translate-anchor": "map",
            "line-width": {
              "stops": [
                [12, 1],
                [14, 2],
                [17, 3],
                [18, 4]
              ]
            },
            "line-offset": 0,
            "line-dasharray": {
              "stops": [
                [
                  16,
                  [3, 1]
                ],
                [
                  17,
                  [5, 3]
                ]
              ]
            },
            "line-color": "rgba(255, 255, 255, 1)"
          },
          "id": "Highway-bridge-path",
          "source": "all_data",
          "source-layer": "highway_path",
          "type": "line",
          "minzoom": 12.5
        },
        {
          "layout": {
            "visibility": "visible",
            "line-cap": "round",
            "line-join": "bevel"
          },
          "maxzoom": 24,
          "paint": {
            "line-translate-anchor": "map",
            "line-width": {
              "stops": [
                [13, 0.9],
                [15, 2.3],
                [15, 0.5],
                [16, 5.4],
                [17, 6.9],
                [18, 9.4],
                [19, 10.4]
              ]
            },
            "line-gap-width": 20,
            "line-offset": 0,
            "line-opacity": {
              "stops": [
                [12, 0.3],
                [14, 1]
              ]
            },
            "line-color": "rgba(190, 199, 185, 1)"
          },
          "id": "Highway-cablecar-copy",
          "source": "all_data",
          "source-layer": "aerialway_cablecar",
          "type": "line",
          "minzoom": 12
        },
        {
          "layout": {
            "visibility": "visible",
            "line-cap": "round",
            "line-join": "bevel"
          },
          "maxzoom": 24,
          "paint": {
            "line-translate-anchor": "map",
            "line-width": {
              "stops": [
                [13, 0.9],
                [15, 2.3],
                [15, 0.5],
                [16, 5.4],
                [17, 6.9],
                [18, 9.4],
                [19, 10.4]
              ]
            },
            "line-offset": 0,
            "line-opacity": {
              "stops": [
                [12, 0.3],
                [14, 1]
              ]
            },
            "line-color": "rgba(190, 199, 185, 1)"
          },
          "id": "Highway-cablecar",
          "source": "all_data",
          "source-layer": "aerialway_cablecar",
          "type": "line",
          "minzoom": 13
        },
        {
          "filter": [
            "all",
            ["==", "class", "miniature"]
          ],
          "layout": {"visibility": "visible"},
          "paint": {
            "line-width": {
              "stops": [
                [13, 0.9],
                [15, 2.3],
                [16, 5.4],
                [17, 6.9],
                [18, 9.4],
                [19, 10.4]
              ]
            },
            "line-color": "rgba(255, 255, 255, 1)"
          },
          "id": "Railway-mini",
          "source": "all_data",
          "source-layer": "highway_railway",
          "type": "line",
          "minzoom": 15
        },
        {
          "filter": [
            "all",
            ["==", "class", "miniature"]
          ],
          "layout": {"visibility": "visible"},
          "paint": {
            "line-width": {
              "stops": [
                [13, 0.9],
                [15, 2.3],
                [16, 5.4],
                [17, 6.9],
                [18, 9.4],
                [19, 10.4]
              ]
            },
            "line-dasharray": {
              "stops": [
                [
                  12,
                  [1, 3]
                ],
                [
                  16,
                  [1, 2]
                ]
              ]
            },
            "line-color": "rgba(203, 201, 196, 1)"
          },
          "id": "Railway-mini-dash-array",
          "source": "all_data",
          "source-layer": "highway_railway",
          "type": "line",
          "minzoom": 15
        },
        {
          "filter": [
            "all",
            ["!=", "class", "miniature"]
          ],
          "layout": {"visibility": "visible"},
          "paint": {
            "line-width": {
              "stops": [
                [13, 2],
                [15, 3.5],
                [16, 7],
                [17, 8.5],
                [18, 11],
                [19, 12]
              ]
            },
            "line-color": "rgba(97, 105, 97, 1)"
          },
          "id": "Railway-casing",
          "source": "all_data",
          "source-layer": "highway_railway",
          "type": "line",
          "minzoom": 7
        },
        {
          "filter": [
            "all",
            ["!=", "class", "miniature"]
          ],
          "layout": {"visibility": "visible"},
          "paint": {
            "line-width": {
              "stops": [
                [13, 0.9],
                [15, 2.3],
                [16, 5.4],
                [17, 6.9],
                [18, 9.4],
                [19, 10.4]
              ]
            },
            "line-color": "rgba(255, 255, 255, 1)"
          },
          "id": "Railway",
          "source": "all_data",
          "source-layer": "highway_railway",
          "type": "line",
          "minzoom": 7
        },
        {
          "filter": [
            "all",
            ["!=", "class", "miniature"]
          ],
          "layout": {"visibility": "visible"},
          "paint": {
            "line-width": {
              "stops": [
                [13, 0.9],
                [15, 2.3],
                [16, 5.4],
                [17, 6.9],
                [18, 9.4],
                [19, 10.4]
              ]
            },
            "line-dasharray": {
              "stops": [
                [
                  12,
                  [1, 3]
                ],
                [
                  16,
                  [1, 2]
                ]
              ]
            },
            "line-color": "rgba(113, 121, 114, 1)"
          },
          "id": "Railway-dash-array",
          "source": "all_data",
          "source-layer": "highway_railway",
          "type": "line",
          "minzoom": 10
        },
        {
          "filter": [
            "any",
            [
              "in",
              "class",
              "airport",
              "bus",
              "car",
              "charging_station",
              "fuel",
              "parking"
            ],
            [
              "in",
              "class",
              "park",
              "dog_park",
              "playground",
              "garden",
              "garden_centre",
              "zoo"
            ],
            ["in", "class", "police", "millitary"],
            [
              "in",
              "class",
              "hospital",
              "pharmacy",
              "clinic",
              "chemist",
              "doctors",
              "dentist",
              "veterinary"
            ],
            ["in", "class", "school", "college"],
            ["in", "class", "religion"]
          ],
          "layout": {
            "text-optional": false,
            "visibility": "visible",
            "text-field": [
              "case",
              ["has", "name:en"],
              ["get", "name:en"],
              ["get", "name:latin"]
            ],
            "text-size": 13,
            "text-anchor": "top",
            "text-allow-overlap": false,
            "icon-size": 0.8,
            "icon-image": [
              "coalesce",
              [
                "image",
                ["get", "class"]
              ],
              ["image", "others"]
            ],
            "text-font": ["OpenSans"],
            "icon-optional": false,
            "icon-padding": 20,
            "symbol-spacing": 1500,
            "text-max-width": 8,
            "text-offset": [0, 1]
          },
          "maxzoom": 24,
          "paint": {
            "text-halo-color": "rgba(255, 255, 255, 1)",
            "text-color": "rgba(98, 106, 112, 1)",
            "text-halo-width": 1
          },
          "id": "Poi-merging-main",
          "source": "all_data",
          "source-layer": "poi",
          "type": "symbol",
          "minzoom": 16
        },
        {
          "filter": [
            "any",
            [
              "in",
              "class",
              "airport",
              "bus",
              "car",
              "charging_station",
              "fuel",
              "parking"
            ],
            [
              "in",
              "class",
              "park",
              "dog_park",
              "playground",
              "garden",
              "garden_centre",
              "zoo"
            ],
            ["in", "class", "police", "millitary"],
            [
              "in",
              "class",
              "hospital",
              "pharmacy",
              "clinic",
              "chemist",
              "doctors",
              "dentist",
              "veterinary"
            ],
            ["in", "class", "school", "college"],
            ["in", "class", "religion"]
          ],
          "layout": {
            "text-optional": false,
            "visibility": "visible",
            "text-field": "{name}",
            "text-size": 13,
            "text-anchor": "top",
            "text-allow-overlap": false,
            "icon-size": 0.8,
            "icon-image": [
              "coalesce",
              [
                "image",
                ["get", "class"]
              ],
              ["image", "others"]
            ],
            "text-font": ["OpenSans"],
            "icon-optional": false,
            "icon-padding": 20,
            "text-max-width": 8,
            "text-offset": [0, 1]
          },
          "maxzoom": 24,
          "paint": {
            "text-halo-color": "rgba(255, 255, 255, 1)",
            "text-color": "rgba(98, 106, 112, 1)",
            "text-halo-width": 1
          },
          "id": "Poi-merging-plucker-copy-copy",
          "source": "baato_inhouse",
          "source-layer": "pois",
          "type": "symbol",
          "minzoom": 16
        },
        {
          "filter": [
            "all",
            ["has", "ele"]
          ],
          "layout": {
            "visibility": "visible",
            "text-field": "{name:latin}{name:nonlatin} {ele} m",
            "text-offset": [0, 0.8],
            "text-anchor": "top",
            "text-size": 13,
            "icon-size": 0.8,
            "symbol-placement": "point",
            "icon-image": "{class}",
            "text-font": ["OpenSans"],
            "icon-padding": 20
          },
          "paint": {
            "text-halo-color": "hsl(0, 100%, 100%)",
            "text-color": "hsl(23, 57%, 24%)",
            "text-halo-width": 1.5
          },
          "id": "Poi-mountain_peak",
          "source": "all_data",
          "source-layer": "mountain_peak",
          "type": "symbol",
          "minzoom": 12
        },
        {
          "layout": {
            "visibility": "visible",
            "text-field": "{name:latin}{name:nonlatin}",
            "text-offset": [0, 0.8],
            "text-anchor": "top",
            "text-size": 13,
            "icon-size": 0.8,
            "symbol-placement": "point",
            "icon-image": "{class}",
            "text-font": ["OpenSans"],
            "icon-padding": 20
          },
          "paint": {
            "text-halo-color": "hsl(0, 100%, 100%)",
            "text-color": "hsl(23, 57%, 24%)",
            "text-halo-width": 1.5
          },
          "id": "Poi-mountain_peak-other",
          "source": "all_data",
          "source-layer": "mountain_peak",
          "type": "symbol",
          "minzoom": 12
        },
        {
          "filter": [
            "all",
            ["==", "class", "helipad"]
          ],
          "layout": {
            "icon-allow-overlap": false,
            "text-optional": false,
            "visibility": "visible",
            "text-field": "Helipad",
            "text-anchor": "top",
            "text-size": 13,
            "text-allow-overlap": false,
            "icon-size": 0.8,
            "icon-ignore-placement": false,
            "icon-image": [
              "coalesce",
              [
                "image",
                ["get", "class"]
              ],
              ["image", "others"]
            ],
            "text-font": ["OpenSans"],
            "icon-optional": false,
            "icon-padding": 20,
            "text-max-width": 8,
            "text-offset": [0, 1],
            "text-ignore-placement": false
          },
          "paint": {
            "text-halo-color": "rgba(255, 255, 255, 1)",
            "text-color": "rgba(91, 106, 93, 1)",
            "text-halo-width": 1
          },
          "id": "Poi-helipad",
          "source": "all_data",
          "source-layer": "aeroway",
          "type": "symbol",
          "minzoom": 16
        },
        {
          "filter": ["all"],
          "layout": {
            "symbol-spacing": 250,
            "visibility": "visible",
            "text-letter-spacing": 0.25,
            "text-field": [
              "case",
              ["has", "name:en"],
              ["get", "name:en"],
              ["get", "name:latin"]
            ],
            "text-size": {
              "stops": [
                [12, 5],
                [13, 8],
                [14, 12]
              ]
            },
            "symbol-placement": "line",
            "text-font": ["OpenSans"]
          },
          "maxzoom": 24,
          "paint": {
            "text-halo-color": "rgba(255, 255, 255, 1)",
            "text-color": "rgba(3, 98, 142, 1)",
            "text-halo-width": 1
          },
          "id": "Waterwaylabel-river",
          "source": "all_data",
          "source-layer": "waterway",
          "type": "symbol",
          "minzoom": 12
        },
        {
          "filter": [
            "any",
            ["==", "class", "lake"]
          ],
          "layout": {
            "symbol-avoid-edges": false,
            "text-line-height": 1,
            "visibility": "visible",
            "text-max-width": 5,
            "text-field": [
              "case",
              ["has", "name:en"],
              ["get", "name:en"],
              ["get", "name:latin"]
            ],
            "text-size": {
              "stops": [
                [14, 8],
                [15, 12]
              ]
            },
            "symbol-placement": "point",
            "text-font": ["OpenSans"]
          },
          "paint": {
            "text-halo-color": "rgba(255, 255, 255, 1)",
            "text-color": "rgba(3, 98, 142, 1)"
          },
          "id": "Waterwaylabel-lake",
          "source": "all_data",
          "source-layer": "water_name",
          "type": "symbol",
          "minzoom": 14
        },
        {
          "filter": [
            "all",
            ["!in", "name", "Rani Ban", "Gokarna Reserve Forest"]
          ],
          "layout": {
            "icon-pitch-alignment": "map",
            "text-line-height": 1,
            "text-max-width": 6,
            "visibility": "visible",
            "text-field": "{name:en}",
            "text-size": {
              "stops": [
                [3, 3],
                [8, 12]
              ]
            },
            "text-anchor": "top",
            "text-font": ["OpenSans"]
          },
          "maxzoom": 24,
          "paint": {
            "text-halo-color": "rgba(40, 119, 104, 0.63)",
            "text-color": "rgba(25, 98, 83, 0.63)",
            "text-halo-width": 0.1
          },
          "id": "NationalPark-symbol",
          "source": "boundary_tiles",
          "source-layer": "baato_label_national_park",
          "type": "symbol",
          "minzoom": 5
        },
        {
          "filter": [
            "all",
            ["==", "\$type", "Point"],
            [
              "!in",
              "class",
              "suburb",
              "city",
              "neighbourhood",
              "town",
              "village"
            ]
          ],
          "layout": {
            "text-optional": false,
            "icon-allow-overlap": false,
            "visibility": "visible",
            "text-max-width": 7,
            "text-field": [
              "case",
              ["has", "name:en"],
              ["get", "name:en"],
              ["get", "name:latin"]
            ],
            "text-anchor": "top",
            "text-size": {
              "stops": [
                [10, 10],
                [15, 14]
              ]
            },
            "text-padding": {
              "stops": [
                [13, 25],
                [14, 10]
              ]
            },
            "icon-ignore-placement": false,
            "text-font": ["OpenSans"]
          },
          "maxzoom": 24,
          "paint": {
            "text-halo-color": "rgba(255, 255, 255, 1)",
            "text-color": {
              "stops": [
                [10, "rgba(107, 107, 107, 1)"],
                [16, "rgba(68, 68, 68, 1)"]
              ]
            },
            "text-halo-width": 0.5,
            "text-opacity": {
              "stops": [
                [10, 1],
                [15, 0.8]
              ]
            }
          },
          "id": "Place-other",
          "source": "all_data",
          "source-layer": "place",
          "type": "symbol",
          "minzoom": 7
        },
        {
          "filter": [
            "all",
            ["==", "\$type", "Point"],
            ["==", "class", "neighbourhood"]
          ],
          "layout": {
            "icon-allow-overlap": false,
            "text-line-height": 1,
            "visibility": "visible",
            "text-field": [
              "case",
              ["has", "name:en"],
              ["get", "name:en"],
              ["get", "name:latin"]
            ],
            "text-size": {
              "stops": [
                [10, 10],
                [14.5, 15],
                [17, 18]
              ]
            },
            "text-anchor": "top",
            "text-allow-overlap": false,
            "icon-text-fit": "none",
            "icon-ignore-placement": false,
            "text-font": ["OpenSans"],
            "text-transform": "none",
            "text-max-width": 6,
            "text-offset": [0, 0],
            "text-ignore-placement": false,
            "text-padding": {
              "stops": [
                [13, 25],
                [14, 10]
              ]
            }
          },
          "maxzoom": 24,
          "paint": {
            "icon-halo-width": 4,
            "text-halo-color": "rgba(255, 255, 255, 1)",
            "icon-halo-color": "rgba(101, 100, 100, 1)",
            "text-color": {
              "stops": [
                [14, "rgba(107, 107, 107, 1)"],
                [18, "rgba(68, 68, 68, 1)"]
              ]
            },
            "text-halo-width": 0.5,
            "text-opacity": {
              "stops": [
                [10, 1],
                [15, 0.8]
              ]
            }
          },
          "id": "Place-neighbourhood",
          "source": "all_data",
          "source-layer": "place",
          "type": "symbol",
          "minzoom": 7
        },
        {
          "filter": [
            "all",
            ["==", "\$type", "Point"],
            ["==", "class", "suburb"]
          ],
          "layout": {
            "icon-allow-overlap": false,
            "text-line-height": 1,
            "visibility": "visible",
            "text-field": [
              "case",
              ["has", "name:en"],
              ["get", "name:en"],
              ["get", "name:latin"]
            ],
            "text-size": {
              "stops": [
                [10, 8],
                [11, 13],
                [15, 15],
                [19, 18]
              ]
            },
            "text-anchor": "top",
            "text-allow-overlap": false,
            "icon-size": 0.5,
            "text-font": ["OpenSans"],
            "symbol-avoid-edges": false,
            "text-transform": "none",
            "text-max-width": 6,
            "text-letter-spacing": {
              "stops": [
                [10, 0],
                [13, 0.07]
              ]
            },
            "text-keep-upright": true,
            "text-ignore-placement": false,
            "text-padding": {
              "stops": [
                [13, 25],
                [14, 10]
              ]
            }
          },
          "maxzoom": 24,
          "paint": {
            "text-halo-color": "rgba(255, 255, 255, 1)",
            "text-color": "rgba(44, 46, 33, 1)",
            "text-halo-width": 0.1,
            "text-opacity": {
              "stops": [
                [6, 0.3],
                [10, 1]
              ]
            }
          },
          "id": "Place-suburb",
          "source": "all_data",
          "source-layer": "place",
          "type": "symbol",
          "minzoom": 7
        },
        {
          "filter": [
            "all",
            ["==", "\$type", "Point"],
            ["in", "class", "village"]
          ],
          "layout": {
            "symbol-avoid-edges": false,
            "text-transform": "none",
            "text-optional": false,
            "visibility": "visible",
            "text-max-width": 6,
            "text-letter-spacing": 0.07,
            "text-field": [
              "case",
              ["has", "name:en"],
              ["get", "name:en"],
              ["get", "name:latin"]
            ],
            "text-size": {
              "stops": [
                [10, 9],
                [13, 14]
              ]
            },
            "text-anchor": "top",
            "text-allow-overlap": false,
            "text-padding": {
              "stops": [
                [13, 10],
                [14, 5]
              ]
            },
            "text-font": ["OpenSans"]
          },
          "maxzoom": 24,
          "paint": {
            "text-halo-color": {
              "stops": [
                [6, "rgba(252, 251, 251, 1)"],
                [13, "rgba(77, 74, 74, 1)"]
              ]
            },
            "text-color": {
              "stops": [
                [8, "rgba(102, 100, 100, 1)"],
                [14, "rgba(59, 59, 52, 1)"]
              ]
            },
            "text-halo-width": 0.1,
            "text-opacity": 1
          },
          "id": "Place-village",
          "source": "all_data",
          "source-layer": "place",
          "type": "symbol",
          "minzoom": 7
        },
        {
          "filter": [
            "all",
            ["==", "\$type", "Point"],
            ["in", "class", "town"]
          ],
          "layout": {
            "symbol-avoid-edges": false,
            "text-transform": "none",
            "text-optional": false,
            "visibility": "visible",
            "text-max-width": 6,
            "text-letter-spacing": 0.07,
            "text-field": [
              "case",
              ["has", "name:en"],
              ["get", "name:en"],
              ["get", "name:latin"]
            ],
            "text-size": {
              "stops": [
                [10, 10],
                [13, 15]
              ]
            },
            "text-anchor": "top",
            "text-padding": {
              "stops": [
                [13, 10],
                [14, 5]
              ]
            },
            "text-font": ["OpenSans"]
          },
          "maxzoom": 24,
          "paint": {
            "text-halo-color": {
              "stops": [
                [1, "rgba(252, 251, 251, 1)"],
                [12, "rgba(77, 74, 74, 1)"]
              ]
            },
            "text-color": {
              "stops": [
                [8, "rgba(102, 100, 100, 1)"],
                [14, "rgba(59, 59, 52, 1)"]
              ]
            },
            "text-halo-width": 0.1
          },
          "id": "Place-town",
          "source": "all_data",
          "source-layer": "place",
          "type": "symbol",
          "minzoom": 7
        },
        {
          "filter": [
            "all",
            ["==", "\$type", "Point"],
            ["==", "class", "city"]
          ],
          "layout": {
            "symbol-avoid-edges": false,
            "text-transform": {
              "stops": [
                [6, "uppercase"],
                [11, "uppercase"]
              ]
            },
            "text-optional": false,
            "visibility": "visible",
            "text-max-width": 6,
            "text-letter-spacing": 0.07,
            "text-field": [
              "case",
              ["has", "name:en"],
              ["get", "name:en"],
              ["get", "name:latin"]
            ],
            "text-size": {
              "stops": [
                [10, 11],
                [13, 17]
              ]
            },
            "text-anchor": "top",
            "text-padding": {
              "stops": [
                [13, 10],
                [14, 5]
              ]
            },
            "text-font": ["OpenSans"]
          },
          "maxzoom": 14,
          "paint": {
            "text-halo-color": "rgba(107, 107, 107, 1)",
            "text-color": "rgba(59, 59, 52, 1)",
            "text-halo-width": 0.1
          },
          "id": "Place-city",
          "source": "all_data",
          "source-layer": "place",
          "type": "symbol",
          "minzoom": 7
        },
        {
          "filter": ["==", "oneway", 1],
          "layout": {
            "symbol-avoid-edges": false,
            "icon-allow-overlap": false,
            "visibility": "visible",
            "symbol-z-order": "source",
            "symbol-placement": "line",
            "icon-image": "oneway",
            "icon-ignore-placement": false,
            "text-font": []
          },
          "id": "HighwayLabel_one_way_arrow",
          "source": "all_data",
          "source-layer": "highway_oneway",
          "type": "symbol",
          "minzoom": 15
        },
        {
          "filter": ["all"],
          "layout": {
            "visibility": "visible",
            "text-field": [
              "case",
              ["has", "name:en"],
              ["get", "name:en"],
              ["get", "name:latin"]
            ],
            "text-size": {
              "stops": [
                [10, 8],
                [20, 15]
              ]
            },
            "text-allow-overlap": false,
            "symbol-placement": "line",
            "text-font": ["OpenSans"],
            "symbol-avoid-edges": false,
            "symbol-spacing": 500,
            "text-pitch-alignment": "viewport",
            "text-ignore-placement": false,
            "symbol-z-order": "source",
            "text-padding": 2,
            "text-max-angle": 30
          },
          "paint": {
            "text-halo-color": "rgba(255, 255, 255, 1)",
            "text-halo-blur": 1,
            "text-color": "rgba(49, 48, 48, 1)",
            "text-halo-width": 1,
            "text-opacity": 0.7
          },
          "id": "HighwayLabel-path",
          "source": "all_data",
          "source-layer": "highway_path",
          "type": "symbol",
          "minzoom": 13
        },
        {
          "filter": ["all"],
          "layout": {
            "visibility": "visible",
            "text-field": [
              "case",
              ["has", "name:en"],
              ["get", "name:en"],
              ["get", "name:latin"]
            ],
            "text-size": {
              "stops": [
                [10, 8],
                [20, 15]
              ]
            },
            "text-allow-overlap": false,
            "symbol-placement": "line",
            "text-font": ["OpenSans"],
            "symbol-avoid-edges": false,
            "symbol-spacing": 500,
            "text-pitch-alignment": "viewport",
            "text-ignore-placement": false,
            "symbol-z-order": "source",
            "text-padding": 2,
            "text-max-angle": 30
          },
          "paint": {
            "text-halo-color": "rgba(255, 255, 255, 1)",
            "text-halo-blur": 1,
            "text-color": "#808080",
            "text-halo-width": 1,
            "text-opacity": 0.7
          },
          "id": "HighwayLabel-track",
          "source": "all_data",
          "source-layer": "highway_track",
          "type": "symbol",
          "minzoom": 13
        },
        {
          "filter": ["all"],
          "layout": {
            "visibility": "visible",
            "text-field": [
              "case",
              ["has", "name:en"],
              ["get", "name:en"],
              ["get", "name:latin"]
            ],
            "text-size": {
              "stops": [
                [10, 8],
                [20, 15]
              ]
            },
            "text-allow-overlap": false,
            "symbol-placement": "line",
            "text-font": ["OpenSans"],
            "symbol-avoid-edges": false,
            "symbol-spacing": 500,
            "text-pitch-alignment": "viewport",
            "text-ignore-placement": false,
            "symbol-z-order": "source",
            "text-padding": 2,
            "text-max-angle": 30
          },
          "paint": {
            "text-halo-color": "rgba(255, 255, 255, 1)",
            "text-halo-blur": 1,
            "text-color": "#808080",
            "text-halo-width": 1,
            "text-opacity": 0.7
          },
          "id": "HighwayLabel-pedestrian",
          "source": "all_data",
          "source-layer": "highway_pedestrian",
          "type": "symbol",
          "minzoom": 13
        },
        {
          "filter": ["all"],
          "layout": {
            "visibility": "visible",
            "text-field": [
              "case",
              ["has", "name:en"],
              ["get", "name:en"],
              ["get", "name:latin"]
            ],
            "text-size": {
              "stops": [
                [10, 8],
                [20, 15]
              ]
            },
            "text-allow-overlap": false,
            "symbol-placement": "line",
            "text-font": ["OpenSans"],
            "symbol-avoid-edges": false,
            "symbol-spacing": 500,
            "text-pitch-alignment": "viewport",
            "text-ignore-placement": false,
            "symbol-z-order": "source",
            "text-padding": 2,
            "text-max-angle": 30
          },
          "paint": {
            "text-halo-color": "rgba(255, 255, 255, 1)",
            "text-halo-blur": 1,
            "text-color": "#808080",
            "text-halo-width": 1,
            "text-opacity": 0.7
          },
          "id": "HighwayLabel-service",
          "source": "all_data",
          "source-layer": "highway_service",
          "type": "symbol",
          "minzoom": 13
        },
        {
          "filter": ["all"],
          "layout": {
            "visibility": "visible",
            "text-field": [
              "case",
              ["has", "name:en"],
              ["get", "name:en"],
              ["get", "name:latin"]
            ],
            "text-size": {
              "stops": [
                [10, 8],
                [20, 15]
              ]
            },
            "text-allow-overlap": false,
            "symbol-placement": "line",
            "text-font": ["OpenSans"],
            "symbol-avoid-edges": false,
            "symbol-spacing": 500,
            "text-pitch-alignment": "viewport",
            "text-rotation-alignment": "map",
            "text-ignore-placement": false,
            "symbol-z-order": "source",
            "text-padding": 2,
            "text-max-angle": 30
          },
          "paint": {
            "text-halo-color": "rgba(255, 255, 255, 1)",
            "text-halo-blur": 1,
            "text-color": "rgba(72, 70, 70, 1)",
            "text-halo-width": 1,
            "text-opacity": 0.7
          },
          "id": "HighwayLabel-minor",
          "source": "all_data",
          "source-layer": "highway_minor",
          "type": "symbol",
          "minzoom": 13
        },
        {
          "filter": ["all"],
          "layout": {
            "visibility": "visible",
            "text-field": [
              "case",
              ["has", "name:en"],
              ["get", "name:en"],
              ["get", "name:latin"]
            ],
            "text-size": {
              "stops": [
                [10, 8],
                [20, 20]
              ]
            },
            "text-allow-overlap": false,
            "symbol-placement": "line",
            "text-font": ["OpenSans"],
            "symbol-avoid-edges": false,
            "symbol-spacing": 250,
            "text-pitch-alignment": "viewport",
            "text-ignore-placement": false,
            "symbol-z-order": "source",
            "text-padding": 2,
            "text-max-angle": 30
          },
          "paint": {
            "text-halo-color": "rgba(255, 255, 255, 1)",
            "text-halo-blur": 1,
            "text-color": "rgba(61, 60, 60, 1)",
            "text-halo-width": 1,
            "text-opacity": 0.7
          },
          "id": "HighwayLabel-tertiary",
          "source": "all_data",
          "source-layer": "highway_tertiary",
          "type": "symbol",
          "minzoom": 13
        },
        {
          "filter": ["all"],
          "layout": {
            "text-optional": false,
            "visibility": "visible",
            "text-field": [
              "case",
              ["has", "name:en"],
              ["get", "name:en"],
              ["get", "name:latin"]
            ],
            "text-size": {
              "stops": [
                [10, 8],
                [20, 20]
              ]
            },
            "text-allow-overlap": false,
            "symbol-placement": "line",
            "text-font": ["OpenSans"],
            "symbol-avoid-edges": false,
            "text-pitch-alignment": "viewport",
            "text-ignore-placement": false,
            "symbol-z-order": "source",
            "text-padding": 2,
            "text-max-angle": 30
          },
          "paint": {
            "text-halo-color": "rgba(255, 255, 255, 1)",
            "text-halo-blur": 1,
            "text-color": "rgba(61, 60, 60, 1)",
            "text-halo-width": 1,
            "text-opacity": 0.7
          },
          "id": "HighwayLabel-secondary",
          "source": "all_data",
          "source-layer": "highway_secondary",
          "type": "symbol",
          "minzoom": 13
        },
        {
          "filter": ["all"],
          "layout": {
            "visibility": "visible",
            "text-field": [
              "case",
              ["has", "name:en"],
              ["get", "name:en"],
              ["get", "name:latin"]
            ],
            "text-size": {
              "stops": [
                [10, 8],
                [20, 20]
              ]
            },
            "text-allow-overlap": false,
            "symbol-placement": "line",
            "text-font": ["OpenSans"],
            "symbol-avoid-edges": false,
            "text-pitch-alignment": "viewport",
            "text-justify": "center",
            "text-ignore-placement": false,
            "symbol-z-order": "source",
            "text-padding": 2,
            "text-max-angle": 30
          },
          "paint": {
            "text-halo-color": "rgba(255, 255, 255, 1)",
            "text-halo-blur": 1,
            "text-color": "rgba(61, 60, 60, 1)",
            "text-halo-width": 1,
            "text-opacity": 0.7
          },
          "id": "HighwayLabel-primary",
          "source": "all_data",
          "source-layer": "highway_primary",
          "type": "symbol",
          "minzoom": 13
        },
        {
          "filter": [
            "all",
            ["==", "class", "trunk"]
          ],
          "layout": {
            "visibility": "visible",
            "text-field": [
              "case",
              ["has", "name:en"],
              ["get", "name:en"],
              ["get", "name:latin"]
            ],
            "text-size": {
              "stops": [
                [10, 8],
                [20, 20]
              ]
            },
            "text-anchor": "center",
            "text-allow-overlap": false,
            "symbol-placement": "line",
            "text-font": ["OpenSans"],
            "symbol-avoid-edges": false,
            "text-pitch-alignment": "viewport",
            "text-justify": "center",
            "text-ignore-placement": false,
            "symbol-z-order": "source",
            "text-padding": 2,
            "text-max-angle": 30
          },
          "paint": {
            "text-halo-color": "rgba(217, 226, 217, 1)",
            "text-halo-blur": 1,
            "text-color": "rgba(61, 60, 60, 1)",
            "text-halo-width": 1,
            "text-opacity": 0.7
          },
          "id": "HighwayLabel-trunk",
          "source": "all_data",
          "source-layer": "highway_trunk",
          "type": "symbol",
          "minzoom": 13
        },
        {
          "filter": ["all"],
          "layout": {
            "text-optional": false,
            "icon-allow-overlap": false,
            "text-line-height": 1,
            "visibility": "visible",
            "text-field": {
              "stops": [
                [10, ""],
                [11.5, "{name}"]
              ]
            },
            "text-size": {
              "stops": [
                [13, 10],
                [14, 13]
              ]
            },
            "text-anchor": "top",
            "text-allow-overlap": true,
            "icon-size": {
              "stops": [
                [10, 0.5],
                [14, 0.8]
              ]
            },
            "icon-image": "airport",
            "text-font": ["OpenSans"],
            "icon-optional": false,
            "symbol-avoid-edges": true,
            "text-transform": "none",
            "text-max-width": 5,
            "text-offset": [0, 1],
            "text-padding": 0
          },
          "maxzoom": 24,
          "paint": {
            "text-halo-color": "rgba(255, 255, 255, 1)",
            "text-color": "rgba(18, 85, 143, 1)",
            "text-halo-width": 1
          },
          "id": "Poi-Airport_symbol",
          "source": "airport_label",
          "type": "symbol",
          "minzoom": 10
        },
        {
          "layout": {
            "visibility": "visible",
            "line-join": "bevel",
            "line-cap": "butt"
          },
          "maxzoom": 24,
          "paint": {
            "line-width": {
              "stops": [
                [6, 1.5],
                [7, 2]
              ]
            },
            "line-opacity": {
              "stops": [
                [4.5, 0.05],
                [4.9, 0.5],
                [7, 0.15]
              ]
            },
            "line-dasharray": [1, 2, 1],
            "line-color": "rgba(24, 22, 22, 1)"
          },
          "id": "Boundary-Province",
          "source": "boundary_tiles",
          "source-layer": "baato_boundary_province",
          "type": "line",
          "minzoom": 4.5
        },
        {
          "layout": {
            "visibility": "visible",
            "line-join": "bevel",
            "line-cap": "butt"
          },
          "paint": {
            "line-width": {
              "stops": [
                [3, 1],
                [5, 2],
                [6, 2]
              ]
            },
            "line-opacity": 1,
            "line-color": "rgba(57, 55, 55, 1)"
          },
          "id": "Boundary-Country",
          "source": "boundary_tiles",
          "source-layer": "baato_boundary_country",
          "type": "line"
        }
      ],
      "glyphs":
          "file://$cacheDirPath/packages/baato_maps/lib/assets/map_res/glyphs/{fontstack}/{range}.pbf.gz",
      "id": "basic",
      "version": 8
    }''';
    //"glyphs":
    //  "file://$cacheDirPath/packages/baato_maps/lib/assets/map_res/glyphs/{fontstack}/{range}.pbf.gz",
    //https://baatocdn.sgp1.cdn.digitaloceanspaces.com/fonts_lite/{fontstack}/{range}.pbf.gz
    return styleJson;
  }
}
