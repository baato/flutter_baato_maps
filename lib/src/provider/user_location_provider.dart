import 'package:flutter/material.dart';
import 'package:location/location.dart';

class UserLocationProvider with ChangeNotifier {
  Location _location = Location();
  bool _serviceEnabled = false;
  PermissionStatus _permissionGranted = PermissionStatus.denied;
  LocationData? _locationData;

  UserLocationProvider() {
    _checkPermissions();
  }

  LocationData? get locationData => _locationData;

  Future<void> _checkPermissions() async {
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await _location.getLocation();
    notifyListeners();
  }

  Future<void> updateLocation() async {
    if (_permissionGranted == PermissionStatus.granted) {
      _locationData = await _location.getLocation();
      notifyListeners();
    }
  }
}
