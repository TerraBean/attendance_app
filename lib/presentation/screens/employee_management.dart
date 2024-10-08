import 'package:attendance_app/models/user_info.dart';
import 'package:attendance_app/presentation/screens/edit_profile.dart';
import 'package:attendance_app/services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmployeeManagement extends StatefulWidget {
  @override
  _EmployeeManagementState createState() => _EmployeeManagementState();
}

class _EmployeeManagementState extends State<EmployeeManagement> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = ''; // Store the current search query

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final firebaseService = Provider.of<FirestoreService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Staff'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Staff Management',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search Staff',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              onChanged: (query) {
                setState(() {
                  searchQuery = query.toLowerCase();
                });
              },
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: StreamBuilder<List<Employee>>(
                stream: firebaseService.usersWithTimeEntriesStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No employees found.'));
                  } else {
                    List<Employee> filteredEmployees = snapshot.data!
                        .where((employee) {
                          final fullName =
                              '${employee.firstName} ${employee.lastName}'
                                  .toLowerCase();
                          return fullName.contains(searchQuery);
                        })
                        .toList();

                    return ListView.builder(
                      itemCount: filteredEmployees.length,
                      itemBuilder: (context, index) {
                        Employee employee = filteredEmployees[index];
                        return EmployeeCard(
                          name: '${employee.firstName} ${employee.lastName}',
                          email: employee.email ?? 'N/A',
                          onEdit: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfilePage(
                                  userId: employee.uid,
                                ),
                              ),
                            );
                          },
                          onCall: () {
                            // Implement call functionality
                          },
                          onDelete: () {
                            // Implement delete functionality
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmployeeCard extends StatelessWidget {
  final String name;
  final String email;
  final VoidCallback onEdit;
  final VoidCallback onCall;
  final VoidCallback onDelete;

  const EmployeeCard({
    required this.name,
    required this.email,
    required this.onEdit,
    required this.onCall,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(email),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.green[400],
                  ),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: Icon(Icons.phone),
                  onPressed: onCall,
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red[400],
                  ),
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
