import 'package:flutter/material.dart';
import 'package:sipencari_app/shared/shared.dart';
import 'package:sipencari_app/widgets/button_close.dart';
import 'package:sipencari_app/widgets/button_confirm.dart';
import 'package:badges/badges.dart' as badges;

class PopUp extends StatelessWidget {
  final String labelButton;
  final Color colorButton;
  final VoidCallback onClicked;
  final String labelButton2;
  final Color titleColor;
  final String contentApproval;
  final Widget? widgets;
  const PopUp(
      {Key? key,
      required this.labelButton,
      required this.colorButton,
      required this.onClicked,
      required this.titleColor,
      required this.contentApproval,
      required this.labelButton2,
      this.widgets})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double heightt = MediaQuery.of(context).size.height;
    double widthh = MediaQuery.of(context).size.width;
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: SizedBox(
        height: heightt * 250 / 700,
        width: widthh * 320 / 360,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  top: heightt * 5 / 800,
                  bottom: heightt * 5 / 800,
                  left: widthh * 10 / 360,
                  right: widthh * 10 / 360),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: widthh * 10 / 360,
                    vertical: heightt * 10 / 800),
                child: Row(
                  children: <Widget>[
                    SizedBox(height: heightt * 25 / 360),
                    Expanded(
                      child: Text(
                        contentApproval,
                        style: mediumTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            widgets!,
            SizedBox(height: heightt * 25 / 360),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: widthh * 10 / 360, vertical: heightt * 10 / 800),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: ButtonClose(
                          label: labelButton,
                          colorisi: primaryColor,
                          onClicked: () {
                            Navigator.pop(context);
                          })),
                  SizedBox(width: widthh * 10 / 360),
                  Expanded(
                      child: ButtonConfirm(
                          label: labelButton2,
                          colorisi: primaryColor,
                          onClicked: onClicked)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
