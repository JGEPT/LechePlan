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

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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

    if (email.isEmpty) {
      _showMessage('Please enter your email', isError: true);
      return false;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _showMessage('Please enter a valid email address', isError: true);
      return false;
    }

    if (password.isEmpty) {
      _showMessage('Please enter your password', isError: true);
      return false;
    }

    return true;
  }

  Future<void> _handleLogin() async {
    if (!_validateForm()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      final result = await AuthService.signIn(
        email: email,
        password: password,
      );

      if (result['success']) {
        _showMessage(result['message']);
        // Navigate to main hub after successful login
        if (mounted) {
          context.go('/mainhub');
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
            _LoginContent(
              emailController: _emailController,
              passwordController: _passwordController,
              onLogin: _handleLogin,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}

//all the primary content of the page
class _LoginContent extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onLogin;
  final bool isLoading;

  const _LoginContent({
    required this.emailController,
    required this.passwordController,
    required this.onLogin,
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
        ),
        const SizedBox(height: 30),
        _LoginButton(
          onPressed: onLogin,
          isLoading: isLoading,
        ),
        const SizedBox(height: 20),
        const _SignUpRichText(),
      ],
    );
  }
}

//TEXT! -------------------------------------------------------------
class _HeaderText extends StatelessWidget {
  const _HeaderText();

  @override
  Widget build(BuildContext context) {
    return Text(
      "Login",
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
      "Welcome back! Let's whip up\nsome more sweet plans.",
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
//TEXT! -------------------------------------------------------------

//INPUT FIELDS ------------------------------------------------------
class _InputFields extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const _InputFields({
    required this.emailController,
    required this.passwordController,
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
      ],
    );
  }
}

class _LoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const _LoginButton({
    required this.onPressed,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButtonDefault(
      buttonHeight: 50,
      buttonLabel: isLoading ? "Signing In..." : "Log In",
      pressAction: isLoading ? () {} : onPressed,
    );
  }
}

//INPUT FIELDS ------------------------------------------------------

//pressable text using ontap recognizer yipee 
class _SignUpRichText extends StatelessWidget {
  const _SignUpRichText();

  @override
  Widget build(BuildContext context) {
    return RichText(     
      textScaler: TextScaler.linear(0.8),         
      text: TextSpan(
        text: "Don't have an account yet? ",
        style: TextStyle(
          fontFamily: 'Quicksand',
          color: darktextColor,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),

        children: [
          TextSpan(
            text: "Sign Up",                    
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: orangeAccentColor,
              fontSize: 16,
              fontWeight: FontWeight.w700,                      
            ),
            recognizer: TapGestureRecognizer() 
              ..onTap = () => context.go('/signup'),
          )
        ]

      )
    );
  }
}
