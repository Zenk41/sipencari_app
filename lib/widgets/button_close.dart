import 'package:flutter/material.dart';
import 'package:sipencari_app/shared/shared.dart';

class ButtonClose extends StatelessWidget {
  const ButtonClose({Key? key, required this.label, required this.colorisi, required this.onClicked,}) : super(key: key);
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(
              color: colorisi
            )
          )
        ),
        onPressed: onClicked,
        child: Text(
          label,
          style: mediumTextStyle.copyWith(color: primaryColor)
        ),
      ),
    );
  }
}