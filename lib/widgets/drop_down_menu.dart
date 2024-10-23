import 'package:flutter/material.dart';

class DropDownIconButton extends StatelessWidget {
  final List<String> categories;
  final void Function(String) onSelected;
  List<String> selectedValues = [];

  DropDownIconButton(
      {super.key,
      required this.categories,
      required this.onSelected,
      this.selectedValues = const []});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      elevation: 1,
      padding: EdgeInsets.zero,
      offset: const Offset(1, 45),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      icon: Container(
        padding: const EdgeInsets.all(5),
        child: const Icon(
          Icons.arrow_drop_down_rounded,
          // Customize icon color
          size: 24.0, // Customize icon size
        ),
      ),
      itemBuilder: (BuildContext context) {
        return categories
            .where((e) => !selectedValues.contains(e))
            .toList()
            .map((String value) {
          return PopupMenuItem<String>(
            value: value,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                value,
              ),
            ),
          );
        }).toList();
      },
      onSelected: onSelected,
    );
  }
}
