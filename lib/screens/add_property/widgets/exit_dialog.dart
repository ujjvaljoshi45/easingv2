import 'package:flutter/material.dart';

class ExitConfirmationDialog extends StatelessWidget {
  final VoidCallback onExit;

  const ExitConfirmationDialog({super.key, required this.onExit});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Exit Confirmation'),
      content: const Text('Are you sure you want to exit the form? Unsaved changes will be lost.'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(), // Close dialog without action
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            onExit(); // Call the exit function passed from the parent
            Navigator.of(context).pop(); // Close dialog after exiting
          },
          child: const Text('Exit'),
        ),
      ],
    );
  }
}
