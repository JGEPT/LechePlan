import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lecheplan/providers/theme_provider.dart';

//widget imports
import 'package:lecheplan/widgets/custom_filledbutton.dart';

class Aboutyoupage extends StatefulWidget {
  const Aboutyoupage({super.key});

  @override
  State<Aboutyoupage> createState() => _AboutyoupageState();
}

class _AboutyoupageState extends State<Aboutyoupage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(      
      body: Container(
        color: pinkishBackgroundColor,
        width: double.infinity,
        padding: EdgeInsets.all(40),
      
        child: Stack(
          children: [
           //main content 
            Center(
              child: Column(              
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  headerText(), //header and subheader                                  
                ],
              ),
            ),

            //button
            Align(
              alignment: Alignment.bottomCenter,
              child: FilledButtonDefault(
                buttonHeight: 50,
                buttonLabel: "Done!",
                pressAction: () {
                  context.go('/mainhub');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container headerText() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Text(
            "About you",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 30,
              height: 1.0,
              color: orangeAccentColor,
            ),
          ),

          SizedBox(height: 10),

          //subtitle
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.0,
              ),
              children: [
                TextSpan(
                  text: "Share  ",
                  style: TextStyle(color: orangeAccentColor),
                ),

                TextSpan(
                  text: "your interests and hobbies",
                  style: TextStyle(color: darktextColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
