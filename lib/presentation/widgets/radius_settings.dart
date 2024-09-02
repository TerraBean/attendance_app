import 'package:attendance_app/services/radius_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RadiusSettings extends StatefulWidget {
  const RadiusSettings({
    super.key,
  });

  @override
  State<RadiusSettings> createState() => _RadiusSettingsState();
}

class _RadiusSettingsState extends State<RadiusSettings> {
  @override
  Widget build(BuildContext context) {
    return Padding(
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
                value: radiusService.radius ?? 5.0, // Use default value if null
                min: 5,
                max: 100,
                divisions: 20,
                label: (radiusService.radius ?? 5.0).round().toString(), // Use default value if null
                onChanged: (double value) {
                  radiusService.setRadius(value);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
