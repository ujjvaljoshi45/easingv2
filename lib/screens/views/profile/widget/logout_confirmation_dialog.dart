import 'package:flutter/material.dart';

class LogoutConfirmationDialog extends StatelessWidget {
  final VoidCallback onLogout;

  const LogoutConfirmationDialog({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Confirm Logout"),
      content: const Text("Are you sure you want to log out?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            onLogout();
          },
          child: const Text("Logout"),
        ),
      ],
    );
  }
}
