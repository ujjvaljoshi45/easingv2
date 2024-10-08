import 'package:flutter/material.dart';

class LogoutConfirmationDialog extends StatelessWidget {
  final VoidCallback onLogout;

  const LogoutConfirmationDialog({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Logout Confirmation'),
      content: const Text('Are you sure you want to log out?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(), // Close dialog without action
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            onLogout(); // Call the logout function passed from the parent
            Navigator.of(context).pop(); // Close dialog after logging out
          },
          child: const Text('Logout'),
        ),
      ],
    );
  }
}
