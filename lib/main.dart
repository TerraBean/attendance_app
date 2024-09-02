import 'package:attendance_app/presentation/screens/admin/admin.dart';
import 'package:attendance_app/presentation/screens/attendance_timeline.dart';
import 'package:attendance_app/presentation/screens/employee_management.dart';
import 'package:attendance_app/presentation/screens/home_screen.dart';
import 'package:attendance_app/presentation/screens/login.dart';
import 'package:attendance_app/presentation/screens/registration.dart';
import 'package:attendance_app/services/auth_services.dart';
import 'package:attendance_app/services/firebase_services.dart';
import 'package:attendance_app/services/location_services.dart';
import 'package:attendance_app/services/radius_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final authService = AuthService();
  User? user = await authService.checkForExistingLogin();
  runApp(MyApp(initialUser: user));
}

class MyApp extends StatelessWidget {
  final User? initialUser;

  const MyApp({this.initialUser});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocationService()),
        ChangeNotifierProvider(create: (_) => RadiusService()),
        ChangeNotifierProvider(create: (context) => FirestoreService()),
      ],
      
      child: MaterialApp(
        // ... your other configurations
        routes: {
          '/login': (context) => const LoginPage(),
          '/registration': (context) => const RegistrationPage(),
          '/attendance-timeline':(context) => AttendanceTimeline(),
          '/employee-management':(context) => EmployeeManagement(),
          // ... other routes
        },
            localizationsDelegates: const [
          MonthYearPickerLocalizations.delegate, // Add this line
        ],
        supportedLocales: const [
          Locale('en', ''), // Add the locales you need here
          // Other locales the app supports
        ],
        home: FutureBuilder<bool>(
          future: _checkAdminStatus(initialUser), // Check admin status
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // Show a loading indicator
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              bool isAdmin =
                  snapshot.data ?? false; // Default to false if error

              // Decide which screen to show
              if (initialUser != null && isAdmin) {
                return Admin(); // Navigate to Admin page
              } else if (initialUser != null) {
                return HomeScreen(
                  userId: initialUser!.uid,
                ); // Navigate to HomeScreen
              } else {
                return const LoginPage(); // Navigate to LoginPage
              }
            }
          },
        ),
      ),
    );
  }

  // Helper function to check admin status
  Future<bool> _checkAdminStatus(User? user) async {
    if (user == null) return false; // Not logged in, not an admin
    final authService = AuthService();
    return authService.isAdmin(user.uid);
  }
}
