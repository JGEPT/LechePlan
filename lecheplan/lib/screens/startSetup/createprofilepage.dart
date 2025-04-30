import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lecheplan/providers/theme_provider.dart';

//widget imports
import 'package:lecheplan/widgets/custom_filledinputfield.dart';
import 'package:lecheplan/widgets/custom_filledbutton.dart';

class Createprofilepage extends StatefulWidget {
  const Createprofilepage({super.key});

  @override
  State<Createprofilepage> createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends State<Createprofilepage> {
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
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                headerText(), //header and subheader

                const SizedBox(height: 25),

                mainInputContents(),
              ],
            ),

            //button
            Align(
              alignment: Alignment.bottomCenter,
              child: FilledButtonDefault(
                buttonHeight: 50,
                buttonLabel: "Done!",
                pressAction: () {
                  context.go('/aboutyou');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column mainInputContents() {
    return Column(
      children: [
        CircleAvatar(
          backgroundImage: AssetImage('assets/images/sampleAvatar.jpg'),
          radius: 60,
        ),

        const SizedBox(height: 25),

        Column(
          spacing: 15,
          children: [
            CustomFilledInputField(
              inputFontColor: darktextColor,
              fillColor: lightAccentColor,
              labelText: "Username",
              labelFontColor: darktextColor,
            ),
            CustomFilledInputField(
              inputFontColor: darktextColor,
              fillColor: lightAccentColor,
              labelText: "First Name",
              labelFontColor: darktextColor,
            ),
            CustomFilledInputField(
              inputFontColor: darktextColor,
              fillColor: lightAccentColor,
              labelText: "Last Name",
              labelFontColor: darktextColor,
            ),

            //idk unsaon pa ni maybe better if we use an actual date selector yipee later na doe
            CustomFilledInputField(
              inputFontColor: darktextColor,
              fillColor: lightAccentColor,
              labelText: "Birthdate",
              labelFontColor: darktextColor,
            ),
          ],
        ),
      ],
    );
  }

  Container headerText() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Text(
            "Create Profile",
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
                  text: "Customize ",
                  style: TextStyle(color: orangeAccentColor),
                ),

                TextSpan(
                  text: "your account\nso people know you!",
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
