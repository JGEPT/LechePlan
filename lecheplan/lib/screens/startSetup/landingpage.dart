import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:go_router/go_router.dart';
import 'package:lecheplan/providers/theme_provider.dart';

//widget imports
import 'package:lecheplan/widgets/reusableWidgets/custom_filledbutton.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        
        //background image
        Image.asset(
          'assets/images/landingPageBG.png',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),

        //main stuff
        Material(
          color: Colors.transparent,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // HEADER TEXT
                largeHeaderText(),
          
                SizedBox(height: 20),
          
                // SUB HEADER TEXT
                subHeaderText(),
          
                SizedBox(height: 25),
          
                FilledButtonDefault(
                  buttonHeight: 50,
                  buttonLabel: "Sign Up",
                  pressAction: () {context.go('/signup');},
                ),
          
                SizedBox(height: 25),
          
                loginRichText(context),
          
                SizedBox(height: 40),
          
              ],
            ),
          ),
        ),
      ] 
    );
  }

  RichText loginRichText(BuildContext context) {
    return RichText(              
      text: TextSpan(
      text: "Already have an account? ",
      style: TextStyle(
        fontFamily: 'Quicksand',
        color: darktextColor.withValues(alpha: (255 * 0.05)),
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
        
      children: [
        TextSpan(
          text: "Log In",                    
          style: TextStyle(
            decoration: TextDecoration.underline,
            color: orangeAccentColor,
            fontSize: 16,
            fontWeight: FontWeight.w700,                      
          ),
          recognizer: TapGestureRecognizer() 
            ..onTap = () {
            context.go('/login');
          }
        )
      ]
    )
  );
  }

  Text subHeaderText() {
    return Text(
      "Plan out your next hangout session \nwith your friends, or let us do it for you!",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: darktextColor,
        height: 1.0,
      ),
    );
  }

  RichText largeHeaderText() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(
          fontFamily: 'Quicksand',
          fontWeight: FontWeight.w700,
          fontSize: 30,
          height: 1.0,
        ),
        children: [
          TextSpan(
            text: "Turn ",
            style: TextStyle(color: darktextColor),
          ),
          TextSpan(
            text: "Shared Interests",
            style: TextStyle(color: orangeAccentColor),
          ),
          TextSpan(
            text: "\ninto ",
            style: TextStyle(color: darktextColor),
          ),
          TextSpan(
            text: "Shared Memories",
            style: TextStyle(color: orangeAccentColor),
          ),
        ],
      ),
    );
  }
}
