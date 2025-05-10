import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lecheplan/providers/theme_provider.dart';

//widget imports
import 'package:lecheplan/widgets/reusableWidgets/custom_filledinputfield.dart';
import 'package:lecheplan/widgets/reusableWidgets/custom_filledbutton.dart';

class Createprofilepage extends StatelessWidget {
  const Createprofilepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: pinkishBackgroundColor,
        width: double.infinity,
        padding: const EdgeInsets.all(40),
        child: Stack(
          children: const [
            _MainContent(),
            
            _NextButton(),

          ],
        ),
      ),
    );
  }
}

class _MainContent extends StatelessWidget {
  const _MainContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        _HeaderText(),
        SizedBox(height: 25),
        _InputFields(),
      ],
    );
  }
}

class _HeaderText extends StatelessWidget {
  const _HeaderText();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
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

          const SizedBox(height: 10),

          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(
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

class _InputFields extends StatelessWidget {
  const _InputFields();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundImage: const AssetImage('assets/images/sampleAvatar.jpg'),
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
}

class _NextButton extends StatelessWidget {
  const _NextButton();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: FilledButtonDefault(
        buttonHeight: 50,
        buttonLabel: "Next",
        pressAction: () => context.go('/aboutyou'),
      ),
    );
  }
}
