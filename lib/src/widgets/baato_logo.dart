import 'package:baato_maps/baato_maps.dart';
import 'package:flutter/material.dart';

class BaatoLogo extends StatelessWidget {
  const BaatoLogo({super.key, required this.style});
  final BaatoMapStyle style;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "lib/assets/logo/baato_name.png",
      package: "baato_maps",
      height: 35,
      color:
          style.styleURL == BaatoMapStyle.dark.styleURL ? Colors.white : null,
    );
  }
}
