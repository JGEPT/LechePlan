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
import 'package:shared_preferences/shared_preferences.dart';
import 'edit_interests.dart';
import 'dart:convert';

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

List<String> activeInterests = [];

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // STATE MANAGEMENT: Control flags for edit modes
  // These determine which sections are currently editable
  bool showAllInterests = false;
  bool isNameEditable = false;
  bool isBioEditable = false;
  bool isDetailsEditable = false;

  // STATE MANAGEMENT: Text storage
  // These store the actual text content for each field
  String nameText = '';
  String bioText = '';
  String locationText = '';
  String phoneText = '';
  String emailText = '';

  // DESIGN: Placeholder text for empty fields
  // These are shown when no text has been entered
  static const String namePlaceholder = 'Add your name';
  static const String bioPlaceholder = 'Add your bio...';
  static const String locationPlaceholder = 'Add your location';
  static const String phonePlaceholder = 'Add your phone number';
  static const String emailPlaceholder = 'Add your email';

  // STATE MANAGEMENT: Text controllers
  // These manage the text input fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = '';
    bioController.text = '';
    locationController.text = '';
    phoneController.text = '';
    emailController.text = '';
    _loadSavedData();
    _loadActiveInterests();
  }

  // STATE MANAGEMENT: Load saved data
  // This loads previously saved profile data from device storage
  Future<void> _loadSavedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        nameText = prefs.getString('name') ?? '';
        bioText = prefs.getString('bio') ?? '';
        locationText = prefs.getString('location') ?? '';
        phoneText = prefs.getString('phone') ?? '';
        emailText = prefs.getString('email') ?? '';
        
        // Update controllers with loaded values
        nameController.text = nameText;
        bioController.text = bioText;
        locationController.text = locationText;
        phoneController.text = phoneText;
        emailController.text = emailText;
      });
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  // STATE MANAGEMENT: Save data
  // This saves the current profile data to device storage
  Future<void> _saveData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('name', nameText);
      await prefs.setString('bio', bioText);
      await prefs.setString('location', locationText);
      await prefs.setString('phone', phoneText);
      await prefs.setString('email', emailText);
    } catch (e) {
      print('Error saving data: $e');
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

  Future<void> _saveActiveInterests() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('activeInterests', json.encode(activeInterests));
  }

  // STATE MANAGEMENT: Handle taps outside editing areas
  // This saves changes and closes edit mode when tapping outside
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
        _saveData();
      });
    }
  }

  @override
  void dispose() {
    // Clean up controllers when the page is closed
    nameController.dispose();
    bioController.dispose();
    locationController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // DESIGN: Only show 5 interests unless 'Show All' is toggled
    // To adjust: Change the number of initially visible interests
    final displayedInterests = showAllInterests
        ? activeInterests
        : activeInterests.take(5).toList();

    return GestureDetector(
      onTap: _handleTapOutside,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // DESIGN: Main scrollable content
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // DESIGN: Header section
                  // To adjust: Modify padding, colors, or text styles
                  Container(
                    padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black.withOpacity(0.1),
                          width: 2,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // DESIGN: Cancel button
                        // To adjust: Modify text style, color, or padding
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: Color(0xBF0E1342),
                              fontSize: 18,
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        // DESIGN: Title text
                        // To adjust: Modify text style, color, or size
                        const Text(
                          'Edit Profile',
                          style: TextStyle(
                            color: Color(0xBF0E1342),
                            fontSize: 25,
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        // DESIGN: Done button
                        // To adjust: Modify text style, color, or padding
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
                            await _saveData();
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
                  ),

                  // DESIGN: Profile picture section
                  // To adjust: Modify container padding, border, or background
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black.withOpacity(0.1),
                          width: 2,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        // DESIGN: Profile picture header row
                        // To adjust: Modify spacing or alignment
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // DESIGN: Section title
                            // To adjust: Modify text style or padding
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
                            // DESIGN: Edit button
                            // To adjust: Modify button style or position
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: TextButton(
                                onPressed: () {
                                  // TODO: Implement profile picture edit
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
                        // DESIGN: Profile picture container
                        // To adjust: Modify size, border radius, or image fit
                        Center(
                          child: Container(
                            width: 143,
                            height: 143,
                            decoration: ShapeDecoration(
                              image: const DecorationImage(
                                image: AssetImage('assets/images/sampleAvatar.jpg'),
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

                  // DESIGN: Name section
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black.withOpacity(0.1),
                          width: 2,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                                          _saveData();
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
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    child: Text(
                                      isNameEditable ? 'Done' : 'Edit',
                                      style: const TextStyle(
                                        color: Color(0xBF0E1342),
                                        fontSize: 18,
                                        fontFamily: 'Quicksand',
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FontStyle.normal,
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
                          onTap: () {}, // Empty onTap to prevent tap from bubbling up
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
                                  style: const TextStyle(
                                    color: Color(0xBF0E1342),
                                    fontSize: 15,
                                    fontFamily: 'Quicksand',
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),

                  // DESIGN: Bio section
                  // To adjust: Modify container padding, border, or background
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black.withOpacity(0.1),
                          width: 2,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                                          _saveData();
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
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    child: Text(
                                      isBioEditable ? 'Done' : 'Edit',
                                      style: const TextStyle(
                                        color: Color(0xBF0E1342),
                                        fontSize: 18,
                                        fontFamily: 'Quicksand',
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // DESIGN: Bio content
                        // To adjust: Modify text field or text style
                        GestureDetector(
                          onTap: () {}, // Empty onTap to prevent tap from bubbling up
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

                  // DESIGN: Interests section
                  // To adjust: Modify container padding, border, or background
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black.withOpacity(0.1),
                          width: 2,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // DESIGN: Interests header row
                        // To adjust: Modify spacing or alignment
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
                            // DESIGN: Edit button
                            // To adjust: Modify button style or behavior
                            TextButton(
                              onPressed: () async {
                                // Open the EditInterestsPage and wait for result
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
                                  _saveActiveInterests();
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
                        // DESIGN: Interests chips
                        // To adjust: Modify chip style, spacing, or layout
                        Center(
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 8,
                            runSpacing: 8,
                            children: displayedInterests.map((name) => Chip(
                              label: Text(name),
                              backgroundColor: Colors.deepOrange,
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
                        ),
                        // DESIGN: Show more/less button
                        // To adjust: Modify button style or position
                        if (activeInterests.length > 5)
                          Center(
                            child: TextButton(
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
                              ),
                              child: Text(
                                showAllInterests ? 'Show Less ▲' : 'Show All ▼',
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // DESIGN: Details section
                  // To adjust: Modify container padding, border, or background
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // DESIGN: Details header row
                        // To adjust: Modify spacing or alignment
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                                        _saveData();
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
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    child: Text(
                                      isDetailsEditable ? 'Done' : 'Edit',
                                      style: const TextStyle(
                                        color: Color(0xBF0E1342),
                                        fontSize: 18,
                                        fontFamily: 'Quicksand',
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // DESIGN: Location row
                        // To adjust: Modify icon, spacing, or text field style
                        GestureDetector(
                          onTap: () {}, // Empty onTap to prevent tap from bubbling up
                          child: Row(
                            children: [
                              const Icon(Icons.location_city, color: Colors.deepOrange),
                              const SizedBox(width: 10),
                              Expanded(
                                child: isDetailsEditable
                                    ? TextField(
                                        controller: locationController,
                                        decoration: InputDecoration(
                                          hintText: locationPlaceholder,
                                          border: OutlineInputBorder(),
                                        ),
                                      )
                                    : Text(
                                        locationText.isEmpty ? locationPlaceholder : locationText,
                                        style: const TextStyle(
                                          color: Color(0xBF0E1342),
                                          fontSize: 15,
                                          fontFamily: 'Quicksand',
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        // DESIGN: Phone row
                        // To adjust: Modify icon, spacing, or text field style
                        GestureDetector(
                          onTap: () {}, // Empty onTap to prevent tap from bubbling up
                          child: Row(
                            children: [
                              const Icon(Icons.phone, color: Colors.deepOrange),
                              const SizedBox(width: 10),
                              Expanded(
                                child: isDetailsEditable
                                    ? TextField(
                                        controller: phoneController,
                                        decoration: const InputDecoration(
                                          hintText: phonePlaceholder,
                                          border: OutlineInputBorder(),
                                        ),
                                      )
                                    : Text(
                                        phoneText.isEmpty ? phonePlaceholder : phoneText,
                                        style: const TextStyle(
                                          color: Color(0xBF0E1342),
                                          fontSize: 15,
                                          fontFamily: 'Quicksand',
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        // DESIGN: Email row
                        // To adjust: Modify icon, spacing, or text field style
                        GestureDetector(
                          onTap: () {}, // Empty onTap to prevent tap from bubbling up
                          child: Row(
                            children: [
                              const Icon(Icons.email, color: Colors.deepOrange),
                              const SizedBox(width: 10),
                              Expanded(
                                child: isDetailsEditable
                                    ? TextField(
                                        controller: emailController,
                                        decoration: const InputDecoration(
                                          hintText: emailPlaceholder,
                                          border: OutlineInputBorder(),
                                        ),
                                      )
                                    : Text(
                                        emailText.isEmpty ? emailPlaceholder : emailText,
                                        style: const TextStyle(
                                          color: Color(0xBF0E1342),
                                          fontSize: 15,
                                          fontFamily: 'Quicksand',
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
