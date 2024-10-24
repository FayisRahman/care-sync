import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class AutoCompleteField extends StatelessWidget {
  final String title;
  final Function(String) onSuggestionSelected;
  final TextEditingController controller;
  final bool isError;
  final List<String> suggestions;
  final String type;
  final Function(String) onChanged;
  final bool isRequired;

  const AutoCompleteField({
    super.key,
    required this.title,
    required this.onSuggestionSelected,
    required this.isError,
    required this.suggestions,
    required this.type,
    required this.onChanged,
    required this.isRequired,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: TypeAheadField(
        controller: controller,
        builder: (BuildContext context, TextEditingController controller,
            FocusNode focusNode) {
          return TextField(
            controller: controller,
            focusNode: focusNode,
            onChanged: onChanged,
            decoration: InputDecoration(
              errorText: isError ? "Please enter a unique category" : null,
              filled: true,
              fillColor: const Color(0xFFE5F0FF),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
              label: Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: Color(0xFFF3F6FF),
                  width: 0.8,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          );
        },
        suggestionsCallback: (String pattern) async {
          // Replace 'suggestions' with your list of strings to suggest from
          return suggestions
              .where((suggestion) =>
                  suggestion.toLowerCase().contains(pattern.toLowerCase()))
              .toList();
        },
        itemBuilder: (BuildContext context, String suggestion) {
          return ListTile(
            title: Text(suggestion),
          );
        },
        onSelected: (val) {
          onSuggestionSelected(val);
        },
        emptyBuilder: (BuildContext context) {
          return isRequired
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "0 - No $type Found",
                    style: const TextStyle(fontSize: 15),
                  ),
                )
              : const SizedBox(); // Replace with your custom text or widget
        },
      ),
    );
  }
}
