import 'package:easypg/services/payment_service.dart';
import 'package:easypg/utils/tools.dart';
import 'package:flutter/material.dart';

class AddMoneyDialog {
  static Future<void> show(BuildContext context) async {
    int amount = 30; // Default minimum amount
    List<int> predefinedAmounts = [30, 50, 100];
    TextEditingController amountController = TextEditingController(text: amount.toString());

    await showDialog(
      context: context,
      builder: (BuildContext context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text("Add Money"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                spacing: 10.0,
                children: predefinedAmounts.map((predefinedAmount) {
                  return ChoiceChip(
                    label: Text("+ ₹$predefinedAmount"),
                    selected: false, // ChoiceChip should not be selectable
                    onSelected: (selected) => setState(
                        () => amountController.text = (amount += predefinedAmount).toString()),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: amountController,
                onChanged: (value) => setState(() => amount = int.tryParse(value) ?? 0),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Enter Amount (min ₹30)",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                (amount >= 30)
                    ? await _updateWallet(amount).whenComplete(
                        () => showToast("Wallet Recharged", Colors.green, Colors.white),
                      )
                    : showToast("Please enter a minimum amount of ₹30");
              },
              child: const Text("Add"),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> _updateWallet(int amount) async => PaymentService.instance.openCheckout(amount);
}
