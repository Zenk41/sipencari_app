import 'package:flutter/material.dart';
import 'package:sipencari_app/shared/shared.dart';
import 'package:sipencari_app/widgets/button_close.dart';
import 'package:sipencari_app/widgets/button_confirm.dart';

class Alert extends StatelessWidget {
  final String labelButton;
  final Color colorButton;
  final VoidCallback onClicked;
  final String labelButton2;
  final Color titleColor;
  final String contentApproval;
  final String picture;

  const Alert({
    Key? key,
    required this.labelButton,
    required this.colorButton,
    required this.onClicked,
    required this.titleColor,
    required this.contentApproval,
    required this.picture,
    required this.labelButton2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 120.0,
              width: 150.0,
              child: Image.asset(picture),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                contentApproval,
                style: const TextStyle(
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ButtonClose(
                      label: labelButton,
                      colorisi: primaryColor,
                      onClicked: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: ButtonConfirm(
                      label: labelButton2,
                      colorisi: primaryColor,
                      onClicked: onClicked,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

