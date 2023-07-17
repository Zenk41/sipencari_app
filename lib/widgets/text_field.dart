import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:sipencari_app/shared/shared.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/services.dart';

class InputTextField extends StatelessWidget {
  const InputTextField(
      {super.key,
      required this.iconPrefix,
      this.iconSuffix,
      required this.hintText,
      this.obscure = false,
      required this.editingController,
      this.validate,
      this.maxLength});

  final Widget iconPrefix;
  final Widget? iconSuffix;
  final String hintText;
  final bool? obscure;
  final String? Function(String?)? validate;
  final TextEditingController editingController;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscure!,
      validator: validate!,
      controller: editingController,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: smallTextStyle,
        fillColor: grey6Color,
        filled: true,
        prefixIcon: iconPrefix,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        suffixIcon: iconSuffix,
        prefixIconColor:
            MaterialStateColor.resolveWith((Set<MaterialState> states) {
          if (states.contains(MaterialState.focused)) {
            return primaryColor;
          }
          if (states.contains(MaterialState.error)) {
            return Colors.red;
          }
          return grey3Color;
        }),
      ),
      maxLength: maxLength,
    );
  }
}
