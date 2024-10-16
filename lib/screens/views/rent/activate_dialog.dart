import 'package:easypg/services/api_handler.dart';
import 'package:easypg/utils/colors.dart';
import 'package:flutter/material.dart';

import '../../../utils/styles.dart';

class ActivateAdDialog extends StatelessWidget {
  final int amount;
  final String id;

  const ActivateAdDialog({super.key, required this.amount, required this.id});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      title: Text(
        'Activate Advertisement',
        style: montserrat.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      content: Text(
        'Do you want to activate the advertisement for ₹$amount?',
        style: montserrat.copyWith(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Cancel action
          },
          child: Text(
            'Cancel',
            style: montserrat.copyWith(color: Colors.white),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            Navigator.of(context).pop();
            await ApiHandler.instance.updateMoneyToWallet(-1*amount);
            await ApiHandler.instance.updateActivation(id);

          },
          style: ElevatedButton.styleFrom(
            backgroundColor: myOrange, // Main color
          ),
          child: Text('Activate',style: montserrat.copyWith(color: Colors.white),),
        ),
      ],
      backgroundColor: Color(0xFF1E1E1E), // Dialog background color
    );
  }
}
