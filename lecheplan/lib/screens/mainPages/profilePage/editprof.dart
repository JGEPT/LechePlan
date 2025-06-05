/*
 * EditProfilePage
 * 
 * This page allows users to edit their profile information including:
 * - Profile picture
 * - Name
 * - Bio
 * - Interests
 * - Contact details (location, phone, email)
 * 
 * State Management:
 * - Uses SharedPreferences to persist data across app restarts
 * - Each section has its own edit state (isNameEditable, isBioEditable, etc.)
 * - Text controllers manage the input fields
 * - Changes are saved when clicking 'Done' or tapping outside
 * 
 * Design Elements:
 * - Clean white background with section separators
 * - Consistent typography using Quicksand font
 * - Deep orange accent color for interactive elements
 * - Responsive layout with proper spacing
 * 
 * Usage Guide:
 * 1. To edit any section:
 *    - Click the 'Edit' button next to the section header
 *    - Make your changes in the text field
 *    - Click 'Done' to save or tap outside to cancel
 * 
 * 2. Profile Picture:
 *    - Click 'Edit' to change profile picture
 *    - Currently uses a sample image (to be implemented)
 * 
 * 3. Interests:
 *    - Shows first 5 interests by default
 *    - Click 'Show All' to see all interests
 *    - Edit functionality to be implemented
 * 
 * 4. Navigation:
 *    - 'Cancel' returns to profile page without saving
 *    - 'Done' in header saves all changes and returns
 */

import 'package:flutter/material.dart';
import 'package:lecheplan/services/auth_service.dart';
import 'package:lecheplan/services/profile_service.dart';
import 'edit_interests.dart';

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

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  //edit modes
  bool showAllInterests = false;
  bool isNameEditable = false;
  bool isBioEditable = false;
  bool isDetailsEditable = false;
  bool _isLoading = true;

  //text storage
  String nameText = '';
  String bioText = '';
  String locationText = '';
  String phoneText = '';
  String emailText = '';
  String profileImageUrl = '';

  //placeholders
  static const String namePlaceholder = 'Add your name';
  static const String bioPlaceholder = 'Add your bio...';
  static const String locationPlaceholder = 'Add your location';
  static const String phonePlaceholder = 'Add your phone number';
  static const String emailPlaceholder = 'Add your email';

  //text controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  List<String> activeInterests = [];

  @override
  void initState() {
    super.initState();
    _loadDataFromDatabase();
  }

  //load current profile data from database
  Future<void> _loadDataFromDatabase() async {
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
          
          //update controllers
          nameController.text = nameText;
          bioController.text = bioText;
          locationController.text = locationText;
          phoneController.text = phoneText;
          emailController.text = emailText;
          
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

  //save data to database
  Future<void> _saveDataToDatabase() async {
    try {
      final currentUser = AuthService.getCurrentUser();
      if (currentUser == null) return;

      //split name into first and last
      final nameParts = nameText.trim().split(' ');
      final firstName = nameParts.isNotEmpty ? nameParts.first : '';
      final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

      await ProfileService.updateProfile(
        userId: currentUser.id,
        firstName: firstName,
        lastName: lastName,
        bio: bioText,
        phoneNumber: phoneText,
        address: locationText,
      );
    } catch (e) {
      //handle error silently
    }
  }

  //save interests to database
  Future<void> _saveInterestsToDatabase() async {
    try {
      final currentUser = AuthService.getCurrentUser();
      if (currentUser == null) return;

      await ProfileService.saveUserInterests(
        userId: currentUser.id,
        interests: activeInterests,
      );
    } catch (e) {
      //handle error silently
    }
  }

  //handle tap outside
  void _handleTapOutside() {
    if (isNameEditable || isBioEditable || isDetailsEditable) {
      setState(() {
        if (isNameEditable) {
          nameText = nameController.text.trim();
        }
        if (isBioEditable) {
          bioText = bioController.text.trim();
        }
        if (isDetailsEditable) {
          locationText = locationController.text.trim();
          phoneText = phoneController.text.trim();
          emailText = emailController.text.trim();
        }
        isNameEditable = false;
        isBioEditable = false;
        isDetailsEditable = false;
      });
      _saveDataToDatabase();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    bioController.dispose();
    locationController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xBF0E1342)),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    //show first 5 interests unless expanded
    final displayedInterests = showAllInterests
        ? activeInterests
        : activeInterests.take(5).toList();

    return GestureDetector(
      onTap: _handleTapOutside,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xBF0E1342)),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Edit Profile',
            style: TextStyle(
              color: Color(0xBF0E1342),
              fontSize: 20,
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () async {
                setState(() {
                  nameText = nameController.text;
                  bioText = bioController.text;
                  locationText = locationController.text;
                  phoneText = phoneController.text;
                  emailText = emailController.text;
                  isNameEditable = false;
                  isBioEditable = false;
                  isDetailsEditable = false;
                });
                await _saveDataToDatabase();
                if (mounted) {
                  Navigator.pop(context);
                }
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: const Text(
                'Done',
                style: TextStyle(
                  color: Color(0xBF0E1342),
                  fontSize: 18,
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              //sections
              Container(
                width: double.infinity,
                color: const Color(0xFFF6F6F6),
                child: Column(
                  children: [
                    //profile picture section
                    Container(
                      width: double.infinity,
                      color: Colors.white,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: Text(
                                  'Profile picture',
                                  style: TextStyle(
                                    color: Color(0xBF0E1342),
                                    fontSize: 25,
                                    fontFamily: 'Quicksand',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: TextButton(
                                  onPressed: () {
                                    //todo: implement profile picture edit
                                  },
                                  child: const Text(
                                    'Edit',
                                    style: TextStyle(
                                      color: Color(0xBF0E1342),
                                      fontSize: 18,
                                      fontFamily: 'Quicksand',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: Container(
                              width: 143,
                              height: 143,
                              decoration: ShapeDecoration(
                                image: DecorationImage(
                                  image: (profileImageUrl.isNotEmpty)
                                      ? NetworkImage(profileImageUrl)
                                      : const AssetImage('assets/images/sampleAvatar.jpg') as ImageProvider,
                                  fit: BoxFit.cover,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(95.50),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    //name section
                    Container(
                      width: double.infinity,
                      color: Colors.white,
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Name',
                                style: TextStyle(
                                  color: Color(0xBF0E1342),
                                  fontSize: 25,
                                  fontFamily: 'Quicksand',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        if (isNameEditable) {
                                          final newText = nameController.text.trim();
                                          if (newText.isNotEmpty) {
                                            nameText = newText;
                                            _saveDataToDatabase();
                                          }
                                          isNameEditable = false;
                                        } else {
                                          isBioEditable = false;
                                          isDetailsEditable = false;
                                          nameController.text = nameText;
                                          isNameEditable = true;
                                        }
                                      });
                                    },
                                    borderRadius: BorderRadius.circular(8),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Edit',
                                        style: TextStyle(
                                          color: Color(0xBF0E1342),
                                          fontSize: 18,
                                          fontFamily: 'Quicksand',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {}, 
                            child: isNameEditable
                                ? TextField(
                                    controller: nameController,
                                    decoration: InputDecoration(
                                      hintText: namePlaceholder,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                  )
                                : Text(
                                    nameText.isEmpty ? namePlaceholder : nameText,
                                    style: TextStyle(
                                      color: nameText.isEmpty ? Color(0xFF4A4E71).withOpacity(0.5) : Color(0xFF4A4E71),
                                      fontSize: 15,
                                      fontFamily: 'Quicksand',
                                      fontStyle: nameText.isEmpty ? FontStyle.italic : FontStyle.normal,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),

                    //bio section
                    Container(
                      width: double.infinity,
                      color: Colors.white,
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Bio',
                                style: TextStyle(
                                  color: Color(0xBF0E1342),
                                  fontSize: 25,
                                  fontFamily: 'Quicksand',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        if (isBioEditable) {
                                          final newText = bioController.text.trim();
                                          if (newText.isNotEmpty) {
                                            bioText = newText;
                                            _saveDataToDatabase();
                                          }
                                          isBioEditable = false;
                                        } else {
                                          isNameEditable = false;
                                          isDetailsEditable = false;
                                          bioController.text = bioText;
                                          isBioEditable = true;
                                        }
                                      });
                                    },
                                    borderRadius: BorderRadius.circular(8),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Edit',
                                        style: TextStyle(
                                          color: Color(0xBF0E1342),
                                          fontSize: 18,
                                          fontFamily: 'Quicksand',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {}, 
                            child: isBioEditable
                                ? TextField(
                                    controller: bioController,
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                      hintText: bioPlaceholder,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                  )
                                : Text(
                                    bioText.isEmpty ? bioPlaceholder : bioText,
                                    style: TextStyle(
                                      color: bioText.isEmpty ? Color(0xFF4A4E71).withOpacity(0.5) : Color(0xFF4A4E71),
                                      fontSize: 15,
                                      fontFamily: 'Quicksand',
                                      fontStyle: bioText.isEmpty ? FontStyle.italic : FontStyle.normal,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),

                    //interests section
                    Container(
                      width: double.infinity,
                      color: Colors.white,
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Interests',
                                style: TextStyle(
                                  color: Color(0xBF0E1342),
                                  fontSize: 25,
                                  fontFamily: 'Quicksand',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditInterestsPage(
                                        activeInterests: activeInterests,
                                      ),
                                    ),
                                  );
                                  if (result != null && result is List<String>) {
                                    setState(() {
                                      activeInterests = List<String>.from(result);
                                    });
                                    _saveInterestsToDatabase();
                                  }
                                },
                                child: const Text(
                                  'Edit',
                                  style: TextStyle(
                                    color: Color(0xBF0E1342),
                                    fontSize: 18,
                                    fontFamily: 'Quicksand',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          if (activeInterests.isNotEmpty)
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: displayedInterests
                                  .map((interest) => Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          interest,
                                          style: const TextStyle(
                                            color: Color(0xFF4A4E71),
                                            fontSize: 14,
                                            fontFamily: 'Quicksand',
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            )
                          else
                            Text(
                              'No interests added yet',
                              style: TextStyle(
                                color: Color(0xFF4A4E71).withOpacity(0.5),
                                fontSize: 15,
                                fontFamily: 'Quicksand',
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          if (activeInterests.length > 5)
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showAllInterests = !showAllInterests;
                                  });
                                },
                                child: Text(
                                  showAllInterests ? 'Show Less' : 'Show All',
                                  style: const TextStyle(
                                    color: Color(0xBF0E1342),
                                    fontSize: 16,
                                    fontFamily: 'Quicksand',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    //details section
                    Container(
                      width: double.infinity,
                      color: Colors.white,
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Details',
                                style: TextStyle(
                                  color: Color(0xBF0E1342),
                                  fontSize: 25,
                                  fontFamily: 'Quicksand',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        if (isDetailsEditable) {
                                          final newLocation = locationController.text.trim();
                                          final newPhone = phoneController.text.trim();
                                          final newEmail = emailController.text.trim();
                                          if (newLocation.isNotEmpty) locationText = newLocation;
                                          if (newPhone.isNotEmpty) phoneText = newPhone;
                                          if (newEmail.isNotEmpty) emailText = newEmail;
                                          _saveDataToDatabase();
                                          isDetailsEditable = false;
                                        } else {
                                          isNameEditable = false;
                                          isBioEditable = false;
                                          locationController.text = locationText;
                                          phoneController.text = phoneText;
                                          emailController.text = emailText;
                                          isDetailsEditable = true;
                                        }
                                      });
                                    },
                                    borderRadius: BorderRadius.circular(8),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Edit',
                                        style: TextStyle(
                                          color: Color(0xBF0E1342),
                                          fontSize: 18,
                                          fontFamily: 'Quicksand',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          if (isDetailsEditable)
                            Column(
                              children: [
                                TextField(
                                  controller: locationController,
                                  decoration: InputDecoration(
                                    labelText: 'Location',
                                    hintText: locationPlaceholder,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextField(
                                  controller: phoneController,
                                  decoration: InputDecoration(
                                    labelText: 'Phone',
                                    hintText: phonePlaceholder,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextField(
                                  controller: emailController,
                                  decoration: InputDecoration(
                                    labelText: 'Email',
                                    hintText: emailPlaceholder,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                ),
                              ],
                            )
                          else
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Location: ${locationText.isEmpty ? locationPlaceholder : locationText}',
                                  style: TextStyle(
                                    color: locationText.isEmpty ? Color(0xFF4A4E71).withOpacity(0.5) : Color(0xFF4A4E71),
                                    fontSize: 15,
                                    fontFamily: 'Quicksand',
                                    fontStyle: locationText.isEmpty ? FontStyle.italic : FontStyle.normal,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Phone: ${phoneText.isEmpty ? phonePlaceholder : phoneText}',
                                  style: TextStyle(
                                    color: phoneText.isEmpty ? Color(0xFF4A4E71).withOpacity(0.5) : Color(0xFF4A4E71),
                                    fontSize: 15,
                                    fontFamily: 'Quicksand',
                                    fontStyle: phoneText.isEmpty ? FontStyle.italic : FontStyle.normal,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Email: ${emailText.isEmpty ? emailPlaceholder : emailText}',
                                  style: TextStyle(
                                    color: emailText.isEmpty ? Color(0xFF4A4E71).withOpacity(0.5) : Color(0xFF4A4E71),
                                    fontSize: 15,
                                    fontFamily: 'Quicksand',
                                    fontStyle: emailText.isEmpty ? FontStyle.italic : FontStyle.normal,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
