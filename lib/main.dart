import 'package:attendance_app/screens/login.dart';
import 'package:attendance_app/screens/registration.dart';
import 'package:attendance_app/services/firebase_services.dart';
import 'package:attendance_app/services/location_services.dart';
import 'package:attendance_app/services/radius_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:month_year_picker/month_year_picker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirestoreService firestoreService = FirestoreService();
  firestoreService.startUsersListener();
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
        localizationsDelegates: const [
          MonthYearPickerLocalizations.delegate, // Add this line
        ],
        supportedLocales: const [
          Locale('en', ''), // Add the locales you need here
          // Other locales the app supports
        ],
        title: 'Clock In/Out App',
        debugShowCheckedModeBanner: false,
        routes: {
          '/login': (context) => LoginPage(),
          '/registration': (context) => RegistrationPage(),
          // ... other routes
        },
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginPage(),
      ),
    );
  }
}
