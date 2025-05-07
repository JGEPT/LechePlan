import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lecheplan/providers/theme_provider.dart';

//model imports
import 'package:lecheplan/models/interestoptions.dart';

//widget imports
import 'package:lecheplan/widgets/reusableWidgets/custom_filledbutton.dart';
import 'package:lecheplan/widgets/modelWidgets/interests_pill.dart';

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

                  const SizedBox(height: 10),

                  //list of pills
                  listofPills(),

                  //button
                  SafeArea(
                    bottom: false,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: FilledButtonDefault(
                        buttonHeight: 50,
                        buttonLabel: "Done!",
                        pressAction: () {
                          context.go('/mainhub');
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Expanded listofPills() {
    return Expanded(
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Wrap(
              spacing: 5,
              runSpacing: 7,
              alignment: WrapAlignment.center,
              children:
                  interestsAndHobbies
                      .map((interest) => InterestsPill(item: interest))
                      .toList(),
            ),
          ),

          //top fade for scroll
          Align(
            alignment: Alignment.topCenter,
            child: IgnorePointer(
              child: Container(
                height: 10,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      pinkishBackgroundColor,
                      pinkishBackgroundColor.withAlpha(0),
                    ],
                  ),
                ),
              ),
            ),
          ),

          //bottom fade for scroll
          Align(
            alignment: Alignment.bottomCenter,
            child: IgnorePointer(
              child: Container(
                height: 10,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      pinkishBackgroundColor.withAlpha(0),
                      pinkishBackgroundColor,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
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
                  text: "Share ",
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
