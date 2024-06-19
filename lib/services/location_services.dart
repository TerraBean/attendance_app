import 'dart:async';

import 'package:attendance_app/models/location_model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'radius_service.dart';

class LocationService extends ChangeNotifier {
  LocationModel? _currentLocation;
  LocationModel? _centerLocation;
  StreamSubscription<Position>? _positionStreamSubscription;

  LocationModel? get currentLocation => _currentLocation;
  LocationModel? get centerLocation => _centerLocation;

  LocationService() {
    _initializeLocationStream();
  }

  void _initializeLocationStream() {
    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter:1, // Adjust distance filter as per your requirement
      ),
    ).listen((Position position) {
      // Update currentLocation with every position update from the stream
      _currentLocation = LocationModel(
          latitude: position.latitude, longitude: position.longitude);
      notifyListeners();
    });
  }

  Future<void> setCenterLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      _centerLocation = LocationModel(
          latitude: position.latitude, longitude: position.longitude);
      notifyListeners();
    } catch (e) {
      // Handle the error
      print(e);
    }
  }

  bool isWithinRadius(BuildContext context) {
    if (_currentLocation == null || _centerLocation == null) {
      return false;
    }

    final radiusService = Provider.of<RadiusService>(context, listen: false);
    final radius = radiusService.radius;
    double distance = Geolocator.distanceBetween(
      _centerLocation!.latitude,
      _centerLocation!.longitude,
      _currentLocation!.latitude,
      _currentLocation!.longitude,
    );

    return distance <= radius;
  }

  @override
  void dispose() {
    _positionStreamSubscription
        ?.cancel(); // Cancel the position stream when disposing
    super.dispose();
  }
}
