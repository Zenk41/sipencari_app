import 'package:flutter/material.dart';
import 'package:sipencari_app/shared/shared.dart';

class ButtonConfirm extends StatelessWidget {
  const ButtonConfirm({Key? key, required this.label, required this.colorisi, required this.onClicked,}) : super(key: key);
  final String label;
  final Color colorisi;
  final VoidCallback onClicked;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: 38,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: colorisi,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))
        ),
        onPressed: onClicked,
        child: Text(
          label,
          style: mediumTextStyle.copyWith(color: whiteColor),
        ),
      ),
    );
  }
}