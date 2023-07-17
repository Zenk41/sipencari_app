import 'package:flutter/material.dart';
import 'package:sipencari_app/shared/shared.dart';


class LongTextFieldInput extends StatelessWidget {
  const LongTextFieldInput({
    Key? key,
    required this.iconPrefix,
    this.iconSuffix,
    required this.hintText,
    this.obscure,
    this.validate,
    required this.editingController,
    this.maxLength,
    this.minLine,
    this.maxLine,
  }) : super(key: key);

  final Widget iconPrefix;
  final Widget? iconSuffix;
  final String hintText;
  final bool? obscure;
  final String? Function(String?)? validate;
  final TextEditingController editingController;
  final int? maxLength;
  final int? minLine;
  final int? maxLine;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          obscureText: obscure ?? false,
          controller: editingController,
          decoration: InputDecoration(
            focusColor: primaryColor,
            hoverColor: primaryColor,
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
            suffixIcon: iconSuffix,
          ),
          maxLength: maxLength,
          maxLines: maxLine,
          minLines: minLine,
          cursorColor: primaryColor,
          validator: validate,
        ),
        if (validate != null)
          Text(
            validate!(editingController.text) ?? '',
            style: TextStyle(color: Colors.red),
          ),
      ],
    );
  }
}
