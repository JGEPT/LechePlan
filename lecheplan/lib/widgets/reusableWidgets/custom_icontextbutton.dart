import 'package:flutter/material.dart';
import 'package:lecheplan/providers/theme_provider.dart';

class CustomIconTextButton extends StatelessWidget {
  final String label;
  final IconData buttonIcon;
  final double iconSize;

  const CustomIconTextButton({
    super.key,
    required this.label,
    required this.buttonIcon,
    required this.iconSize,
  });

  void goToPage() {
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded( //expanded to make sure it covers everything it can horizontally 
      child: Material( 
        color: lightGreyColor,
        borderRadius: BorderRadius.circular(20),
        child: InkWell( //adds that animation when pressed
          onTap: goToPage,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                //icon button part
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: orangeAccentColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(buttonIcon, color: Colors.white, size: iconSize),
                ),
                SizedBox(width: 10), //spacing between icon and text
                //label text
                Text(
                  label,
                  style: TextStyle(
                    color: darktextColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
