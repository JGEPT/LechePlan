import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lecheplan/providers/theme_provider.dart';

//model imports
import 'package:lecheplan/models/interestoptions.dart';

//widget imports
import 'package:lecheplan/widgets/reusableWidgets/custom_filledbutton.dart';
import 'package:lecheplan/widgets/modelWidgets/interests_pill.dart';

class Aboutyoupage extends StatelessWidget {
  const Aboutyoupage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: pinkishBackgroundColor,
        width: double.infinity,
        padding: const EdgeInsets.all(40),
        child: Stack(
          children: const [
            _MainContent(),
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          _HeaderText(),
          SizedBox(height: 10),
          _InterestsList(),
          _DoneButton(),
        ],
      ),
    );
  }
}

class _HeaderText extends StatelessWidget {
  const _HeaderText();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 30, left: 10 ,right:10, bottom: 10),
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

class _InterestsList extends StatelessWidget {
  const _InterestsList();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Wrap(
              spacing: 5,
              runSpacing: 7,
              alignment: WrapAlignment.center,
              children: interestsAndHobbies
                  .map((interest) => InterestsPill(item: interest, isClickable: true,)).toList(),
            ),
          ),
          const _TopFade(),
          const _BottomFade(),
        ],
      ),
    );
  }
}

class _TopFade extends StatelessWidget {
  const _TopFade();

  @override
  Widget build(BuildContext context) {
    return Align(
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
    );
  }
}

class _BottomFade extends StatelessWidget {
  const _BottomFade();

  @override
  Widget build(BuildContext context) {
    return Align(
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
    );
  }
}

class _DoneButton extends StatelessWidget {
  const _DoneButton();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: FilledButtonDefault(
          buttonHeight: 50,
          buttonLabel: "Done!",
          pressAction: () => context.go('/mainhub'),
        ),
      ),
    );
  }
}
