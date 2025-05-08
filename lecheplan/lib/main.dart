import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';

//page improrts
import 'package:lecheplan/screens/startSetup/landingpage.dart';
import 'package:lecheplan/screens/startSetup/signuppage.dart';
import 'package:lecheplan/screens/startSetup/loginpage.dart';
import 'package:lecheplan/screens/startSetup/createprofilepage.dart';
import 'package:lecheplan/screens/startSetup/aboutyoupage.dart';
import 'package:lecheplan/screens/mainPages/mainhubpage.dart';

//set up the logger -- use logger for testing instead of print statements because flutter said nah 
void setupLogging() {
  Logger.root.level = Level.ALL; 
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.loggerName}: ${record.message}');
  });
}
// to use logger 
// do VVVV
// final Logger _nameofloggerVar = Logger('LoggerName');
// then do _nameofloggervar.info or .warning or .severe for printing instead of print yipee 

void main() {
  setupLogging(); 

  runApp(
    MyApp()
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GoRouter _router = GoRouter(
    routes: [      
      GoRoute(path: '/', builder: (context, state) => LandingPage()), 
      GoRoute(path: '/signup', builder: (context, state) => SignUpPage()), 
      GoRoute(path: '/login', builder: (context, state) => LoginPage()), 
      GoRoute(path: '/createprofile', builder: (context, state) => Createprofilepage()), 
      GoRoute(path: '/aboutyou', builder: (context, state) => Aboutyoupage()), 
      GoRoute(path: '/mainhub', builder: (context, state) => Mainhubpage()), 
  
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
