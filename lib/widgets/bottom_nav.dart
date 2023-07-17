import 'package:flutter/material.dart';

class BottomNavigationBox extends StatelessWidget {
  final Widget child;
  const BottomNavigationBox({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -15),
            blurRadius: 20,
            color: const Color(0xFFDADADA).withOpacity(0.15),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        border: Border.all(
          width: 0.4,
          color: Colors.grey
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(                                           
          topLeft: Radius.circular(20.0),                                            
          topRight: Radius.circular(20.0),                                           
        ),
        child: SizedBox(
          height: 85,
          width: double.infinity,
          child: child
        ),
      ),
    );
  }
}

class BottomNavigationItem {
  String label;
  String icon;
  BottomNavigationItem(this.label, this.icon);
}