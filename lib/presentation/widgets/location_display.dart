import 'package:attendance_app/services/location_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LocationDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LocationService>(
      builder: (context, locationService, child) {
        if (locationService.currentLocation == null) {
          return Text('No location available');
        } else {
          return Text(
            'Lat: ${locationService.currentLocation!.latitude}, '
            'Long: ${locationService.currentLocation!.longitude}',
          );
        }
      },
    );
  }
}
