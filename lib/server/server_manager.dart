import 'dart:convert';
import 'dart:io';
import 'package:baato_maps/baato_maps.dart';
import 'package:baato_maps/src/map/map_configuration.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class ServerManager {
  HttpServer? _server;
  bool _isRunning = false;

  Future<void> startServer() async {
    if (_isRunning) {
      print('Server is already running');
      return;
    }

    try {
      // Start the server on localhost:8080
      _server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);
      _isRunning = true;
      print('Server running on http://localhost:${_server!.port}');

      // Handle incoming requests
      _server!.listen((HttpRequest request) async {
        final String requestPath = request.uri.path;

        // Define the base directory for assets
        // Note: In a Flutter app, assets are bundled and accessed via DefaultAssetBundle,
        // so we can't use File to read from the assets directory directly.
        // We'll handle this in the next step.
        String? fileContent;
        if (requestPath == '/styles/breeze.json') {
          var breezeStyle = styleMap;
          // breezeStyle['sources']['qvez6ula1']['tiles'] = [
          //   "https://api.baato.io/api/v1/maps/{z}/{x}/{y}.pbf?key=${BaatoMapConfig.instance.apiKey}",
          // ];
          fileContent = jsonEncode(breezeStyle);
        } else if (requestPath == '/sprites/breeze/breeze.json') {
          fileContent = await _loadAsset(
            'packages/baato_maps/lib/assets/sprites/breeze/breeze.json',
          );
        } else if (requestPath == '/sprites/breeze/breeze.png') {
          fileContent = null; // We'll handle binary data separately
        } else if (requestPath == '/sprites/breeze/breeze@2x.json') {
          fileContent = await _loadAsset(
            'packages/baato_maps/lib/assets/sprites/breeze/breeze@2x.json',
          );
        } else if (requestPath == '/sprites/breeze/breeze@2x.png') {
          fileContent = null; // We'll handle binary data separately
        } else if (requestPath.startsWith('/fonts/Roboto/')) {
          // final fileName = path.basename(requestPath);
          fileContent = null; // We'll handle binary data separately
        } else {
          request.response
            ..statusCode = HttpStatus.notFound
            ..write('Not Found')
            ..close();
          return;
        }

        if (fileContent != null) {
          // Serve JSON or text content
          request.response.headers.contentType = ContentType.json;
          request.response.headers.add('Access-Control-Allow-Origin', '*');
          request.response.headers.add('Access-Control-Allow-Methods', 'GET');
          request.response.write(fileContent);
          await request.response.close();
        } else {
          // Handle binary content (e.g., PNG, PBF)
          if (requestPath == '/sprites/breeze/breeze.png') {
            final bytes = await _loadAssetBytes(
              'packages/baato_maps/lib/assets/sprites/breeze/breeze.png',
            );
            if (bytes != null) {
              request.response.headers.contentType = ContentType.binary;
              request.response.headers.add('Access-Control-Allow-Origin', '*');
              request.response.headers.add(
                'Access-Control-Allow-Methods',
                'GET',
              );
              request.response.add(bytes);
              await request.response.close();
            } else {
              request.response
                ..statusCode = HttpStatus.notFound
                ..write('File Not Found')
                ..close();
            }
          } else if (requestPath == '/sprites/breeze/breeze@2x.png') {
            final bytes = await _loadAssetBytes(
              'packages/baato_maps/lib/assets/sprites/breeze/breeze@2x.png',
            );
            if (bytes != null) {
              request.response.headers.contentType = ContentType.binary;
              request.response.headers.add('Access-Control-Allow-Origin', '*');
              request.response.headers.add(
                'Access-Control-Allow-Methods',
                'GET',
              );
              request.response.add(bytes);
              await request.response.close();
            } else {
              request.response
                ..statusCode = HttpStatus.notFound
                ..write('File Not Found')
                ..close();
            }
          } else if (requestPath.startsWith('/fonts/Roboto/')) {
            final fileName = path.basename(requestPath);
            final bytes = await _loadAssetBytes(
              'packages/baato_maps/lib/assets/fonts/Roboto/$fileName',
            );
            if (bytes != null) {
              request.response.headers.contentType = ContentType(
                'application',
                'x-protobuf',
              );
              request.response.headers.add('Access-Control-Allow-Origin', '*');
              request.response.headers.add(
                'Access-Control-Allow-Methods',
                'GET',
              );
              request.response.add(bytes);
              await request.response.close();
            } else {
              request.response
                ..statusCode = HttpStatus.notFound
                ..write('File Not Found')
                ..close();
            }
          }
        }
      });
    } catch (e) {
      print('Error starting server: $e');
      _isRunning = false;
      _server = null;
    }
  }

  Future<void> stopServer() async {
    if (!_isRunning || _server == null) {
      print('Server is not running');
      return;
    }

    try {
      await _server!.close(force: true);
      _isRunning = false;
      _server = null;
      print('Server stopped');
    } catch (e) {
      print('Error stopping server: $e');
    }
  }

  bool get isRunning => _isRunning;

  // Helper method to load asset content as a string
  Future<String?> _loadAsset(String assetPath) async {
    try {
      // In a Flutter app, use DefaultAssetBundle to load assets
      // This requires a BuildContext, which we'll pass in later
      return await DefaultAssetBundle.of(_context!).loadString(assetPath);
    } catch (e) {
      print('Error loading asset $assetPath: $e');
      return null;
    }
  }

  // Helper method to load asset content as bytes (for binary files like PNG, PBF)
  Future<List<int>?> _loadAssetBytes(String assetPath) async {
    try {
      final byteData = await DefaultAssetBundle.of(_context!).load(assetPath);
      return byteData.buffer.asUint8List();
    } catch (e) {
      print('Error loading asset bytes $assetPath: $e');
      return null;
    }
  }

  // Store the BuildContext to access DefaultAssetBundle
  BuildContext? _context;

  void setContext(BuildContext context) {
    _context = context;
  }
}
