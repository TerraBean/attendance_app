import 'package:attendance_app/services/radius_service.dart';
import 'package:attendance_app/widgets/radius_settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: RadiusSettings(),
    );
  }
}


