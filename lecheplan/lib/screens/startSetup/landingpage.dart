import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:go_router/go_router.dart';
import 'package:lecheplan/providers/theme_provider.dart';

//widget imports
import 'package:lecheplan/widgets/custom_filledbutton.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // HEADER TEXT
            RichText(
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
            ),

            SizedBox(height: 20),

            // SUB HEADER TEXT
            Text(
              "Plan out your next hangout session \nwith your friends, or let us do it for you!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: darktextColor.withValues(alpha: (255 * 0.05)),
                height: 1.0,
              ),
            ),

            SizedBox(height: 25),

            Customfilledbutton(
              buttonHeight: 50,
              buttonWidth: double.infinity,
              buttonFillColor: orangeAccentColor,
              buttonRadius: 10,
              textColor: Colors.white,
              buttonLabel: "Count Me In!",
              pressAction: () {},
            ),

            SizedBox(height: 25),

            RichText(              
              text: TextSpan(
                text: "Already have an account? ",
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  color: darktextColor,
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
                      context.go('/');
                    }
                  )
                ]
              )
            ),

            SizedBox(height: 40),

          ],
        ),
      ),
    );
  }
}
