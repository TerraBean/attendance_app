import 'package:attendance_app/services/firebase_services.dart'; // Import FirebaseService
import 'package:attendance_app/services/location_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClockInButton extends StatelessWidget {
  // Removed userId from the constructor

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
                    final firebaseService =
                        Provider.of<FirestoreService>(context, listen: false); // Get FirebaseService instance
                    await firebaseService.clockIn(context); // Call clockIn from FirebaseService
                    // Show snackbar after successful clock in
                    
                    // ... (Additional logic for clocking in)
                  } catch (error) {
                    // Handle errors
                    print('Error recording time entry: $error');
                    
                  }
                }
              : null,
          child: Text('Clock In'),
        );
      },
    );
  }
}
