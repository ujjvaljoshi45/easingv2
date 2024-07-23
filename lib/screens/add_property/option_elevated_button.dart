import 'package:easypg/utils/styles.dart';
import 'package:flutter/material.dart';

class OptionElevatedButton extends StatelessWidget {
  const OptionElevatedButton(
      {super.key,
        required this.isSelected,
        required this.text,
        required this.onPressed});
  final bool isSelected;
  final String text;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style:
      isSelected ? selectedOptionButtonStyle : unSelectedOptionButtonStyle,
      child: Text(
        text,
        style: isSelected ? selectedOptionTextStyle : unSelectedOptionTextStyle,
      ),
    );
  }
}