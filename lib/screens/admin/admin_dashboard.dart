import 'package:attendance_app/widgets/admin_card.dart';
import 'package:flutter/material.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ReusableCard(
                icon: Icons.person,
                title: "Total Employees",
                data: '20',
              ),
            ),
            Expanded(
              child: ReusableCard(
                icon: Icons.person,
                title: "Total Employees",
                data: '20',
              ),
            ),
          ],
        ),
      ],
    ));
  }
}
