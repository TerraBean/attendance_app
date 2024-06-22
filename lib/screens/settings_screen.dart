import 'package:attendance_app/services/radius_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Set Radius (meters)',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Consumer<RadiusService>(
              builder: (context, radiusService, child) {
                return Slider(
                  value: radiusService.radius,
                  min: 5,
                  max: 100,
                  divisions: 5,
                  label: radiusService.radius.round().toString(),
                  onChanged: (double value) {
                    radiusService.setRadius(value);
                
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
