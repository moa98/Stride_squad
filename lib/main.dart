import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'gender.dart';
import 'height.dart';
import 'weight.dart';
import 'age.dart';
import 'fittness_level.dart';
import 'signup_page.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return MaterialApp(
      title: 'StrideSquad',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const GenderSelectScreen(),
        '/height': (context) => const HeightScreen(gender: "Male"), // Example gender
        '/weight': (context) => const WeightSelectorScreen(gender: "Male", height: 175), // Example height
        '/age': (context) => const DatePickerScreen(gender: "Male", height: 175, weight: 70), // Example weight
        '/fitness_level': (context) => const FitnessLevelPage(gender: "Male", height: 175, weight: 70, dateOfBirth: "1990-01-01"), // Example date
        '/signup': (context) => const SignUpPage(gender: "Male", height: 175, weight: 70, dateOfBirth: "1990-01-01", fittness_level:"begg"), // SignUp page
      },
    );
  }
}
