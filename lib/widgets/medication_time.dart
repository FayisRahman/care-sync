import 'package:flutter/material.dart';

class MedicationTime extends StatelessWidget {
  const MedicationTime({super.key, required this.hour, required this.minute});

  final int hour;
  final int minute;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        TimeOfDay(
          hour: hour,
          minute: minute,
        ).format(context),
        style: TextStyle(),
      ),
    );
  }
}
