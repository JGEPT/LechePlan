import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

//page improrts
import 'package:lecheplan/screens/startSetup/landingpage.dart';

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
    ],
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router
    (
      title: 'BondLy',
      theme: ThemeData(
        fontFamily: 'Quicksand'
      ),
      
      debugShowCheckedModeBanner: false,
      
      routerConfig: _router,
    );
  }
}