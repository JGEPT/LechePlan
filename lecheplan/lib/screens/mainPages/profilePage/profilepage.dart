import 'package:flutter/material.dart';
import 'package:lecheplan/screens/mainPages/homePage/homepage.dart';
import 'package:lecheplan/screens/mainPages/peoplePage/peoplepage.dart';
import 'package:lecheplan/screens/mainPages/plansPage/planspage.dart';
import 'package:lecheplan/screens/mainPages/profilePage/editprof.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'dart:convert';
import 'package:lecheplan/screens/miscellaneous/settingspage.dart';

const List<String> kFixedInterests = [
  'Social Media',
  'Influencer',
  'Broadcasting',
  'Social Media Design and Plans',
  'Art',
  'Music',
  'Computer Science',
  'Software Engineering',
  'Data Science',
  'AI',
  'Machine Learning',
  'Cybersecurity',
  'Blockchain',
  'Web Development',
];

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // DESIGN: List of interests for the profile
  // To adjust: Add or remove interests, change text, or modify the list structure
  final List<String> interests = [
    'Social Media',
    'Influencer',
    'Broadcasting',
    'Social Media Design and Plans',
    'Art',
    'Music',
    'Computer Science',
    'Software Engineering',
    'Data Science',
    'AI',
    'Machine Learning',
    'Cybersecurity',
    'Blockchain',
    'Web Development',
  ];

  bool showAllInterests = false;
  
  // DESIGN: State variables for profile data
  // To adjust: Add more fields as needed
  String nameText = '';
  String bioText = '';
  String locationText = '';
  String phoneText = '';
  String emailText = '';

  // DESIGN: Placeholder text for empty fields
  // To adjust: Change placeholder messages
  static const String namePlaceholder = 'Add your name';
  static const String bioPlaceholder = 'Add your bio...';
  static const String locationPlaceholder = 'Add your location';
  static const String phonePlaceholder = 'Add your phone number';
  static const String emailPlaceholder = 'Add your email';

  List<String> activeInterests = [];

  @override
  void initState() {
    super.initState();
    _loadProfileData();
    _loadActiveInterests();
  }

  // DESIGN: Load profile data from SharedPreferences
  // To adjust: Add more fields to load or change storage method
  Future<void> _loadProfileData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        nameText = prefs.getString('name') ?? '';
        bioText = prefs.getString('bio') ?? '';
        locationText = prefs.getString('location') ?? '';
        phoneText = prefs.getString('phone') ?? '';
        emailText = prefs.getString('email') ?? '';
      });
    } catch (e) {
      print('Error loading profile data: $e');
    }
  }

  Future<void> _loadActiveInterests() async {
    final prefs = await SharedPreferences.getInstance();
    final interestsString = prefs.getString('activeInterests');
    if (interestsString != null) {
      setState(() {
        activeInterests = List<String>.from(json.decode(interestsString));
      });
    } else {
      setState(() {
        activeInterests = List<String>.from(kFixedInterests); // default: all active
      });
    }
  }

  // Handles navigation for the bottom navigation bar
  void _onItemTapped(BuildContext context, int index) {
    if (index == 0) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    } else if (index == 1) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PeoplePage()));
    } else if (index == 2) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PlansPage()));
    }
  }

  // Shows the custom modal for edit options (edit profile, select profile picture)
  void showEditProfileModal(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "EditProfile",
      barrierColor: const Color(0xCCFD5903).withOpacity(0.1),
      transitionDuration: const Duration(milliseconds: 100),
      pageBuilder: (context, anim1, anim2) {
        return Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(color: Colors.transparent),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  width: 445,
                  height: 150,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 4, color: Colors.white),
                      borderRadius: BorderRadius.circular(19),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 4,
                        offset: Offset(0, -1),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 24,
                        top: 25,
                        child: Icon(Icons.image, color: Color(0xFFFD5903), size: 32),
                      ),
                      Positioned(
                        left: 66,
                        top: 26,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Select profile picture',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFFFD5903),
                              fontSize: 18,
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.w700,
                              height: 1,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 25,
                        top: 82,
                        child: Icon(Icons.edit, color: Color(0xFFFD5903), size: 32),
                      ),
                      Positioned(
                        left: 66,
                        top: 81,
                        child: GestureDetector(
                          onTap: () async {
                            Navigator.pop(context);
                            await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => EditProfilePage()),
                            );
                            // Reload all profile data and interests after returning from edit page
                            _loadProfileData();
                            _loadActiveInterests();
                          },
                          child: SizedBox(
                            width: 159,
                            child: Text(
                              'Edit profile',
                              style: TextStyle(
                                color: Color(0xFFFD5903),
                                fontSize: 18,
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.w700,
                                height: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Only show 5 interests unless 'Show All' is toggled
    final displayedInterests = showAllInterests
        ? activeInterests
        : activeInterests.take(5).toList();

    return Scaffold(
      body: Stack(
        children: [
          // Background image (profile cover)
          Positioned(
            child: Image.asset(
              'assets/images/sampleAvatar.jpg',
              width: 450,
              height: 650,
              fit: BoxFit.cover,
            ),
          ),

          // Semi-transparent overlay for darkening the background
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.2),
            ),
          ),

          // Main scrollable content (profile info, interests, details)
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 80, bottom: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top section: Name and bio
                Container(
                  height: 500,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nameText.isEmpty ? namePlaceholder : nameText,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          fontStyle: nameText.isEmpty ? FontStyle.italic : FontStyle.normal,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        bioText.isEmpty ? bioPlaceholder : bioText,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontStyle: bioText.isEmpty ? FontStyle.italic : FontStyle.normal,
                        ),
                      ),
                    ],
                  ),
                ),

                // White rounded container for interests and details
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                    gradient: LinearGradient(
                      colors: [Colors.white, Color(0xFFF8F6FF)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Interests section
                      const Text(
                        'Interests',
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.deepOrange),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 3,
                        runSpacing: 2,
                        children: displayedInterests.map((name) => Chip(
                          label: Text(name),
                          backgroundColor: Colors.deepOrangeAccent,
                          labelStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        )).toList(),
                      ),
                      const SizedBox(height: 8),
                      // Show All / Show Less toggle
                      TextButton(
                        onPressed: () {
                          setState(() {
                            showAllInterests = !showAllInterests;
                          });
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.deepOrange,
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(50, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          alignment: Alignment.centerLeft,
                        ),
                        child: Text(
                          showAllInterests ? 'Show Less ▲' : 'Show All ▼',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Details section
                      const Text(
                        'Details',
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.deepOrange),
                      ),
                      const SizedBox(height: 10),

                      // Location row
                      Row(
                        children: [
                          const Icon(Icons.location_city, color: Colors.deepOrange),
                          const SizedBox(width: 10),
                          Text(
                            locationText.isEmpty ? locationPlaceholder : locationText,
                            style: TextStyle(
                              color: locationText.isEmpty ? Colors.grey : Colors.black,
                              fontStyle: locationText.isEmpty ? FontStyle.italic : FontStyle.normal,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Phone row
                      Row(
                        children: [
                          const Icon(Icons.phone, color: Colors.deepOrange),
                          const SizedBox(width: 10),
                          Text(
                            phoneText.isEmpty ? phonePlaceholder : phoneText,
                            style: TextStyle(
                              color: phoneText.isEmpty ? Colors.grey : Colors.black,
                              fontStyle: phoneText.isEmpty ? FontStyle.italic : FontStyle.normal,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Email row
                      Row(
                        children: [
                          const Icon(Icons.email, color: Colors.deepOrange),
                          const SizedBox(width: 10),
                          Text(
                            emailText.isEmpty ? emailPlaceholder : emailText,
                            style: TextStyle(
                              color: emailText.isEmpty ? Colors.grey : Colors.black,
                              fontStyle: emailText.isEmpty ? FontStyle.italic : FontStyle.normal,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Edit icon at the top right (opens the modal)
          Positioned(
            top: 50,
            right: 50,
            child: GestureDetector(
              onTap: () {
                showEditProfileModal(context);
              },
              child: const Icon(Icons.edit, color: Colors.white, size: 28),
            ),
          ),

          // More icon at the top right (no functionality yet)
          Positioned(
            top: 50,
            right: 10,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
              child: const Icon(Icons.more_vert, color: Colors.white, size: 28),
            ),
          ),
        ],
      ),
    );
  }
}
