import 'package:flutter/material.dart';

class EmployeeManagement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search Staff',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {
                    // Implement search functionality here
                  },
                  child: Text('Search', style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 15),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView(
                children: [
                  EmployeeCard(
                    name: 'Adams Mujahid',
                    email: 'mujahid@yamail.com',
                    onEdit: () {},
                    onCall: () {},
                    onDelete: () {},
                  ),
                  EmployeeCard(
                    name: 'Ernest Adjei',
                    email: 'ernest@yamail.com',
                    onEdit: () {},
                    onCall: () {},
                    onDelete: () {},
                  ),
                  EmployeeCard(
                    name: 'Linda Baidoo',
                    email: 'linda@yamail.com',
                    onEdit: () {},
                    onCall: () {},
                    onDelete: () {},
                  ),
                  EmployeeCard(
                    name: 'David Aud Acheampong',
                    email: 'kokot@yamail.com',
                    onEdit: () {},
                    onCall: () {},
                    onDelete: () {},
                  ),
                ],
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
                  icon: Icon(Icons.edit),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: Icon(Icons.phone),
                  onPressed: onCall,
                ),
                IconButton(
                  icon: Icon(Icons.delete),
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
