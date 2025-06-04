import 'package:flutter/material.dart';
import 'package:lecheplan/providers/theme_provider.dart';

//widget imports

//page imports
import 'package:lecheplan/screens/mainPages/homePage/homepage.dart';
import 'package:lecheplan/screens/mainPages/peoplePage/peoplepage.dart';
import 'package:lecheplan/screens/mainPages/plansPage/planspage.dart';
import 'package:lecheplan/screens/mainPages/profilePage/profilepage.dart';

class Mainhubpage extends StatefulWidget {
  const Mainhubpage({super.key});

  @override
  State<Mainhubpage> createState() => _MainhubpageState();
}

class _MainhubpageState extends State<Mainhubpage> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // list of 
    final List<Widget> widgetOptions = <Widget> [
      //home page
      HomePage(onProfileTap: () => _onItemTapped(3)),
      PeoplePage(onProfileTap: () => _onItemTapped(3)),
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
    super.key,
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
        child: widgetOptions.elementAt(_selectedIndex)
      ),
    );
  }
}

