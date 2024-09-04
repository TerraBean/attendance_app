import 'package:attendance_app/models/user_info.dart';
import 'package:attendance_app/services/firebase_services.dart';
import 'package:attendance_app/presentation/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  final String? userId; // Add userId to receive from previous screen

  const EditProfilePage({Key? key, this.userId}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  Employee? _employee; // Store the fetched employee data

  @override
  void initState() {
    super.initState();
    _fetchEmployeeData();
  }

  Future<void> _fetchEmployeeData() async {
    if (widget.userId != null) {
      final firebaseService =
          Provider.of<FirestoreService>(context, listen: false);

      // Access the cached data
      final cachedEmployees =
          firebaseService.usersWithTimeEntriesCache['allUsers'];

      // Find the employee with the matching userId
      _employee = cachedEmployees?.firstWhere(
        (employee) => employee.uid == widget.userId,
      );

      // Update text controllers after fetching data
      if (_employee != null) {
        _firstNameController.text = _employee!.firstName ?? '';
        _lastNameController.text = _employee!.lastName ?? '';
        _phoneNumberController.text = _employee!.phoneNumber ?? '';
      }
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.green),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Consumer<FirestoreService>(
            builder: (context, firebaseService, child) {
              return Column(
                children: [
                  InputField(
                    hintText: 'First Name',
                    labelText: 'First Name',
                    controller: _firstNameController,
                    onChanged: (d) => null,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                    prefixIcon: Icons.person,
                  ),
                  const SizedBox(height: 20),
                  InputField(
                    hintText: 'Last Name',
                    labelText: 'Last Name',
                    controller: _lastNameController,
                    onChanged: (d) => null,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                    prefixIcon: Icons.person_outline,
                  ),
                  const SizedBox(height: 20),
                  InputField(
                    hintText: 'Phone Number',
                    labelText: 'Phone Number',
                    controller: _phoneNumberController,
                    onChanged: (p0) => null,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                    prefixIcon: Icons.phone,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Update the user data in Firestore
                        final firebaseService = Provider.of<FirestoreService>(
                            context,
                            listen: false);

                        // Use _employee.uid instead of firebaseService.currentEmployee
                        if (_employee != null) {
                          firebaseService.updateUser(
                            _employee!.uid, // Pass the userId received
                            true,
                            _firstNameController.text,
                            _lastNameController.text,
                            _phoneNumberController.text,
                          );

                          Navigator.pop(context);
                        } else {
                          // Handle the case where _employee is null
                          print('Error: Employee data is null.');
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Save Changes',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
