import 'package:flutter/material.dart';
import 'package:sipencari_app/shared/shared.dart';

class Button extends StatelessWidget {
  const Button(
      {Key? key, required this.color, required this.centerText, this.onPress, required this.bRadius}) : super(key: key);

  final Color color;
  final Widget centerText;
  final Function()? onPress;
  final BorderRadius bRadius;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: color,
          shape:
              RoundedRectangleBorder(borderRadius: bRadius),
        ),
        onPressed: onPress,
        child: centerText);
  }
}

class ButtonWithBorder extends StatelessWidget {
  const ButtonWithBorder(
      {Key? key, required this.color, required this.centerText, this.onPress}): super(key: key);

  final Color color;
  final Widget centerText;
  final Function()? onPress;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: whiteColor,
          side: BorderSide(
            width: 2,
            color: grey3Color,
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        onPressed: onPress,
        child: centerText);
  }
}
