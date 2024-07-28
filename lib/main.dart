
import 'package:attendance_app/screens/login.dart';
import 'package:attendance_app/services/firebase_services.dart';
import 'package:attendance_app/services/location_services.dart';
import 'package:attendance_app/services/radius_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
void main() async{
   WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocationService()),
        ChangeNotifierProvider(create: (_) => RadiusService()),
        ChangeNotifierProvider(create: (context) => FirestoreService()),
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
