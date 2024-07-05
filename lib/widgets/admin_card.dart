import 'package:flutter/material.dart';

class ReusableCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String data;

  ReusableCard({
    required this.icon,
    required this.title,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              icon,
              size: 40,
            ),
            SizedBox(width: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 14,),
                ),
                Row(
                  children: [
                    Text(
                      data,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}