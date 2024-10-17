import 'package:easypg/utils/app_keys.dart';
import 'package:easypg/utils/tools.dart';
import 'package:flutter/material.dart';
import 'package:easypg/utils/styles.dart';
import 'package:easypg/utils/colors.dart';
import 'package:easypg/services/api_handler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WalletSection extends StatelessWidget {
  final VoidCallback onAddMoney;

  const WalletSection({super.key, required this.onAddMoney});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Wallet Balance",
          style: montserrat.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: StreamBuilder(
                stream: ApiHandler.instance.walletStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildText("Loading...");
                  }
                  if (snapshot.hasError || !snapshot.hasData || !snapshot.requireData.exists) {
                    return _buildText("Unable to Fetch Balance");
                  }
                  logEvent(snapshot.requireData.data());
              
                  return _buildText("₹${snapshot.requireData.get(AppKeys.currentBalance) ?? ""}");
                },
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: myOrange,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: onAddMoney,
              child: Text(
                "Add Money",
                style: montserrat.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        Text(
          "* This Amount is Non-Refundable",
          style: montserrat.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Text _buildText(String text) {
    return Text(
      text,
      style: montserrat.copyWith(
        color: myOrange,
        fontWeight: FontWeight.bold,
        fontSize: 18.sp,
      ),
    );
  }
}
