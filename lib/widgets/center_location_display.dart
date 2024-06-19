import 'package:attendance_app/services/location_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class CenterLocationDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LocationService>(
      builder: (context, locationService, child) {
        if (locationService.centerLocation == null) {
          return Text('No center location set');
        } else {
          return Text(
            'Center Location - Lat: ${locationService.centerLocation!.latitude}, '
            'Long: ${locationService.centerLocation!.longitude}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          );
        }
      },
    );
  }
}
