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
import 'package:lecheplan/models/group_model.dart';

//services imports
import 'package:lecheplan/services/plans_services.dart';
import 'package:lecheplan/services/groups_services.dart';

final Logger _homePageLogger = Logger('homePageLogger');

class Mainhubpage extends StatefulWidget {
  const Mainhubpage({super.key});

  @override
  State<Mainhubpage> createState() => _MainhubpageState();
}

class _MainhubpageState extends State<Mainhubpage> {
  List<Plan> plans = [];
  List<Group> groups = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPlans();
    _loadGroups();
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

  Future<void> _loadGroups() async {
    try {
      final groupMaps = await fetchAllGroups();
      List<Group> loadedGroups = [];
      for (final groupMap in groupMaps) {
        final groupId = groupMap['group_id'] ?? groupMap['groupID'];
        // Fetch member count and member names for each group
        final memberCount = await fetchGroupMemberCount(groupId);
        final members = await fetchGroupMembers(groupId);
        final memberNames =
            members.map((m) => m['username'] as String? ?? '').toList();
        loadedGroups.add(
          Group(
            groupID: groupId,
            groupName: groupMap['groupname'] ?? groupMap['groupName'] ?? '',
            groupProfile: groupMap['group_profile'] ?? '',
            memberCount: memberCount,
            members: memberNames,
            // Optionally set activity if available
          ),
        );
      }
      setState(() {
        groups = loadedGroups;
      });
    } catch (error) {
      _homePageLogger.warning('Error loading groups: $error');
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
      if (planData.containsKey('date') &&
          (planData.containsKey('time') ||
              planData.containsKey('start_time'))) {
        String dateStr = planData['date'];
        String timeStr =
            planData['time'] ?? planData['start_time'] ?? '00:00:00';
        planDateTime = DateTime.parse('${dateStr}T${timeStr}');
      } else if (planData.containsKey('planDateTime')) {
        planDateTime = DateTime.parse(planData['planDateTime']);
      } else {
        planDateTime = DateTime.parse(
          planData['date'] ?? DateTime.now().toIso8601String(),
        );
      }

      // Extract participants (usernames) and profilePhotoUrls from plan_participants
      List<String> participants = [];
      List<String> profilePhotoUrls = [];
      if (planData['plan_participants'] != null &&
          planData['plan_participants'] is List) {
        for (final p in planData['plan_participants']) {
          final user = p['users'];
          if (user != null) {
            if (user['username'] != null) participants.add(user['username']);
            if (user['profile_photo_url'] != null &&
                user['profile_photo_url'].toString().isNotEmpty) {
              profilePhotoUrls.add(user['profile_photo_url']);
            }
          }
        }
      }

      return Plan(
        planID:
            planData['id']?.toString() ?? planData['plan_id']?.toString() ?? '',
        title: planData['title'] ?? 'Untitled Plan',
        category: planData['category'] ?? 'General',
        planDateTime: planDateTime,
        participants: participants,
        tags:
            planData['tags'] != null ? List<String>.from(planData['tags']) : [],
        profilePhotoUrls: profilePhotoUrls,
      );
    }).toList();
  }

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  //switch to profile tab when profile is pressed
  void goToProfileTab() {
    setState(() {
      _selectedIndex = 3;
    });
  }

  void goToPlans() {
    setState(() {
      _selectedIndex = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = <Widget>[
      //home page
      HomePage(
        plans: plans,
        isLoading: isLoading,
        onProfileTap: goToProfileTab,
        onNavigateToPlans: goToPlans,
      ),
      PeoplePage(
        onProfileTap: goToProfileTab, 
        groups: groups
      ),
      PlansPage(
        plans: plans, 
        isLoading: isLoading
      ),
      ProfilePage(),
    ];

    return Stack(
      children: [
        _BackgroundContainer(
          widgetOptions: widgetOptions,
          selectedIndex: _selectedIndex,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: BottomNavigationBar(
            selectedItemColor: orangeAccentColor,
            unselectedItemColor: unselectedGreyColor.withAlpha(180),
            selectedLabelStyle: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w700,
            ),
            unselectedLabelStyle: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w600,
            ),
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home_filled),
                label: 'HOME',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people_rounded),
                label: 'PEOPLE',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month_rounded),
                label: 'PLANS',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded),
                label: 'PROFILE',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ),
      ],
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
        child: Stack(children: [widgetOptions.elementAt(_selectedIndex)]),
      ),
    );
  }
}
