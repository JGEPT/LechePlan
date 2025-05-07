import 'package:flutter/material.dart';
import 'package:lecheplan/providers/theme_provider.dart';

class InterestsPill extends StatefulWidget {
  final String item;

  const InterestsPill({
    super.key,
    required this.item,
  });

  @override
  State<InterestsPill> createState() => _InterestsPillState();
}

class _InterestsPillState extends State<InterestsPill> {
  bool isSelected = false;

  void toggleSelection() {
    setState(() {
      isSelected = !isSelected;
    });
  }

  @override
  Widget build(BuildContext context){
    return GestureDetector( //makes sure that something happens when it is pressed.
      onTap: toggleSelection,
      child: Container(
        alignment: Alignment.center,
        height: 35,
        width: widget.item.length * 12,
        decoration: BoxDecoration(
          color: isSelected ? orangeAccentColor : greyAccentColor,
          borderRadius: BorderRadius.circular(99),
          border: Border.all(
            color: lightGreyColor,
            width: isSelected ? 0 : 1.5,
          ),
        ),
        child: Text(
          widget.item,
          style: TextStyle(
            color: isSelected? lighttextColor : darktextColor.withAlpha(200),
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
