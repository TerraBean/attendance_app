
import 'package:attendance_app/screens/login.dart';
import 'package:attendance_app/services/location_services.dart';
import 'package:attendance_app/services/radius_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocationService()),
        ChangeNotifierProvider(create: (_) => RadiusService()),
      ],
      child: MaterialApp(
        title: 'Clock In/Out App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginPage(),
      ),
    );
  }
}
