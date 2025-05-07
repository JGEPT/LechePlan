import 'package:flutter/material.dart';
import 'package:lecheplan/providers/theme_provider.dart';

// this is a completely custom version of the button that can be filled and have a border radius  
class Customfilledbutton extends StatelessWidget{
  const Customfilledbutton(
    {
      super.key,
      required this.buttonHeight, 
      required this.buttonWidth,
      required this.buttonFillColor,
      required this.buttonRadius,
      required this.textColor,
      required this.buttonLabel, // text displayed in button leave as "" if none
      required this.pressAction, //what pressing the button does leave as () {} if none
    }  
  );

  final double buttonHeight;
  final double buttonWidth;
  final Color buttonFillColor;
  final double buttonRadius;
  final Color textColor;
  final String buttonLabel;
  final VoidCallback pressAction;

  @override
  Widget build(BuildContext context) {    
    return Container(      
      width: buttonWidth,
      height: buttonHeight,
      decoration: BoxDecoration(
        color: buttonFillColor,
        borderRadius: BorderRadius.circular(buttonRadius),
      ),

      child: ElevatedButton(
        onPressed: pressAction,
        style: ElevatedButton.styleFrom(                          
          backgroundColor: Colors.transparent, 
          shadowColor: Colors.transparent, 
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(buttonRadius)),
        ),

        child: Text(
          buttonLabel,
          style: TextStyle(
            color: textColor,
            fontSize: buttonHeight * 0.4,
            fontWeight: FontWeight.w700,
          ),
        ),        
      )
    );
  }
}

// THIS BUTTON IS THE MOST COMMONLY USED VERSION
// only need to input the height and the text itself
class FilledButtonDefault extends StatelessWidget{
  const FilledButtonDefault(
    {
      super.key,
      required this.buttonHeight, 
      required this.buttonLabel, // text displayed in button leave as "" if none
      required this.pressAction, //what pressing the button does leave as () {} if none
    }  
  );

  final double buttonHeight;
  final String buttonLabel;
  final VoidCallback pressAction;

  @override
  Widget build(BuildContext context) {    
    return Container(      
      width: double.infinity,
      height: buttonHeight,
      decoration: BoxDecoration(
        color: orangeAccentColor,
        borderRadius: BorderRadius.circular(10),
      ),

      child: ElevatedButton(
        onPressed: pressAction,
        style: ElevatedButton.styleFrom(                          
          backgroundColor: Colors.transparent, 
          shadowColor: Colors.transparent, 
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),

        child: Text(
          buttonLabel,
          style: TextStyle(
            color: lighttextColor,
            fontSize: buttonHeight * 0.4,
            fontWeight: FontWeight.w700,
          ),
        ),        
      )
    );
  }
}