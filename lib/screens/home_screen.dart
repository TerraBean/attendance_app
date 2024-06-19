import 'package:attendance_app/screens/settings_screen.dart';
import 'package:attendance_app/services/location_services.dart';
import 'package:attendance_app/widgets/center_location_display.dart';
import 'package:attendance_app/widgets/clock_in_button.dart';
import 'package:attendance_app/widgets/location_display.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clock In/Out App'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LocationDisplay(),
            CenterLocationDisplay(),
            ClockInButton(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<LocationService>(context, listen: false).setCenterLocation();
        },
        child: Icon(Icons.my_location),
      ),
    );
  }
}
