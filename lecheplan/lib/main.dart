import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; //for routing between screens
import 'package:lecheplan/screens/mainPages/homePage/recommend_activity.dart';
import 'package:lecheplan/screens/mainPages/plansPage/activitydetails.dart';
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
import 'package:lecheplan/models/plan_model.dart';
import 'package:lecheplan/screens/mainPages/plansPage/create_plan_page.dart';

//set up the logger -- use logger for testing instead of print statements because flutter said nah
void setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print(
      '${record.level.name}: ${record.time}: ${record.loggerName}: ${record.message}',
    );
  });
}
// to use logger
// final Logger _nameofloggerVar = Logger('LoggerName');
// then do _nameofloggervar.info or .warning or .severe for printing instead of print yipee

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup logging first
  setupLogging();
  final logger = Logger('SupabaseConnection');

  //show loading screen immediately while waiting for supabase
  runApp(
    MaterialApp(
      home: Scaffold(body: Center(child: CircularProgressIndicator())),
    ),
  );

  try {
    //initialize Supabase
    await Supabase.initialize(
      url: 'https://abbdlkterbdhcwkxvgod.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFiYmRsa3RlcmJkaGN3a3h2Z29kIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDY3NTQzNDksImV4cCI6MjA2MjMzMDM0OX0.-nN5sW4BuTZaLvIxtJeFsKQgs5PMqrWTM4GWwGrToko',
    );

    // verify connection by checking auth status
    final auth = Supabase.instance.client.auth;
    logger.info('Supabase connection successful - Auth initialized');

    // Additional connection verification
    final client = Supabase.instance.client;
    logger.info('Supabase client initialized successfully');

    // log the current session status
    final session = client.auth.currentSession;
    logger.info(
      'Current auth session: ${session != null ? 'Active' : 'No active session'}',
    );

    // runn the main app after initialization
    runApp(MyApp());
  } catch (e) {
    logger.severe('Failed to initialize Supabase: $e');
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Failed to connect to database. Please try again.'),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => LandingPage()),
      GoRoute(path: '/signup', builder: (context, state) => SignUpPage()),
      GoRoute(path: '/login', builder: (context, state) => LoginPage()),
      GoRoute(
        path: '/createprofile',
        builder: (context, state) => Createprofilepage(),
      ),
      GoRoute(path: '/aboutyou', builder: (context, state) => Aboutyoupage()),
      GoRoute(path: '/mainhub', builder: (context, state) => Mainhubpage()),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => NotificationsPage(),
      ),
      GoRoute(
        path: '/activityrecommendation',
        builder: (context, state) => ActivityRecommendationPage(),
      ),
      GoRoute(path: '/profilepage', builder: (context, state) => ProfilePage()),
      GoRoute(
        path: '/settingspage',
        builder: (context, state) => SettingsPage(),
      ),
      GoRoute(
        path: '/createplan',
        builder: (context, state) => const CreatePlanPage(),
      ),
      GoRoute(
        path: '/activitydetailspage',
        builder: (context, state) {
          //get plan as extra parameter to move the data to the uhh thingy
          final plan = state.extra as Plan?;
          if (plan == null) {
            throw Exception('Plan data is required for ActivityDetailsPage');
          }
          return ActivityDetailsPage(plan: plan);
        },
      ),
    ],
  );

  //this widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
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
