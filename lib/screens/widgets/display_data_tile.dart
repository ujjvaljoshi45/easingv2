import 'package:easypg/utils/styles.dart';
import 'package:flutter/material.dart';

class DisplayData extends StatelessWidget {
  const DisplayData({super.key, required this.title, required this.subtitle});
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: unSelectedOptionTextStyle,
        ),
        Text(subtitle, style: unSelectedOptionTextStyle)
      ],
    );
  }
}