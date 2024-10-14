import 'package:easypg/utils/colors.dart';
import 'package:easypg/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SaveAndNextBtn extends StatelessWidget {
  const SaveAndNextBtn({super.key, required this.onPressed, required this.msg, this.style});
  final void Function()? onPressed;
  final ButtonStyle? style;
  final String msg;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: ElevatedButton(
                style: style ?? ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(myOrange),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                ),
                onPressed: onPressed,
                child: Text(
                  msg,
                  style: montserrat.copyWith(
                      fontWeight: FontWeight.bold, color: white, fontSize: 16.sp),
                )))
      ],
    );
  }
}
