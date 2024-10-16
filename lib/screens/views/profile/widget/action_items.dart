import 'package:easypg/screens/views/profile/payment_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class ActionItems extends StatelessWidget {
  const ActionItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const FaIcon(FontAwesomeIcons.clockRotateLeft),
          title: const Text("Payment History"),
          subtitle: const Text("View your past payments and manage upcoming ones."),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentHistoryScreen(),));
          },
        ),
        Divider(height: 20.h),
        ListTile(
          leading: const FaIcon(FontAwesomeIcons.headset),
          title: const Text("Contact Support"),
          onTap: () {
            // Navigate to support page
          },
        ),
      ],
    );
  }
}
