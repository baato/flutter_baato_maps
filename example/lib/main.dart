import 'package:example/bottom_sheet/flutter_bottom_sheet.dart';
import 'package:example/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:baato_maps/baato_maps.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load();
  BaatoMapConfiguration.configure(apiKey: '${dotenv.get('BAATO_API_KEY')}');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyMapPage());
  }
}

class MyMapPage extends StatefulWidget {
  @override
  _MyMapPageState createState() => _MyMapPageState();
}

class _MyMapPageState extends State<MyMapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: MapScreen());
  }
}
