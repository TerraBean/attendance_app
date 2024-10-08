import 'package:attendance_app/services/location_services.dart';
import 'package:attendance_app/presentation/widgets/radius_settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminSettings extends StatelessWidget {
  const AdminSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Get the LocationService instance from the provider
                final locationService =
                    Provider.of<LocationService>(context, listen: false);

                // Call setCenterLocation() on the LocationService
                locationService.setCenterLocation(context);
              },
              child: const Text('Set Center Location'),
            ),
            const SizedBox(height: 20),
            RadiusSettings(),
          ],
        ),
      ),
    );
  }
}
