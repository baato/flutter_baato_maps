// HTML content with MapLibre GL JS
import 'package:baato_maps/baato_maps.dart';

String mapJS({
  required String styleUrl,
  required BaatoCoordinate center,
  double zoom = 13,
}) {
  return '''
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8" />
      <title>MapLibre GL JS Map</title>
      <meta name="viewport" content="initial-scale=1,maximum-scale=1,user-scalable=no" />
      <script src="https://unpkg.com/maplibre-gl@3.6.2/dist/maplibre-gl.js"></script>
      <link href="https://unpkg.com/maplibre-gl@3.6.2/dist/maplibre-gl.css" rel="stylesheet" />
      <style>
        body { margin: 0; padding: 0; }
        #map { position: absolute; top: 0; bottom: 0; width: 100%; }
      </style>
    </head>
    <body>
      <div id="map"></div>
      <script>
        var map = new maplibregl.Map({
          container: 'map',
          style: '$styleUrl', // Default MapLibre style
          center: [${center.longitude}, ${center.latitude}], // Initial center [lng, lat]
          zoom: $zoom // Initial zoom
        });

        // Send a message to Flutter when the map is loaded
        map.on('load', function () {
          Flutter.postMessage('Map Loaded Successfully');
        });

        // Function to change the map style (can be called from Flutter)
        function setMapStyle(styleUrl) {
          map.setStyle(styleUrl);
          map.on('style.load', function () {
            Flutter.postMessage('Style Changed to: ' + styleUrl);
          });
        }

        // Track map click events
        map.on('click', function(e) {
          Flutter.postMessage(JSON.stringify({
            type: 'click',
            lat: e.lngLat.lat,
            lng: e.lngLat.lng
          }));
        });
        
        // Track map long press events (simulated with mousedown/mouseup)
        var pressTimer;
        var isLongPress = false;
        
        map.on('mousedown', function(e) {
          isLongPress = false;
          pressTimer = setTimeout(function() {
            isLongPress = true;
            Flutter.postMessage(JSON.stringify({
              type: 'longPress',
              lat: e.lngLat.lat,
              lng: e.lngLat.lng
            }));
          }, 500); // 500ms for long press
        });
        
        map.on('mouseup', function() {
          clearTimeout(pressTimer);
        });
        
        map.on('dragstart', function() {
          clearTimeout(pressTimer);
        });
        
        // Track map movement end and get bounds
        map.on('moveend', function() {
          var bounds = map.getBounds();
          Flutter.postMessage(JSON.stringify({
            type: 'moveend',
            bounds: {
              sw: {
                lat: bounds.getSouth(),
                lng: bounds.getWest()
              },
              ne: {
                lat: bounds.getNorth(),
                lng: bounds.getEast()
              }
            },
            center: {
              lat: map.getCenter().lat,
              lng: map.getCenter().lng
            },
            zoom: map.getZoom()
          }));
        });
        
        // Camera functions
        function moveTo(lat, lng, zoom, animate) {
          if (animate) {
            map.flyTo({
              center: [lng, lat],
              zoom: zoom || map.getZoom(),
              essential: true
            });
          } else {
            map.jumpTo({
              center: [lng, lat],
              zoom: zoom || map.getZoom()
            });
          }
          Flutter.postMessage('Camera moved to: ' + lat + ',' + lng);
        }
        
        function zoomIn() {
          map.zoomIn();
          Flutter.postMessage('Zoomed in: ' + map.getZoom());
        }
        
        function zoomOut() {
          map.zoomOut();
          Flutter.postMessage('Zoomed out: ' + map.getZoom());
        }
        
        function fitBounds(sw_lat, sw_lng, ne_lat, ne_lng, padding) {
          padding = padding || 100;
          map.fitBounds([
            [sw_lng, sw_lat], // southwestern corner
            [ne_lng, ne_lat]  // northeastern corner
          ], {
            padding: padding
          });
          Flutter.postMessage('Fit bounds applied');
        }
        
        // Marker functions
        var markers = {};
        var markerId = 0;
        
        function addMarker(lat, lng, options) {
          options = options || {};
          var el = document.createElement('div');
          el.className = 'marker';
          
          if (options.title) {
            var popup = new maplibregl.Popup({ offset: 25 })
              .setText(options.title);
          }
          
          var marker = new maplibregl.Marker({
            element: el,
            scale: options.iconSize || 1
          })
            .setLngLat([lng, lat]);
            
          if (popup) {
            marker.setPopup(popup);
          }
          
          marker.addTo(map);
          markers[markerId] = marker;
          Flutter.postMessage('Marker added: ' + markerId);
          return markerId++;
        }
        
        function removeMarker(id) {
          if (markers[id]) {
            markers[id].remove();
            delete markers[id];
            Flutter.postMessage('Marker removed: ' + id);
            return true;
          }
          return false;
        }
        
        function clearMarkers() {
          for (var id in markers) {
            markers[id].remove();
          }
          markers = {};
          Flutter.postMessage('All markers cleared');
        }
        
        // Line and shape functions
        var lines = {};
        var fills = {};
        var lineId = 0;
        var fillId = 0;
        
        function addLine(coordinates, options) {
          options = options || {};
          
          if (!map.getSource('line-' + lineId)) {
            map.addSource('line-' + lineId, {
              'type': 'geojson',
              'data': {
                'type': 'Feature',
                'properties': {},
                'geometry': {
                  'type': 'LineString',
                  'coordinates': coordinates
                }
              }
            });
            
            map.addLayer({
              'id': 'line-' + lineId,
              'type': 'line',
              'source': 'line-' + lineId,
              'layout': {
                'line-join': 'round',
                'line-cap': 'round'
              },
              'paint': {
                'line-color': options.lineColor || '#ff0000',
                'line-width': options.lineWidth || 2,
                'line-opacity': options.lineOpacity || 1.0
              }
            });
            
            lines[lineId] = 'line-' + lineId;
            Flutter.postMessage('Line added: ' + lineId);
            return lineId++;
          }
        }
        
        function removeLine(id) {
          if (lines[id]) {
            if (map.getLayer(lines[id])) {
              map.removeLayer(lines[id]);
            }
            if (map.getSource(lines[id])) {
              map.removeSource(lines[id]);
            }
            delete lines[id];
            Flutter.postMessage('Line removed: ' + id);
            return true;
          }
          return false;
        }
        
        function clearLines() {
          for (var id in lines) {
            if (map.getLayer(lines[id])) {
              map.removeLayer(lines[id]);
            }
            if (map.getSource(lines[id])) {
              map.removeSource(lines[id]);
            }
          }
          lines = {};
          Flutter.postMessage('All lines cleared');
        }
        
        function addFill(coordinates, options) {
          options = options || {};
          
          if (!map.getSource('fill-' + fillId)) {
            map.addSource('fill-' + fillId, {
              'type': 'geojson',
              'data': {
                'type': 'Feature',
                'properties': {},
                'geometry': {
                  'type': 'Polygon',
                  'coordinates': [coordinates]
                }
              }
            });
            
            map.addLayer({
              'id': 'fill-' + fillId,
              'type': 'fill',
              'source': 'fill-' + fillId,
              'paint': {
                'fill-color': options.fillColor || '#FFFF00',
                'fill-opacity': options.fillOpacity || 0.5,
                'fill-outline-color': options.outlineColor || '#000000'
              }
            });
            
            fills[fillId] = 'fill-' + fillId;
            Flutter.postMessage('Fill added: ' + fillId);
            return fillId++;
          }
        }
        
        function highlightArea(coordinates) {
          return addFill(coordinates, {
            fillColor: '#00FF00',
            fillOpacity: 0.3,
            outlineColor: '#00FF00'
          });
        }
      </script>
    </body>
    </html>
    ''';
}
