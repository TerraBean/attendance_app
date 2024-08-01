import 'dart:async';

import 'package:attendance_app/models/location_model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'radius_service.dart';
import 'firebase_services.dart'; // Import FirebaseService

class LocationService extends ChangeNotifier {
  LocationModel? _currentLocation;
  LocationModel? _centerLocation;
  StreamSubscription<Position>? _positionStreamSubscription;
  final FirestoreService _firestoreService = FirestoreService(); // Initialize FirebaseService

  LocationModel? get currentLocation => _currentLocation;
  LocationModel? get centerLocation => _centerLocation;

  LocationService() {
    _initializeLocationStream();
    _initializeCurrentLocationFromFirestore(); // Initialize from Firestore
  }

  void _initializeLocationStream() {
    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 0, // Adjust distance filter as per your requirement
      ),
    ).listen((Position position) {
      // Update currentLocation with every position update from the stream
      _currentLocation = LocationModel(
          latitude: position.latitude, longitude: position.longitude);
      notifyListeners();
    });
  }

  Future<void> _initializeCurrentLocationFromFirestore() async {
    // Retrieve coordinates from Firestore
    LocationModel? coordinates = await _firestoreService.getCoordinates();
    if (coordinates != null) {
      _centerLocation = coordinates;
      notifyListeners();
    }
  }

  Future<void> setCenterLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
       // Call updateCenterLocation from FirebaseService
      await _firestoreService.updateCenterLocation(
        position.latitude,
        position.longitude,
      );
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

    // Check if radius is not null before comparing
    if (radius != null) {
      double distance = Geolocator.distanceBetween(
        _centerLocation!.latitude,
        _centerLocation!.longitude,
        _currentLocation!.latitude,
        _currentLocation!.longitude,
      );

      return distance <= radius;
    } else {
      return false; // Or handle the case where radius is null
    }
  }


  @override
  void dispose() {
    _positionStreamSubscription
        ?.cancel(); // Cancel the position stream when disposing
    super.dispose();
  }
}
