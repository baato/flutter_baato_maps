import 'package:baato_maps/baato_maps.dart';
import 'package:flutter/material.dart';

class MinWebApp extends StatelessWidget {
  const MinWebApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MapLibre Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MapLiteView(),
    );
  }
}
