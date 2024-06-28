import 'package:attendance_app/services/location_services.dart';
import 'package:attendance_app/services/user_api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClockInButton extends StatelessWidget {
  final String userId; // Add userId to the constructor

  ClockInButton({required this.userId}); // Initialize userId

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationService>(
      builder: (context, locationService, child) {
        if (locationService.currentLocation == null ||
            locationService.centerLocation == null) {
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
              ? () async {
                  // Clock in/out logic
                  try {
                    await UserApi.recordTimeEntry(userId); // Call recordTimeEntry
                    // Show snackbar after successful clock in
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Clocked in successfully!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    // ... (Additional logic for clocking in)
                  } catch (error) {
                    // Handle errors
                    print('Error recording time entry: $error');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error clocking in: $error'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                }
              : null,
          child: Text('Clock In'),
        );
      },
    );
  }
}
