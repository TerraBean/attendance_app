import 'package:flutter/material.dart';
import 'package:attendance_app/services/firebase_services.dart'; // Import FirebaseService

class RadiusService extends ChangeNotifier {
  double? _radius; // Make radius nullable
  final FirestoreService _firestoreService = FirestoreService(); // Initialize FirebaseService

  double? get radius => _radius; // Return nullable radius

  // Initialize radius from Firestore on creation
  RadiusService() {
    _initializeRadiusFromFirestore();
  }

  Future<void> _initializeRadiusFromFirestore() async {
    // Retrieve radius from Firestore
    double? radius = await _firestoreService.getRadius();
    if (radius != null) {
      _radius = radius;
      notifyListeners();
    }
  }

  // Update radius in Firestore
  Future<void> setRadius(double radius) async {
    await _firestoreService.updateRadius(radius);
    _radius = radius; // Update local radius
    notifyListeners();
  }
}
