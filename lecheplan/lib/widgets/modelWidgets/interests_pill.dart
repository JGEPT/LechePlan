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
      child: IntrinsicWidth( //makes sure it onlky takes up as much as it needs
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
          decoration: BoxDecoration(
            color: isSelected ? orangeAccentColor : greyAccentColor,
            borderRadius: BorderRadius.circular(99),           
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
      ),
    );
  }
}
