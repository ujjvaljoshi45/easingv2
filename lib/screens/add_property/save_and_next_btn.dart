import 'package:easypg/utils/colors.dart';
import 'package:easypg/utils/styles.dart';
import 'package:flutter/material.dart';

class SaveAndNextBtn extends StatelessWidget {
  const SaveAndNextBtn({super.key, required this.onPressed, required this.msg});
  final void Function()? onPressed;
  final String msg;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(myOrange),
                    shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))),
                onPressed: onPressed,
                child: Text(
                  msg,
                  style:
                      montserrat.copyWith(fontWeight: FontWeight.bold, color: white, fontSize: 16),
                )))
      ],
    );
  }
}
