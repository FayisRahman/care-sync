import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/constants.dart';

class DashboardCard extends StatelessWidget {

  final Widget child;
  final VoidCallback onTap;
  final String title;
  const DashboardCard({super.key, required this.child, required this.onTap, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xffd2d2d2), width: 1.9),
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: kShadowGrey,
              spreadRadius: 0,
              blurRadius: 0,
              offset: const Offset(0, 6), // shadow direction: bottom right
            ),
          ],
        ),
        child: Material(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: Colors.white,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 9),
              child: Row(
                children: [
                  Flexible(child: child),
                  Flexible(flex:4,child: Center(child: Text(title),)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
