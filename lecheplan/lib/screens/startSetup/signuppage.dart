import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:go_router/go_router.dart';
import 'package:lecheplan/providers/theme_provider.dart';

//widget imports
import 'package:lecheplan/widgets/custom_filledbutton.dart';
import 'package:lecheplan/widgets/custom_filledinputfield.dart';
import 'package:lecheplan/widgets/custom_filledpasswordfield.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: 20, bottom: 20, right: 40, left: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            Column(
              children: [
                Text(
                  "Sign Up",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 30,
                    height: 1.0,
                    color: orangeAccentColor,
                  ),
                ),

                SizedBox(height: 20),

                Text(
                  "New here? Create an account \nand let’s plan something sweet.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: darktextColor.withValues(alpha: (255 * 0.05)),
                    height: 1.0,
                  ),
                ),

                SizedBox(height: 50),

                Column(
                  spacing: 15,
                  children: [
                    CustomFilledInputField(
                      inputFontColor: darktextColor,
                      fillColor: lightAccentColor,
                      labelText: "Email",
                      labelFontColor: darktextColor,
                    ),
                    CustomFilledPasswordField(
                      inputFontColor: darktextColor,
                      fillColor: lightAccentColor,
                      labelText: "Password",
                      labelFontColor: darktextColor,
                    ),
                    CustomFilledPasswordField(
                      inputFontColor: darktextColor,
                      fillColor: lightAccentColor,
                      labelText: "Confirm Password",
                      labelFontColor: darktextColor,
                    ),
                  ],
                ),

                SizedBox(height: 50),
                
                FilledButtonDefault(
                  buttonHeight: 50,
                  buttonLabel: "Sign Up",
                  pressAction: () {context.go('/');},
                ),

                SizedBox(height: 30),
              
                loginRichText(context),
              ],
            ),
          ],
        ),
      ),
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

}
