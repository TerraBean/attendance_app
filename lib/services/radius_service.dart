import 'package:flutter/material.dart';

class RadiusService extends ChangeNotifier {
  double _radius = 100.0; // default radius in meters

  double get radius => _radius;

  void setRadius(double radius) {
    _radius = radius;
    notifyListeners();
  }
}
