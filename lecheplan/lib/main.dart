import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

//page improrts
import 'package:lecheplan/screens/startSetup/landingpage.dart';
import 'package:lecheplan/screens/startSetup/signuppage.dart';
import 'package:lecheplan/screens/startSetup/loginpage.dart';

void main() {
  runApp(
    MyApp()
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GoRouter _router = GoRouter(
    routes: [
      //please rename home to landingpage
      GoRoute(path: '/', builder: (context, state) => LandingPage()), 
      GoRoute(path: '/signup', builder: (context, state) => SignUpPage()), 
      GoRoute(path: '/login', builder: (context, state) => LoginPage()), 
    ],
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router
    (
      title: 'lecheplan',
      theme: ThemeData(
        fontFamily: 'Quicksand'
      ),
      
      debugShowCheckedModeBanner: false,
      
      routerConfig: _router,
    );
  }
}
