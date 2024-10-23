import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:caresync/widgets/drop_down_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginField extends StatefulWidget {
  final String title;
  final Function(String) onChanged;
  bool needHiding;
  bool isError;
  final String errorText;
  void Function()? onDateChanged;
  TextEditingController? controller;
  bool readOnly;
  Widget? child;

  LoginField({
    super.key,
    required this.title,
    required this.onChanged,
    this.controller,
    this.needHiding = false,
    this.isError = false,
    required this.errorText,
    this.readOnly = false,
    this.onDateChanged,
    this.child,
  });

  @override
  State<LoginField> createState() => _LoginFieldState();
}

class _LoginFieldState extends State<LoginField> {
  bool isHidden = true;

  IconData icon = Icons.visibility_off_outlined;

  void hidden() {
    setState(() {
      if (isHidden) {
        icon = Icons.visibility_off_outlined;
      } else {
        icon = Icons.visibility_outlined;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontFamily: 'Roboto',
              fontSize: 14,
            ),
          ),
          const SizedBox(
            height: 3,
          ),
          TextField(
            obscureText: widget.needHiding && isHidden,
            onChanged: widget.onChanged,
            controller: widget.controller,
            readOnly: widget.readOnly,
            maxLength: widget.title == "Phone Number" ? 10 : null,
            keyboardType: widget.title == "Phone Number"
                ? TextInputType.number
                : TextInputType.text,
            inputFormatters: [
              //if widget.title is phone number then allow digits only otherwise allow all alphabets and digits
              if (widget.title == "Phone Number")
                FilteringTextInputFormatter.digitsOnly,
            ],
            textInputAction: TextInputAction.newline,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
            ),
            decoration: InputDecoration(
              counterStyle: const TextStyle(
                color: Colors.transparent,
              ),
              counterText: "",
              suffixIcon: widget.title == "Password"
                  ? IconButton(
                      onPressed: () {
                        isHidden = !isHidden;
                        hidden();
                      },
                      icon: Icon(icon),
                    )
                  : widget.title == "DOB"
                      ? IconButton(
                          icon: const Icon(Icons.calendar_month),
                          onPressed: widget.onDateChanged!,
                        )
                      : widget.child,
              errorText:
                  widget.isError ? "Incorrect ${widget.errorText}" : null,
              contentPadding: const EdgeInsets.fromLTRB(12, 13, 12, 13),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: Colors.black,
                  width: 0.8,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
