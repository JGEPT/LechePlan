import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lecheplan/providers/theme_provider.dart';
import 'package:lecheplan/services/auth_service.dart';
import 'package:lecheplan/services/profile_service.dart';

//model imports
import 'package:lecheplan/models/interestoptions.dart';

//widget imports
import 'package:lecheplan/widgets/reusableWidgets/custom_filledbutton.dart';
import 'package:lecheplan/widgets/modelWidgets/interests_pill.dart';

class Aboutyoupage extends StatefulWidget {
  const Aboutyoupage({super.key});

  @override
  State<Aboutyoupage> createState() => _AboutyoupageState();
}

class _AboutyoupageState extends State<Aboutyoupage> {
  final Set<String> _selectedInterests = <String>{};
  bool _isLoading = false;

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _toggleInterest(String interest) {
    setState(() {
      if (_selectedInterests.contains(interest)) {
        _selectedInterests.remove(interest);
      } else {
        _selectedInterests.add(interest);
      }
    });
  }

  Future<void> _handleDone() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final currentUser = AuthService.getCurrentUser();
      if (currentUser == null) {
        _showMessage('User not authenticated', isError: true);
        return;
      }

      if (_selectedInterests.isEmpty) {
        _showMessage('Please select at least one interest', isError: true);
        return;
      }

      final result = await ProfileService.saveUserInterests(
        userId: currentUser.id,
        interests: _selectedInterests.toList(),
      );

      if (result['success']) {
        _showMessage('Interests saved successfully!');
        if (mounted) {
          context.go('/mainhub');
        }
      } else {
        _showMessage(result['message'], isError: true);
      }
    } catch (e) {
      _showMessage('An unexpected error occurred: $e', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: pinkishBackgroundColor,
        width: double.infinity,
        padding: const EdgeInsets.all(40),
        child: Stack(
          children: [
            _MainContent(
              selectedInterests: _selectedInterests,
              onInterestToggle: _toggleInterest,
            ),
            _DoneButton(
              onPressed: _handleDone,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}

class _MainContent extends StatelessWidget {
  final Set<String> selectedInterests;
  final Function(String) onInterestToggle;

  const _MainContent({
    required this.selectedInterests,
    required this.onInterestToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const _HeaderText(),
          const SizedBox(height: 10),
          _InterestsList(
            selectedInterests: selectedInterests,
            onInterestToggle: onInterestToggle,
          ),
        ],
      ),
    );
  }
}

class _HeaderText extends StatelessWidget {
  const _HeaderText();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 30, left: 10 ,right:10, bottom: 10),
      child: Column(
        children: [
          Text(
            "About you",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 30,
              height: 1.0,
              color: orangeAccentColor,
            ),
          ),
          const SizedBox(height: 10),
          RichText( 
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.0,
              ),
              children: [
                TextSpan(
                  text: "Share ",
                  style: TextStyle(color: orangeAccentColor),
                ),
                TextSpan(
                  text: "your interests and hobbies",
                  style: TextStyle(color: darktextColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InterestsList extends StatelessWidget {
  final Set<String> selectedInterests;
  final Function(String) onInterestToggle;

  const _InterestsList({
    required this.selectedInterests,
    required this.onInterestToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Wrap(
              spacing: 5,
              runSpacing: 7,
              alignment: WrapAlignment.center,
              children: interestsAndHobbies
                  .map((interest) => SelectableInterestsPill(
                        item: interest,
                        isSelected: selectedInterests.contains(interest),
                        onTap: () => onInterestToggle(interest),
                      )).toList(),
            ),
          ),
          const _TopFade(),
          const _BottomFade(),
        ],
      ),
    );
  }
}

// Custom pill widget that supports external selection control
class SelectableInterestsPill extends StatelessWidget {
  final String item;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectableInterestsPill({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: IntrinsicWidth(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
          decoration: BoxDecoration(
            color: isSelected ? orangeAccentColor : greyAccentColor,
            borderRadius: BorderRadius.circular(99),           
          ),
          child: Text(
            item,
            style: TextStyle(
              color: isSelected ? lighttextColor : darktextColor.withAlpha(200),
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}

class _TopFade extends StatelessWidget {
  const _TopFade();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: IgnorePointer(
        child: Container(
          height: 10,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                pinkishBackgroundColor,
                pinkishBackgroundColor.withAlpha(0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomFade extends StatelessWidget {
  const _BottomFade();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: IgnorePointer(
        child: Container(
          height: 10,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                pinkishBackgroundColor.withAlpha(0),
                pinkishBackgroundColor,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DoneButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const _DoneButton({
    required this.onPressed,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: FilledButtonDefault(
          buttonHeight: 50,
          buttonLabel: isLoading ? "Saving..." : "Done!",
          pressAction: isLoading ? () {} : onPressed,
        ),
      ),
    );
  }
}
