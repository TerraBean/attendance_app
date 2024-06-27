import 'package:flutter/material.dart';

class LogoutConfirmationDialog extends StatefulWidget {
  final VoidCallback onConfirmLogout;

  const LogoutConfirmationDialog({Key? key, required this.onConfirmLogout})
      : super(key: key);

  @override
  _LogoutConfirmationDialogState createState() =>
      _LogoutConfirmationDialogState();
}

class _LogoutConfirmationDialogState
    extends State<LogoutConfirmationDialog> {
  bool _logoutFromAllDevices = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.favorite,
            color: Colors.pink,
            size: 48.0,
          ),
          SizedBox(height: 16.0),
          Text(
            'See you soon!',
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            'You are about to logout. Are you sure this is what you want?',
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.0),
          Row(
            children: <Widget>[
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.red,
                    side: BorderSide(color: Colors.red),
                  ),
                ),
              ),
              SizedBox(width: 8.0),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Call the onConfirmLogout callback
                    print('confirmed');
                    Navigator.of(context).pop();
                    widget.onConfirmLogout();
                     // Close the dialog
                  },
                  child: Text('Confirm logout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
