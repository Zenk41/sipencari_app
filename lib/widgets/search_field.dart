import 'package:flutter/material.dart';
import 'package:sipencari_app/shared/shared.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    Key? key,
    required this.hint,
    this.icon,
    this.onChange,
  }) : super(key: key);

  final String hint;
  final IconData? icon;
  final Function(String)? onChange;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: (icon == null)
          ? TextFormField(
              onChanged: onChange,
         
              textInputAction: TextInputAction.search,
              maxLines: 1,
              decoration: InputDecoration(
                hintText: hint,
                fillColor: Colors.white,
                filled: true,
                contentPadding: const EdgeInsets.all(8.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: Colors.black38,
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: Colors.black38,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: grey3Color,
                    width: 1,
                  ),
                ),
              ),
            )
          : TextFormField(
              onChanged: onChange,
          
              textInputAction: TextInputAction.search,
              keyboardType: TextInputType.text,
              maxLines: 1,
              decoration: InputDecoration(
                hintText: hint,
                fillColor: Colors.white,
                filled: true,
                prefixIcon: Icon(
                  icon,
                  color: primaryColor,
                ),
                contentPadding: const EdgeInsets.all(8.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: Colors.black38,
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: Colors.black38,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: grey3Color,
                    width: 1,
                  ),
                ),
              ),
            ),
    );
  }
}
