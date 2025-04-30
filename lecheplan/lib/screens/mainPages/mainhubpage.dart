import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lecheplan/providers/theme_provider.dart';

//widget imports
import 'package:lecheplan/widgets/custom_filledbutton.dart';

//page imports
import 'package:lecheplan/screens/mainPages/homePage/homepage.dart';

class Mainhubpage extends StatefulWidget {
  const Mainhubpage({super.key});

  @override
  State<Mainhubpage> createState() => _MainhubpageState();
}

class _MainhubpageState extends State<Mainhubpage> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex= index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // list of 
    final List<Widget> _widgetOptions = <Widget> [
      //home page
      HomePage(),

      Text('Index 2: People'),
      Text('Index 3: Plans'),
      Text('Index 4: Profile'),
    ];

    return Stack(
      children: [
        
        Material(
          color: pinkishBackgroundColor,
          child: Container(  
            alignment: Alignment.center,
            width: double.infinity,
            height: double.infinity,
            child: _widgetOptions.elementAt(_selectedIndex)
          ),
        ),

        Align(
          alignment: Alignment.bottomCenter,
          child: BottomNavigationBar(        
            selectedItemColor: orangeAccentColor,
            unselectedItemColor: darktextColor.withValues(alpha: (255 * 0.05)),
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
        )
      ]
      
      
    );
  }
}

