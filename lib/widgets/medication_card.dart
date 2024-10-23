import 'package:flutter/material.dart';
import 'medication_time.dart';

class MedicationCard extends StatelessWidget {
  const MedicationCard(
      {super.key,
      required this.medicationName,
      required this.noOfTimes,
      required this.nextDosage,
      required this.time});

  final String medicationName;
  final int noOfTimes;
  final String nextDosage;
  final List<MedicationTime> time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Medication Name: "),
                  Text(
                    medicationName,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Usage: "),
                  Text(
                    "$noOfTimes/Day",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Next Dosage: "),
                  Text(
                    nextDosage,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.center,
                children: time,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
