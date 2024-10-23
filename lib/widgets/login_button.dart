import 'package:flutter/material.dart';


class LoginButton extends StatelessWidget {
  const LoginButton({super.key, required this.icon, required this.onTap,});


  final String icon;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.03, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: const [
              BoxShadow(
                color: Color(0xffbfbfbf),
                spreadRadius: 0,
                blurRadius: 0,
                offset: Offset(0, 4), // shadow direction: bottom right
              ),
          ],
          borderRadius: BorderRadius.circular(6),
        ),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          child: InkWell(
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                  border:
                  Border.all(width: 1.5, color: const Color(0xffd2d2d2)),
                  borderRadius: BorderRadius.circular(6)),
              padding: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(7.0),
                // child: Image.asset("assets/images/$icon"),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
