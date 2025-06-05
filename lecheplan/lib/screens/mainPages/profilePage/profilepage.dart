import 'package:flutter/material.dart';
import 'package:lecheplan/screens/mainPages/profilePage/editprof.dart';
import 'package:lecheplan/widgets/modelWidgets/interests_pill.dart';
import 'package:lecheplan/services/auth_service.dart';
import 'package:lecheplan/services/profile_service.dart';
import 'dart:ui';
import 'dart:convert';
import 'package:lecheplan/screens/miscellaneous/settingspage.dart';
import 'package:lecheplan/providers/theme_provider.dart';

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
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool showAllInterests = false;
  bool _isLoading = true;
  
  //profile data from database
  String nameText = '';
  String bioText = '';
  String locationText = '';
  String phoneText = '';
  String emailText = '';
  String profileImageUrl = '';
  String username = '';

  //placeholders for empty fields
  static const String namePlaceholder = 'Add your name';
  static const String bioPlaceholder = 'Add to your bio...';
  static const String locationPlaceholder = 'Add your location';
  static const String phonePlaceholder = 'Add your phone number';
  static const String emailPlaceholder = 'Add your email';

  List<String> activeInterests = [];

  @override
  void initState() {
    super.initState();
    _loadProfileFromDatabase();
  }

  //load profile data from database
  Future<void> _loadProfileFromDatabase() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final currentUser = AuthService.getCurrentUser();
      if (currentUser == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      //get profile data
      final profileResult = await ProfileService.getUserProfile(currentUser.id);
      
      //get interests
      final interestsResult = await ProfileService.getUserInterests(currentUser.id);

      if (profileResult['success'] && mounted) {
        final profile = profileResult['profile'];
        setState(() {
          nameText = profile['name'] ?? '';
          bioText = profile['user_bio'] ?? '';
          locationText = profile['user_address'] ?? '';
          phoneText = profile['user_cont_number'] ?? '';
          emailText = profile['user_email'] ?? '';
          profileImageUrl = profile['profile_photo_url'] ?? '';
          username = profile['username'] ?? '';
          
          if (interestsResult['success']) {
            activeInterests = List<String>.from(interestsResult['interests']);
          }
          
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  //reload data after editing
  void _refreshProfile() {
    _loadProfileFromDatabase();
  }

  //show edit modal
  void showEditProfileModal(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "EditProfile",
      barrierColor: const Color(0xCCFD5903).withAlpha(30),
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
                            //reload profile after editing
                            _refreshProfile();
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
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: orangeAccentColor),
        ),
      );
    }

    //show first 5 interests unless expanded
    final displayedInterests = showAllInterests
        ? activeInterests
        : activeInterests.take(5).toList();

    return Scaffold(
      body: Stack(
        children: [
          //background image or profile photo
          Positioned(
            child: profileImageUrl.isNotEmpty
                ? Image.network(
                    profileImageUrl,
                    width: 450,
                    height: 650,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/sampleAvatar.jpg',
                        width: 450,
                        height: 650,
                        fit: BoxFit.cover,
                      );
                    },
                  )
                : Image.asset(
                    'assets/images/sampleAvatar.jpg',
                    width: 450,
                    height: 650,
                    fit: BoxFit.cover,
                  ),
          ),

          //dark overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withAlpha(50),
            ),
          ),

          //main content
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 80, bottom: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //name and bio section
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
                      const SizedBox(height: 0),
                      Text(
                        bioText.isEmpty ? bioPlaceholder : bioText,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          fontStyle: bioText.isEmpty ? FontStyle.italic : FontStyle.normal,
                        ),
                      ),
                    ],
                  ),
                ),

                //white container for details
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
                      //interests section
                      Text(
                        'Interests',
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: orangeAccentColor),
                      ),
                      const SizedBox(height: 8),
                      if (activeInterests.isNotEmpty)
                        Wrap(
                          spacing: 4,
                          runSpacing: 5,
                          children: displayedInterests
                            .map((interest) => InterestsPill(item: interest, isClickable: false,)).toList()
                        )
                      else
                        Text(
                          'No interests added yet',
                          style: TextStyle(
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      const SizedBox(height: 8),
                      //show all toggle
                      if (activeInterests.length > 5)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              showAllInterests = !showAllInterests;
                            });
                          },
                          child: Text(
                            showAllInterests ? 'Show Less' : 'Show All',
                            style: TextStyle(
                              color: orangeAccentColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      const SizedBox(height: 30),

                      //details section
                      Text(
                        'Details',
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: orangeAccentColor),
                      ),
                      const SizedBox(height: 16),
                      
                      //username
                      Row(
                        children: [
                          Icon(Icons.person, color: orangeAccentColor),
                          const SizedBox(width: 10),
                          Text(
                            username.isEmpty ? 'No username set' : '@$username',
                            style: TextStyle(
                              color: username.isEmpty ? Colors.grey : Colors.black,
                              fontStyle: username.isEmpty ? FontStyle.italic : FontStyle.normal,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      //location
                      Row(
                        children: [
                          Icon(Icons.location_on, color: orangeAccentColor),
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
                      const SizedBox(height: 16),
                      
                      //phone
                      Row(
                        children: [
                          Icon(Icons.phone, color: orangeAccentColor),
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
                      const SizedBox(height: 16),
                      
                      //email
                      Row(
                        children: [
                          Icon(Icons.email, color: orangeAccentColor),
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

          //edit icon
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

          //settings icon
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
