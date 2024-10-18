import 'package:easypg/services/api_handler.dart';
import 'package:easypg/utils/app_keys.dart';
import 'package:easypg/utils/styles.dart';
import 'package:easypg/utils/tools.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // assuming Firestore for fetching payments
import 'package:intl/intl.dart'; // for formatting epoch time

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  Future<List<Map<String, dynamic>>> fetchPayments() async {
    // Fetching the payments data, assuming Firestore
    QuerySnapshot snapshot = await ApiHandler.instance.paymentHistory();

    return snapshot.docs.map((doc) {
      return {
        'id': doc.id,
        AppKeys.isCredit: doc[AppKeys.isCredit] ?? false,
        AppKeys.amount: doc['amount'],
        'timestamp': int.parse(doc.id), // Assuming document ID is the milliseconds epoch
      };
    }).toList();
  }

  Future<void> _refreshData() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            CupertinoIcons.arrowtriangle_left_fill,
            color: getOnPrimary(context),
          ),
        ),
        title: Text('Payment History',
            style: montserrat.copyWith(color: getOnPrimary(context), fontWeight: FontWeight.bold)),
        backgroundColor: getPrimary(context),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchPayments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Unable to fetch payments', style: montserrat));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No payment history available', style: montserrat));
          }

          final payments = snapshot.data!;

          return RefreshIndicator(
            onRefresh: _refreshData,
            edgeOffset: 50, // Edge offset for modern look
            color: Color(0xFFFF4B15),
            child: ListView.builder(
              itemCount: payments.length,
              itemBuilder: (context, index) {
                final payment = payments[index];
                final bool isCredit = payment[AppKeys.isCredit];
                final int amount = payment[AppKeys.amount];
                final DateTime date = DateTime.fromMillisecondsSinceEpoch(payment['timestamp']);

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Icon(
                        isCredit ? Icons.arrow_circle_up : Icons.arrow_circle_down,
                        color: isCredit ? Colors.green : Colors.red,
                        size: 32.sp,
                      ),
                      title: Text(
                        '${isCredit ? 'Credit' : 'Debit'} - ₹ ${amount.toStringAsFixed(2)}',
                        style: montserrat.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        DateFormat('dd MMM yyyy, hh:mm a').format(date),
                        style: montserrat,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
