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
                  // Clock in/out logic
                  try {
                    final firebaseService =
                        Provider.of<FirestoreService>(context, listen: false); // Get FirebaseService instance
                    // Get the latest time entry ID
                    final timeEntryId = await firebaseService.getLastTimeEntryId();
                    if (timeEntryId != null) {
                      await firebaseService.clockOut(timeEntryId, context); // Call clockOut from FirebaseService
                
                    } else {
                      // Handle the case where no time entry is found
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('No active time entry found.'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
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
