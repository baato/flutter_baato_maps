import 'package:baato_maps/baato_maps.dart';
import 'package:example/bottom_sheet/bottom_sheet_controller.dart';
import 'package:example/bottom_sheet/bottom_sheet_type.dart';
import 'package:example/bottom_sheet/widgets/route_detail_bottom_sheet.dart';
import 'package:flutter/material.dart';

class PlaceDetailBottomSheet extends BottomSheetType {
  final String title;
  final String address;
  final String distance;
  final LatLng coordinates;
  PlaceDetailBottomSheet({
    required this.title,
    required this.address,
    required this.distance,
    required this.coordinates,
  });
}

class PlaceDetailBottomSheetWidget extends StatelessWidget {
  final BottomSheetController controller;
  final String title;
  final String address;
  final String distance;
  final LatLng coordinates;

  const PlaceDetailBottomSheetWidget({
    super.key,
    required this.controller,
    required this.title,
    required this.address,
    required this.distance,
    required this.coordinates,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: Colors.grey),
              const SizedBox(width: 4.0),
              Expanded(
                child: Text(
                  address,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4.0),
          Row(
            children: [
              const Icon(Icons.directions_walk, size: 16, color: Colors.grey),
              const SizedBox(width: 4.0),
              Text(
                distance,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
              ),
            ],
          ),
          const SizedBox(height: 24.0),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    controller.updateBottomSheetType(
                      RouteDetailBottomSheet(
                        destinationCoordinates: coordinates,
                      ),
                    );
                  },
                  icon: const Icon(Icons.directions),
                  label: const Text('Get Directions'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                  ),
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.bookmark_border),
                  label: const Text('Bookmark'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
