import 'package:flutter/material.dart';
import 'package:lecheplan/providers/theme_provider.dart';

class CustomFilledInputField extends StatefulWidget {
  final Color inputFontColor;
  final Color fillColor;
  final String labelText;
  final Color labelFontColor;

  const CustomFilledInputField({
    super.key,
    required this.inputFontColor,
    required this.fillColor,
    required this.labelText,
    required this.labelFontColor,
  });

  @override
  State<CustomFilledInputField> createState() => _CustomFilledInputFieldState();
}

class _CustomFilledInputFieldState extends State<CustomFilledInputField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          focusNode: _focusNode,
          style: TextStyle(color: widget.inputFontColor),
          decoration: InputDecoration(
            labelText: widget.labelText,
            labelStyle: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w600,
              color: darktextColor.withValues(alpha: (255 * 0.1)),
              fontSize: 15
            ),

            filled: true,
            fillColor: widget.fillColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: orangeAccentColor, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
