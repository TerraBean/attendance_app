import 'package:attendance_app/services/location_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClockInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LocationService>(
      builder: (context, locationService, child) {
        if (locationService.currentLocation == null || locationService.centerLocation == null) {
          return ElevatedButton(
            onPressed: null,
            child: Text('Clock In'),
          );
        }

        bool isWithinRadius = locationService.isWithinRadius(context);

        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isWithinRadius ? Colors.red : Colors.grey,
          ),
          onPressed: isWithinRadius
              ? () {
                  // Clock in/out logic
                }
              : null,
          child: Text('Clock In'),
        );
      },
    );
  }
}
