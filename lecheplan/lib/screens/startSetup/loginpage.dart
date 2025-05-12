import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:go_router/go_router.dart';
import 'package:lecheplan/providers/theme_provider.dart';

//widget imports
import 'package:lecheplan/widgets/reusableWidgets/custom_filledbutton.dart';
import 'package:lecheplan/widgets/reusableWidgets/custom_filledinputfield.dart';
import 'package:lecheplan/widgets/reusableWidgets/custom_filledpasswordfield.dart';
import 'package:lecheplan/widgets/reusableWidgets/custom_backbutton.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(top: 40, bottom: 20, right: 40, left: 40),
        child: Stack(
          children: const [
            Padding(padding: EdgeInsets.symmetric(vertical: 30, horizontal: 0), child: Custombackbutton(destinationString: '/')),
            _LoginContent(),
          ],
        ),
      ),
    );
  }
}

//all the primary content of the page
class _LoginContent extends StatelessWidget {
  const _LoginContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        _HeaderText(),
        SizedBox(height: 15),
        _SubHeaderText(),
        SizedBox(height: 30),
        _InputFields(),
        SizedBox(height: 30),
        _LoginButton(),
        SizedBox(height: 20),
        _SignUpRichText(),
      ],
    );
  }
}

//TEXT! -------------------------------------------------------------
class _HeaderText extends StatelessWidget {
  const _HeaderText();

  @override
  Widget build(BuildContext context) {
    return Text(
      "Login",
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 30,
        height: 1.0,
        color: orangeAccentColor,
      ),
    );
  }
}

class _SubHeaderText extends StatelessWidget {
  const _SubHeaderText();

  @override
  Widget build(BuildContext context) {
    return Text(
      "Welcome back! Let's whip up\nsome more sweet plans.",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: darktextColor,
        height: 1.0,
      ),
    );
  }
}
//TEXT! -------------------------------------------------------------

//INPUT FIELDS ------------------------------------------------------
class _InputFields extends StatelessWidget {
  const _InputFields();

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 15,
      children: [
        CustomFilledInputField(
          inputFontColor: darktextColor,
          fillColor: lightAccentColor,
          labelText: "Email or Username",
          labelFontColor: darktextColor,
        ),
        CustomFilledPasswordField(
          inputFontColor: darktextColor,
          fillColor: lightAccentColor,
          labelText: "Password",
          labelFontColor: darktextColor,
        ),
      ],
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton();

  @override
  Widget build(BuildContext context) {
    return FilledButtonDefault(
      buttonHeight: 50,
      buttonLabel: "Log In",
      pressAction: () => context.go('/mainhub'),
    );
  }
}

//INPUT FIELDS ------------------------------------------------------

//pressable text using ontap recognizer yipee 
class _SignUpRichText extends StatelessWidget {
  const _SignUpRichText();

  @override
  Widget build(BuildContext context) {
    return RichText(     
      textScaler: TextScaler.linear(0.8),         
      text: TextSpan(
        text: "Don't have an account yet? ",
        style: TextStyle(
          fontFamily: 'Quicksand',
          color: darktextColor,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),

        children: [
          TextSpan(
            text: "Sign Up",                    
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: orangeAccentColor,
              fontSize: 16,
              fontWeight: FontWeight.w700,                      
            ),
            recognizer: TapGestureRecognizer() 
              ..onTap = () => context.go('/signup'),
          )
        ]

      )
    );
  }
}
