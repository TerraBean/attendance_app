import 'package:flutter/material.dart';

class TotalCard extends StatelessWidget {
  final String title;
  final int count;
  final Color countColor;

  const TotalCard({
    Key? key,
    required this.title,
    required this.count,
    required this.countColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Divider(color: Colors.grey),
          SizedBox(height: 10),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 35,
              color: countColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
