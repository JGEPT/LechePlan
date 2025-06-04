import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; //for routing between screens
import 'package:logging/logging.dart'; //for adding logs instead of pritning
import 'package:supabase_flutter/supabase_flutter.dart'; //for the database 

//page imports
import 'package:lecheplan/screens/startSetup/landingpage.dart';
import 'package:lecheplan/screens/startSetup/signuppage.dart';
import 'package:lecheplan/screens/startSetup/loginpage.dart';
import 'package:lecheplan/screens/startSetup/createprofilepage.dart';
import 'package:lecheplan/screens/startSetup/aboutyoupage.dart';
import 'package:lecheplan/screens/mainPages/mainhubpage.dart';
import 'package:lecheplan/screens/miscellaneous/notificationspage.dart';
import 'package:lecheplan/screens/mainPages/profilePage/profilepage.dart';
import 'package:lecheplan/screens/miscellaneous/settingspage.dart';


//set up the logger -- use logger for testing instead of print statements because flutter said nah 
void setupLogging() {
  Logger.root.level = Level.ALL; 
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.loggerName}: ${record.message}');
  });
}
// to use logger 
// final Logger _nameofloggerVar = Logger('LoggerName');
// then do _nameofloggervar.info or .warning or .severe for printing instead of print yipee 

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Setup logging first
  setupLogging();
  
  // Initialize Supabase in the background
  final supabaseFuture = Supabase.initialize(
    url: 'https://abbdlkterbdhcwkxvgod.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFiYmRsa3RlcmJkaGN3a3h2Z29kIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDY3NTQzNDksImV4cCI6MjA2MjMzMDM0OX0.-nN5sW4BuTZaLvIxtJeFsKQgs5PMqrWTM4GWwGrToko',
  );

  runApp(MyApp(supabaseFuture: supabaseFuture));
}

class MyApp extends StatelessWidget {
  final Future<void> supabaseFuture;
  
  MyApp({super.key, required this.supabaseFuture});
  
  final GoRouter _router = GoRouter(
    routes: [      
      GoRoute(path: '/', builder: (context, state) => LandingPage()), 
      GoRoute(path: '/signup', builder: (context, state) => SignUpPage()), 
      GoRoute(path: '/login', builder: (context, state) => LoginPage()), 
      GoRoute(path: '/createprofile', builder: (context, state) => Createprofilepage()), 
      GoRoute(path: '/aboutyou', builder: (context, state) => Aboutyoupage()), 
      GoRoute(path: '/mainhub', builder: (context, state) => Mainhubpage()), 
      GoRoute(path: '/notifications', builder: (context, state) => NotificationsPage()), 
      GoRoute(path: '/profilepage', builder: (context, state) => ProfilePage()),
      GoRoute(path: '/settingspage', builder: (context, state) => SettingsPage()),
    ],
  );

  //this widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router
    (
      title: 'lecheplan',
      theme: ThemeData(
        fontFamily: 'Quicksand',
        // Add performance optimizations
        useMaterial3: true,
        platform: TargetPlatform.android,
      ),
      
      debugShowCheckedModeBanner: false,
      
      routerConfig: _router,
    );
  }
}
