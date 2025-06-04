import 'package:flutter/material.dart';
import 'package:lecheplan/providers/theme_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart'; //for adding logs instead of pritning

//widget imports

//page imports
import 'package:lecheplan/screens/mainPages/homePage/homepage.dart';
import 'package:lecheplan/screens/mainPages/peoplePage/peoplepage.dart';
import 'package:lecheplan/screens/mainPages/plansPage/planspage.dart';
import 'package:lecheplan/screens/mainPages/profilePage/profilepage.dart';

//model imports 
import 'package:lecheplan/models/plan_model.dart';

//services imports
import 'package:lecheplan/services/plans_services.dart';

final Logger _homePageLogger = Logger('homePageLogger');

class Mainhubpage extends StatefulWidget {
  const Mainhubpage({super.key});

  @override
  State<Mainhubpage> createState() => _MainhubpageState();
}

class _MainhubpageState extends State<Mainhubpage> {
  List<Plan> plans = [];
  bool isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadPlans();
  }

  Future<void> _loadPlans() async {
    try {
      setState(() {
        isLoading = true;
      });
      
      // fetch data from services 
      List<Map<String, dynamic>> userPlansDB = await fetchAllUserPlans();
      List<Plan> processedPlans = processPlans(userPlansDB);
      
      setState(() {
        plans = processedPlans;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      _homePageLogger.warning('Error loading plans: $error');
    }
  }

  List<Plan> processPlans(List<Map<String, dynamic>> plansList) {
    // convert database data to Plan objects
    List<Plan> processedPlans = _convertToPlanObjects(plansList);
    return processedPlans.isNotEmpty ? processedPlans : [];
  }

  List<Plan> _convertToPlanObjects(List<Map<String, dynamic>> plansList) {
    return plansList.map((planData) {
      DateTime planDateTime;
      if (planData.containsKey('date') && planData.containsKey('time')) {
        String dateStr = planData['date']; 
        String timeStr = planData['time'] ?? '00:00:00'; //check if there even is a time 
        planDateTime = DateTime.parse('${dateStr}T${timeStr}');
      } else if (planData.containsKey('planDateTime')) {
        // If there's already a combined datetime field
        planDateTime = DateTime.parse(planData['planDateTime']);
      } else {
        // fallback to just date if no other option
        planDateTime = DateTime.parse(planData['date'] ?? DateTime.now().toIso8601String());
      }

      return Plan(
        planID: planData['id']?.toString() ?? planData['plan_id']?.toString() ?? '',
        title: planData['title'] ?? 'Untitled Plan',
        category: planData['category'] ?? 'General',
        planDateTime: planDateTime,
        participants: planData['participants'] != null ? List<String>.from(planData['participants']) : [],
        tags: planData['tags'] != null ? List<String>.from(planData['tags']) : [],
        avatarAssets: [],
      );
    }).toList();
  }

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Add this method to switch to the Profile tab
  void goToProfileTab() {
    setState(() {
      _selectedIndex = 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = <Widget> [
      //home page
      HomePage(
        plans: plans,
        isLoading: isLoading,
        onProfileTap: goToProfileTab,
      ),
      PeoplePage(onProfileTap: goToProfileTab),
      PlansPage(),
      ProfilePage(),
    ];

    return Stack(
      children: [
        _BackgroundContainer(widgetOptions: widgetOptions, selectedIndex: _selectedIndex),
        Align(
          alignment: Alignment.bottomCenter,
          child: BottomNavigationBar(        
            selectedItemColor: orangeAccentColor,
            unselectedItemColor: unselectedGreyColor.withAlpha(180),
            selectedLabelStyle: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.w700),
            unselectedLabelStyle: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.w600),
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'HOME', ),
              BottomNavigationBarItem(icon: Icon(Icons.people_rounded), label: 'PEOPLE'),
              BottomNavigationBarItem(icon: Icon(Icons.calendar_month_rounded), label: 'PLANS'),
              BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'PROFILE')
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ),
      ]
    );
  }
}

class _BackgroundContainer extends StatelessWidget {
  const _BackgroundContainer({
    required this.widgetOptions,
    required int selectedIndex,
  }) : _selectedIndex = selectedIndex;

  final List<Widget> widgetOptions;
  final int _selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: pinkishBackgroundColor,
      child: Container(  
        alignment: Alignment.center,
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            widgetOptions.elementAt(_selectedIndex),
          ],
        ),
      ),
    );
  }
}

