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
        Positioned.fill(
          child: Image.asset(
            'assets/images/landingPageBG.png',
            fit: BoxFit.cover,
            cacheWidth: (MediaQuery.of(context).size.width * MediaQuery.of(context).devicePixelRatio).toInt(), 
            cacheHeight: (MediaQuery.of(context).size.height * MediaQuery.of(context).devicePixelRatio).toInt(),
            filterQuality: FilterQuality.medium,
          ),
        ),

        //main contents
        Material(
          color: Colors.transparent,
          child: SafeArea(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                
                  const _LargeHeaderText(),
                  const SizedBox(height: 20),
                        
                  const _SubHeaderText(),
          
                  const SizedBox(height: 25),

                  //used thew default button that is big n stuff
                  FilledButtonDefault(
                    buttonHeight: 50,
                    buttonLabel: "Sign Up",
                    pressAction: () => context.go('/signup'),
                  ),
          
                  const SizedBox(height: 25),
          
                  _LoginRichText(context),
          
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ] 
    );
  }
}

class _LargeHeaderText extends StatelessWidget {
  const _LargeHeaderText();

  @override
  Widget build(BuildContext context){
    return FittedBox( //box fit to adjust the size depending on the screen width
      fit: BoxFit.scaleDown,
      child: RichText( //richtext for different color  text in the same lines
        textAlign: TextAlign.center,
        text: TextSpan(
          style: const TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w700,
            fontSize: 30,
            height: 1.0,
          ),
          children:[
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
    );
  }
}

class _SubHeaderText extends StatelessWidget {
  const _SubHeaderText();

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        "Plan out your next hangout session \nwith your friends, or let us do it for you!",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: darktextColor,
          height: 1.0,
        ),
      ),
    );
  }
}

class _LoginRichText extends StatelessWidget{
  final BuildContext context;

  const _LoginRichText(this.context);

  @override
  Widget build(BuildContext context) {
    return RichText(      
      textScaler: TextScaler.linear(0.8),         
      text: TextSpan(
        text: "Already have an account? ",
        style: TextStyle(
          fontFamily: 'Quicksand',
          color: darktextColor,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        children: [
          TextSpan(
            text: "Log In",                    
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: orangeAccentColor,
              fontSize: 15,
              fontWeight: FontWeight.w700,                      
            ),
            recognizer: TapGestureRecognizer() 
              ..onTap = () => context.go('/login'),
          )
        ]
      )
    );
  }
}
