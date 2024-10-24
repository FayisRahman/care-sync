import 'package:caresync/widgets/text_field.dart';
import 'package:flutter/material.dart';

import 'drop_down_menu.dart';

class DataReportField extends StatelessWidget {
  final TextEditingController typeController;
  final List<String> categories;
  final Function(String) onSelected;
  final Function(String) onChanged;
  final List<String> selectedTypes;

  const DataReportField(
      {super.key,
      required this.typeController,
      required this.categories,
      required this.onSelected,
      required this.onChanged,
      required this.selectedTypes});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        children: [
          Flexible(
            child: LoginField(
              title: "Report type",
              onChanged: (String val) {},
              readOnly: true,
              errorText: "",
              controller: typeController,
              keyboardType: TextInputType.multiline,
              child: DropDownIconButton(
                categories: categories,
                onSelected: onSelected,
                selectedValues: selectedTypes,
              ),
            ),
          ),
          Flexible(
            child: LoginField(
              title: "Report Data",
              keyboardType: TextInputType.number,
              onChanged: onChanged,
              errorText: "",
            ),
          ),
        ],
      ),
    );
  }
}
