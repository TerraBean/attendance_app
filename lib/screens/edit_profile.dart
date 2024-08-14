import 'package:attendance_app/services/firebase_services.dart';
import 'package:attendance_app/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();

  final _lastNameController = TextEditingController();

  final _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Get the current employee data from FirestoreService
    final firebaseService =
        Provider.of<FirestoreService>(context, listen: false);
    final currentEmployee = firebaseService.currentEmployee;

    // Populate the text controllers with the current employee data
    if (currentEmployee != null) {
      _firstNameController.text = currentEmployee.firstName ?? '';
      _lastNameController.text = currentEmployee.lastName ?? '';
      _phoneNumberController.text = currentEmployee.phoneNumber ?? '';
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
            FocusScope.of(context).unfocus();
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Input your changes',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey, // Add the form key here
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                      'https://i.pravatar.cc/300'), // Replace with actual user image URL
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Implement profile image change functionality
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.green),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Edit',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
                const SizedBox(height: 30),
                Consumer<FirestoreService>(
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
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: OutlinedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                side: const BorderSide(color: Colors.grey),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Update the user data in Firestore
                  final firebaseService =
                      Provider.of<FirestoreService>(context, listen: false);

                  if (firebaseService.currentEmployee != null) {
                    firebaseService.updateUser(
                      firebaseService.currentEmployee!.uid,
                      _firstNameController.text,
                      _lastNameController.text,
                      _phoneNumberController.text,
                    );

                    Navigator.pop(context);
                  } else {
                    // Handle the case where currentEmployee is null
                    print('Error: Current employee is null.');
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
