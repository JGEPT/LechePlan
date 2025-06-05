import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:go_router/go_router.dart';
import 'package:lecheplan/providers/theme_provider.dart';
import 'package:lecheplan/services/auth_service.dart';

//widget imports
import 'package:lecheplan/widgets/reusableWidgets/custom_filledbutton.dart';
import 'package:lecheplan/widgets/reusableWidgets/custom_filledinputfield.dart';
import 'package:lecheplan/widgets/reusableWidgets/custom_filledpasswordfield.dart';
import 'package:lecheplan/widgets/reusableWidgets/custom_backbutton.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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

  bool _validateForm() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (email.isEmpty) {
      _showMessage('Please enter your email', isError: true);
      return false;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _showMessage('Please enter a valid email address', isError: true);
      return false;
    }

    if (password.isEmpty) {
      _showMessage('Please enter a password', isError: true);
      return false;
    }

    if (password.length < 6) {
      _showMessage('Password must be at least 6 characters long', isError: true);
      return false;
    }

    if (password != confirmPassword) {
      _showMessage('Passwords do not match', isError: true);
      return false;
    }

    return true;
  }

  Future<void> _handleSignUp() async {
    if (!_validateForm()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      final result = await AuthService.completeSignUp(
        email: email,
        password: password,
      );

      if (result['success']) {
        _showMessage(result['message']);
        // Navigate to create profile page after successful signup
        if (mounted) {
          context.go('/createprofile');
        }
      } else {
        _showMessage(result['message'], isError: true);
      }
    } catch (e) {
      _showMessage('An unexpected error occurred. Please try again.', isError: true);
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
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(top: 40, bottom: 20, right: 40, left: 40),
        child: Stack(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 0), 
              child: Custombackbutton(destinationString: '/')
            ),
            _SignUpContents(
              emailController: _emailController,
              passwordController: _passwordController,
              confirmPasswordController: _confirmPasswordController,
              onSignUp: _handleSignUp,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}

//primary page contents
class _SignUpContents extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final VoidCallback onSignUp;
  final bool isLoading;

  const _SignUpContents({
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.onSignUp,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const _HeaderText(),
        const SizedBox(height: 15),

        const _SubHeaderText(),
        const SizedBox(height: 30),

        _InputFields(
          emailController: emailController,
          passwordController: passwordController,
          confirmPasswordController: confirmPasswordController,
        ),
        const SizedBox(height: 30),

        _SignUpButton(
          onPressed: onSignUp,
          isLoading: isLoading,
        ),
        const SizedBox(height: 20),
        
        const _LoginRichText(),
      ],
    );
  }
}

class _HeaderText extends StatelessWidget {
  const _HeaderText();

  @override
  Widget build(BuildContext context) {
    return Text(
      "Sign Up",
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 30,
        height: 1.0,
        color: orangeAccentColor,
      ),
    );
  }
}

class _SubHeaderText extends StatelessWidget {
  const _SubHeaderText();

  @override
  Widget build(BuildContext context) {
    return Text(
      "New here? Create an account \nand let's plan something sweet.",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: darktextColor,
        height: 1.0,
      ),
    );
  }
}

class _InputFields extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const _InputFields({
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 15,
      children: [
        CustomFilledInputField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          inputFontColor: darktextColor,
          fillColor: lightAccentColor,
          labelText: "Email",
          labelFontColor: darktextColor,
        ),

        CustomFilledPasswordField(
          controller: passwordController,
          inputFontColor: darktextColor,
          fillColor: lightAccentColor,
          labelText: "Password",
          labelFontColor: darktextColor,
        ),

        CustomFilledPasswordField(
          controller: confirmPasswordController,
          inputFontColor: darktextColor,
          fillColor: lightAccentColor,
          labelText: "Confirm Password",
          labelFontColor: darktextColor,
        ),
      ],
    );
  }
}

class _SignUpButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const _SignUpButton({
    required this.onPressed,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButtonDefault(
      buttonHeight: 50,
      buttonLabel: isLoading ? "Creating Account..." : "Sign Up",
      pressAction: isLoading ? () {} : onPressed,
    );
  }
}

class _LoginRichText extends StatelessWidget {
  const _LoginRichText();

  @override
  Widget build(BuildContext context) {
    return RichText(
      textScaler: TextScaler.linear(0.8),         
      text: TextSpan(
        text:  "Already have an account? ",
        style: TextStyle(
          fontFamily: 'Quicksand',
          color: darktextColor,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),

        children: [
          TextSpan(
            text: "Log In",
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: orangeAccentColor,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),

            recognizer: TapGestureRecognizer()
              ..onTap = () => context.go('/login'),
          ),
        ],

      ),
    );
  }
}
