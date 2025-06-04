/*
 * EditInterestsPage
 *
 * This page allows users to manage their interests:
 * - Orange chips: visible interests (active)
 * - Gray chips with +: hidden interests (inactive)
 * - Tap a chip to toggle its state
 * - Add a new interest by typing and pressing enter/add
 *
 * Design matches the rest of the app (colors, fonts, spacing)
 *
 * Usage Guide:
 * - Tap a chip to show/hide it
 * - Type a new interest and press enter to add
 * - Press Save to persist changes, Cancel to discard
 */

import 'package:flutter/material.dart';

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

class EditInterestsPage extends StatefulWidget {
  final List<String> activeInterests;
  const EditInterestsPage({super.key, required this.activeInterests});

  @override
  State<EditInterestsPage> createState() => _EditInterestsPageState();
}

class _EditInterestsPageState extends State<EditInterestsPage> {
  late List<String> activeInterests;

  @override
  void initState() {
    super.initState();
    activeInterests = List<String>.from(widget.activeInterests);
  }

  void _toggleInterest(String name) {
    setState(() {
      if (activeInterests.contains(name)) {
        activeInterests.remove(name);
      } else {
        activeInterests.add(name);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Gradient background
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.5, 0.0),
                end: Alignment(0.5, 1.0),
                colors: [Colors.white, Color(0xFFFEEFFF)],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: SizedBox(
                    height: 56,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: Color(0xBF0E1342),
                                fontSize: 13,
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            'Interests',
                            style: const TextStyle(
                              color: Color(0xBF0E1342),
                              fontSize: 20,
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context, activeInterests);
                            },
                            child: const Text(
                              'Save',
                              style: TextStyle(
                                color: Color(0x7F0E1342),
                                fontSize: 13,
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Divider
                Container(
                  width: double.infinity,
                  height: 1,
                  color: const Color(0xBF0E1342),
                ),
                // Chips
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      for (final name in kFixedInterests)
                        GestureDetector(
                          onTap: () => _toggleInterest(name),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                            decoration: BoxDecoration(
                              color: activeInterests.contains(name)
                                  ? const Color(0xFFFD5903)
                                  : const Color(0xFF949494),
                              borderRadius: BorderRadius.circular(17),
                            ),
                            child: Text(
                              activeInterests.contains(name) ? name : '$name +',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                // Divider
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  height: 1,
                  color: const Color(0xBF0E1342),
                ),
                const Spacer(),
                // Bottom navigation bar (static for now)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
