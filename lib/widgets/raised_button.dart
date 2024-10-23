import 'package:flutter/material.dart';

import '../constants/constants.dart';


class RaisedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const RaisedButton({super.key, required this.child, required this.onTap,});

  @override
  State<RaisedButton> createState() => _RaisedButtonState();
}

class _RaisedButtonState extends State<RaisedButton> {
  Color color = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        onTap: widget.onTap,
        onTapDown: (_){
          setState(() {
            color = Colors.white54;
          });
        },
        onTapCancel: (){
          setState(() {
            color = Colors.white;
          });
        },
        onTapUp: (_){
            setState(() {
              color = Colors.white;
            });
        },
        child: Container(
          decoration: kButtonDecoration.copyWith(color: color),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(child: widget.child),
          ),
        ),
      ),
    );
  }
}
