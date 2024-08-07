import 'package:attendance_app/services/firebase_services.dart'; // Import FirebaseService
import 'package:attendance_app/services/location_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClockOutButton extends StatelessWidget {
  // Removed userId from the constructor

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationService>(
      builder: (context, locationService, child) {
        if (locationService.currentLocation == null ||
            locationService.centerLocation == null) {
          return ElevatedButton(
            onPressed: null,
            child: Text('Clock Out'),
          );
        }

        bool isWithinRadius = locationService.isWithinRadius(context);

        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isWithinRadius ? Colors.red : Colors.grey,
          ),
          onPressed: isWithinRadius
              ? () async {
                  // clockout
                  final firebaseService =
                      Provider.of<FirestoreService>(context, listen: false); // Get FirebaseService instance
                  await firebaseService.clockOut(context); // Call clockOut from FirebaseService
                  // Show snackbar after successful clock out
                  try {
                   print('Clocked out');
                    // ... (Additional logic for clocking out)
                  } catch (error) {
                    // Handle errors
                    print('Error recording time entry: $error');
                  }
                }
              : null,
          child: Text('Clock Out'),
        );
      },
    );
  }
}
