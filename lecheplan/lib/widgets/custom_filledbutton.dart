import 'package:flutter/material.dart';

class Customfilledbutton extends StatelessWidget{
  const Customfilledbutton(
    {
      super.key,
      required this.buttonHeight,
      required this.buttonWidth,
      required this.buttonFillColor,
      required this.buttonRadius,
      required this.textColor,
      required this.buttonLabel,
      required this.pressAction,
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