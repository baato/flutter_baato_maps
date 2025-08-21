import 'package:example/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:baato_maps/baato_maps.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Entry point of the application.
///
/// Initializes the environment variables and configures the Baato API
/// before starting the application.
void main() async {
  await dotenv.load();
  await Baato.configure(apiKey: dotenv.get('BAATO_API_KEY'));
  runApp(const MyApp());
}

/// Root widget of the application.
///
/// Sets up the MaterialApp and defines the initial route.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: MyMapPage());
  }
}

/// Main map page widget that hosts the [MapScreen].
///
/// This widget serves as a container for the map interface and related UI components.
class MyMapPage extends StatefulWidget {
  const MyMapPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyMapPageState createState() => _MyMapPageState();
}

/// State for the [MyMapPage] widget.
///
/// Manages the state and builds the UI for the map page.
class _MyMapPageState extends State<MyMapPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: MapScreen());
  }
}
