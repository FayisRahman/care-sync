import 'package:caresync/widgets/expanded_button.dart';
import 'package:flutter/material.dart';

class ItemData {
  int beforeFilterIndex;
  int index;
  bool isExpanded;
  String itemName;

  ItemData(
    this.beforeFilterIndex,
    this.index,
    this.isExpanded,
    this.itemName,
  );
}

class ExpandableCard extends StatelessWidget {
  final ItemData item;
  final void Function() onTap;
  final BuildContext mainContext;
  final List<Widget> expandedChildren;

  ExpandableCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.mainContext,
    required this.expandedChildren,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 450), // Smoother animation
      curve: Curves.easeInOut, // Natural easing effect
      child: AnimatedContainer(
        padding: const EdgeInsets.all(0),
        duration: const Duration(milliseconds: 450),
        // Smoother animation
        curve: Curves.easeInOut,
        // Natural easing effect
        margin: const EdgeInsets.all(15),
        // Margin for all rows
        decoration: item.isExpanded
            ? BoxDecoration(
                color: Colors.grey[200], // Background color for expanded row
                borderRadius: BorderRadius.circular(10.0), // Rounded corners
              )
            : null,
        // Remove decoration for collapsed rows
        child: Column(
          children: [
            InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item.itemName),
                    AnimatedRotation(
                      duration: Duration(milliseconds: 1000),
                      turns: item.isExpanded ? 0.5 : 0, // 0.5 = 180 degrees
                      child: Icon(
                        Icons.keyboard_arrow_down,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (item.isExpanded)
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: expandedChildren),
              ),
          ],
        ),
      ),
    );
  }
}
