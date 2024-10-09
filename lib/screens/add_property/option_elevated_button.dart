import 'package:easypg/utils/styles.dart';
import 'package:flutter/material.dart';

class OptionElevatedButton extends StatelessWidget {
  const OptionElevatedButton(
      {super.key,
        required this.isSelected,
        required this.text,
        required this.onPressed, this.color});
  final bool isSelected;
  final String text;
  final void Function() onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style:
      isSelected ? selectedOptionButtonStyle.copyWith(backgroundColor: WidgetStatePropertyAll(color ?? Colors.black)) : unSelectedOptionButtonStyle,
      child: Text(
        text,softWrap: true,
        style: isSelected ? selectedOptionTextStyle : unSelectedOptionTextStyle,
      ),
    );
  }
}