import 'package:baato_maps/baato_maps.dart';
import 'package:baato_maps/src/map_lite/map_js.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MapLiteView extends StatefulWidget {
  const MapLiteView({super.key});

  @override
  State<MapLiteView> createState() => _MapLiteViewState();
}

class _MapLiteViewState extends State<MapLiteView> {
  late WebViewController _controller;
  int styleIndex = 0;
  List<String> styleUrls = [
    'https://tileboundaries.baato.io/admin_boundary/breeze_ranking_21.json',
    'https://api.npoint.io/46cab53072eb19ecbb38',
  ];
  @override
  void initState() {
    super.initState();
    final htmlContent = mapJS(
      styleUrl: styleUrls[styleIndex],
      center: BaatoCoordinate(
        27.7172,
        85.3240,
      ),
    );
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'Flutter',
        onMessageReceived: (JavaScriptMessage message) {
          print(message.message);
        },
      )
      ..loadHtmlString(htmlContent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MapLibre GL JS in Flutter'),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FloatingActionButton(
                  heroTag: 'addMarker',
                  onPressed: () {
                    _controller.runJavaScript(
                        "addMarker(27.7172, 85.3240, 'Sample Marker')");
                  },
                  tooltip: 'Add Marker',
                  child: Icon(Icons.location_on),
                ),
                SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: 'addLine',
                  onPressed: () {
                    _controller.runJavaScript(
                        "addLine([[85.3240, 27.7172], [85.3280, 27.7190], [85.3300, 27.7150]])");
                  },
                  tooltip: 'Add Line',
                  child: Icon(Icons.timeline),
                ),
                SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: 'addPolygon',
                  onPressed: () {
                    _controller.runJavaScript(
                        "addFill([[85.3240, 27.7172], [85.3280, 27.7190], [85.3300, 27.7150], [85.3240, 27.7172]])");
                  },
                  tooltip: 'Add Polygon',
                  child: Icon(Icons.crop_square),
                ),
                SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: 'addCircle',
                  onPressed: () {
                    _controller.runJavaScript("addFill(27.7172, 85.3240, 100)");
                  },
                  tooltip: 'Add Circle',
                  child: Icon(Icons.circle_outlined),
                ),
                SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: 'clearShapes',
                  onPressed: () {
                    _controller.runJavaScript("clearAllShapes()");
                  },
                  tooltip: 'Clear All Shapes',
                  backgroundColor: Colors.red,
                  child: Icon(Icons.clear),
                ),
                SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: 'changeStyle',
                  onPressed: () {
                    styleIndex++;
                    if (styleIndex > 1) {
                      styleIndex = 0;
                    }
                    // Call JavaScript to change the map style
                    _controller.runJavaScript(
                        "setMapStyle('${styleUrls[styleIndex]}')");
                  },
                  tooltip: 'Change Style',
                  child: Icon(Icons.map),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          styleIndex++;
          if (styleIndex > 1) {
            styleIndex = 0;
          }
          // Call JavaScript to change the map style
          _controller.runJavaScript("setMapStyle('${styleUrls[styleIndex]}')");
        },
        tooltip: 'Change Style',
        child: Icon(Icons.map),
      ),
    );
  }
}
