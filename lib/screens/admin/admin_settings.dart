import 'package:attendance_app/services/location_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminSettings extends StatelessWidget {
  const AdminSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Settings'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Get the LocationService instance from the provider
            final locationService =
                Provider.of<LocationService>(context, listen: false);

            // Call setCenterLocation() on the LocationService
            locationService.setCenterLocation();
          },
          child: const Text('Set Center Location'),
        ),
      ),
    );
  }
}
