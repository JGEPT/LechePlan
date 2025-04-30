import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:go_router/go_router.dart';
import 'package:lecheplan/providers/theme_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(gradient: orangeGradient),
        child: Column(
          children: [
            // header - greeting, notifs, and avatar
            headerContent(),

            //white body container - contains the main stuff
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: pinkishBackgroundColor,
                ),
                child: SingleChildScrollView(child: Column(children: [
                      
                    ],
                  )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container headerContent() {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 40, bottom: 20),
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //Greetings Text
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello, Username!",
                style: TextStyle(
                  color: lighttextColor,
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),

              Text(
                "Ready to plan your next sweet activity?",
                style: TextStyle(
                  color: lighttextColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          //notifications button
          Row(
            spacing: 2,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                  size: 35,
                ),
              ),

              CircleAvatar(
                backgroundImage: AssetImage('assets/images/sampleAvatar.jpg'),
                radius: 22,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
