import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lecheplan/providers/theme_provider.dart';
import 'package:lecheplan/services/auth_service.dart';
import 'package:lecheplan/services/profile_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

//widget imports
import 'package:lecheplan/widgets/reusableWidgets/custom_filledinputfield.dart';
import 'package:lecheplan/widgets/reusableWidgets/custom_filledbutton.dart';

class Createprofilepage extends StatefulWidget {
  const Createprofilepage({super.key});

  @override
  State<Createprofilepage> createState() => _CreateprofilepageState();
}

class _CreateprofilepageState extends State<Createprofilepage> {
  final _usernameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  File? _selectedImage;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _usernameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _selectImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
        _showMessage('Image selected successfully!');
      }
    } catch (e) {
      _showMessage('Failed to select image: $e', isError: true);
    }
  }

  bool _validateForm() {
    if (_usernameController.text.trim().isEmpty) {
      _showMessage('Please enter a username', isError: true);
      return false;
    }

    if (_firstNameController.text.trim().isEmpty) {
      _showMessage('Please enter your first name', isError: true);
      return false;
    }

    if (_lastNameController.text.trim().isEmpty) {
      _showMessage('Please enter your last name', isError: true);
      return false;
    }

    return true;
  }

  Future<void> _handleNext() async {
    if (!_validateForm()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final currentUser = AuthService.getCurrentUser();
      if (currentUser == null) {
        _showMessage('User not authenticated', isError: true);
        return;
      }

      String? profileImageUrl;

      // Upload image if selected
      if (_selectedImage != null) {
        final uploadResult = await ProfileService.uploadProfileImage(
          userId: currentUser.id,
          imageFile: _selectedImage!,
        );

        if (uploadResult['success']) {
          profileImageUrl = uploadResult['url'];
        } else {
          _showMessage('Failed to upload image, but continuing...', isError: true);
        }
      }

      // Update profile
      final result = await ProfileService.updateProfile(
        userId: currentUser.id,
        username: _usernameController.text.trim(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        profilePhotoUrl: profileImageUrl,
      );

      if (result['success']) {
        _showMessage('Profile updated successfully!');
        if (mounted) {
          context.go('/aboutyou');
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
              usernameController: _usernameController,
              firstNameController: _firstNameController,
              lastNameController: _lastNameController,
              selectedImage: _selectedImage,
              onImageSelect: _selectImage,
            ),
            _NextButton(
              onPressed: _handleNext,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}

//BUGS!! - i cant see when typing the birthday :< 
class _MainContent extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final File? selectedImage;
  final VoidCallback onImageSelect;

  const _MainContent({
    required this.usernameController,
    required this.firstNameController,
    required this.lastNameController,
    required this.selectedImage,
    required this.onImageSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const _HeaderText(),
        const SizedBox(height: 25),
        _InputFields(
          usernameController: usernameController,
          firstNameController: firstNameController,
          lastNameController: lastNameController,
          selectedImage: selectedImage,
          onImageSelect: onImageSelect,
        ),
      ],
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
            "Create Profile",
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
                  text: "Customize ",
                  style: TextStyle(color: orangeAccentColor),
                ),
                TextSpan(
                  text: "your account\nso people know you!",
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

class _InputFields extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final File? selectedImage;
  final VoidCallback onImageSelect;

  const _InputFields({
    required this.usernameController,
    required this.firstNameController,
    required this.lastNameController,
    required this.selectedImage,
    required this.onImageSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onImageSelect,
          child: Stack(
            children: [
              CircleAvatar(
                backgroundImage: selectedImage != null
                    ? FileImage(selectedImage!)
                    : const AssetImage('assets/images/sampleAvatar.jpg') as ImageProvider,
                radius: 60,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: orangeAccentColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: lighttextColor,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
        Column(
          spacing: 15,
          children: [
            CustomFilledInputField(
              controller: usernameController,
              inputFontColor: darktextColor,
              fillColor: lightAccentColor,
              labelText: "Username",
              labelFontColor: darktextColor,
            ),

            CustomFilledInputField(
              controller: firstNameController,
              inputFontColor: darktextColor,
              fillColor: lightAccentColor,
              labelText: "First Name",
              labelFontColor: darktextColor,
            ),

            CustomFilledInputField(
              controller: lastNameController,
              inputFontColor: darktextColor,
              fillColor: lightAccentColor,
              labelText: "Last Name",
              labelFontColor: darktextColor,
            ),
          ],
        ),
      ],
    );
  }
}

class _NextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const _NextButton({
    required this.onPressed,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: FilledButtonDefault(
        buttonHeight: 50,
        buttonLabel: isLoading ? "Saving..." : "Next",
        pressAction: isLoading ? () {} : onPressed,
      ),
    );
  }
}
