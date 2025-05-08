import 'dart:convert';
import 'package:lecheplan/widgets/reusableWidgets/custom_icontextbutton.dart';
import 'package:logging/logging.dart';

import 'package:flutter/material.dart';
import 'package:lecheplan/providers/theme_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

//model imports
import 'package:lecheplan/models/plan_model.dart';

//widget imports
import 'package:lecheplan/widgets/modelWidgets/upcomingplans_card.dart';
import 'package:lecheplan/widgets/reusableWidgets/custom_filledbutton.dart';

final Logger _homepageLogger = Logger('homePageLogger');

Future<List<Plan>> loadPlans() async {
  final String jsonString = await rootBundle.loadString(
    'assets/data/plans.json',
  );
  final data = jsonDecode(jsonString);

  //convert the List<dynamic> to a List<Plan> and return
  return List<Plan>.from(data.map((json) => Plan.fromJson(json)));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Plan> plans = []; //initialize plans as an empty list

  @override
  void initState() {
    super.initState();
    loadPlans().then((loadedPlans) {
      _homepageLogger.info('Loaded Plans: ${loadedPlans.length}');
      loadedPlans.sort((a, b) => a.planDateTime.compareTo(b.planDateTime));
      setState(() {
        plans = loadedPlans;
      });
    });
  }

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
            mainContainer(),
          ],
        ),
      ),
    );
  }

  Expanded mainContainer() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(20),
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
            spacing: 15,
            children: [
              //coming up items
              comingUpSection(),

              //suggested for you section
              Column(
                spacing: 8,
                mainAxisSize: MainAxisSize.max,
                children: [
                  //coming up header
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Suggested For You',
                      style: TextStyle(
                        color: darktextColor.withValues(alpha: (255 * 0.2)),
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  //2 buttons - add peopel and activity
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    spacing: 8,
                    children: [
                      //button 1 - add people takes you to the people page (add friend or group)
                      CustomIconTextButton(
                        label: 'Add\nPeople',
                        iconSize: 30,
                        buttonIcon: Icons.group_add_outlined,
                      ),
                      //button 2 - add activity takes you to the plans page (add activity)
                      CustomIconTextButton(
                        label: 'Add\nActivity',
                        iconSize: 30,
                        buttonIcon: Icons.edit_calendar_outlined,
                      ),
                    ],
                  ),

                  //2 buttons - recommend and reload recommendation
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    spacing: 8,
                    children: [
                      CustomIconTextButton(
                        label: 'Recommend an Activity!',
                        iconSize: 25,
                        buttonIcon: Icons.lightbulb_outline_rounded,
                      ),

                      //refresh button - inkwell for the funny clicky
                      Material(
                        color: orangeAccentColor,
                        borderRadius: BorderRadius.circular(15),
                        child: InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            padding: EdgeInsets.all(17),
                            child: Icon(
                              Icons.refresh_rounded,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  
                  //bottom text 
                  Text(
                    'or try the recomendations below!',
                    style: TextStyle(
                      color: darktextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600                      
                    ),
                  )

                ],                              
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column comingUpSection() {
    return Column(
      spacing: 8,
      mainAxisSize: MainAxisSize.max,
      children: [
        //coming up header
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Coming Up',
            style: TextStyle(
              color: darktextColor.withValues(alpha: (255 * 0.2)),
              fontSize: 25,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        //upcoming plans card - 0 and 1 since it only shows the first 2 most upcomng
        UpcomingplansCard(currentPlan: plans[0]),
        UpcomingplansCard(currentPlan: plans[1]),

        //the see all button that will take you to the plans page
        Customfilledbutton(
          buttonHeight: 25,
          buttonWidth: double.infinity,
          buttonFillColor: orangeAccentColor,
          buttonRadius: 20,
          textColor: lighttextColor,
          buttonLabel: 'See All >',
          pressAction: () {}, //make it go to plans page
        ),
      ],
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
