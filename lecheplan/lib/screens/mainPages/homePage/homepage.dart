import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lecheplan/providers/theme_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

//model imports
import 'package:lecheplan/models/plan_model.dart';

//widget imports
import 'package:lecheplan/widgets/modelWidgets/upcomingplans_card.dart';

//load json file contents 
Future<void> loadJsonAsset() async { 
  final String jsonString = await rootBundle.loadString('assets/plans.json'); 
  final data = jsonDecode(jsonString); 
}


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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            //coming up header
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Coming Up',
                                style: TextStyle(
                                  color: darktextColor.withValues(
                                    alpha: (255 * 0.2),
                                  ),
                                  fontSize: 25,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),                            
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
