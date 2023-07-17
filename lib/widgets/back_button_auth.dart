import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

import '../shared/shared.dart';

class ButtonFloatIcon extends StatelessWidget {
  const ButtonFloatIcon({super.key, required this.icon, this.onTap});

  final Widget icon;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
        ),
        child: icon,
      ),
      onTap: onTap,
    );
  }
}
