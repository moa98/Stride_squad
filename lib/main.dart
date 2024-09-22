import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stridesquad1/gender.dart';
import 'package:stridesquad1/height.dart';
import 'package:stridesquad1/weight.dart';
import 'age.dart';
import 'fittness_level.dart';
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
      statusBarColor: Colors.transparent, // transparent status bar
      statusBarIconBrightness: Brightness.dark, // dark text for status bar
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
        '/height': (context) => const HeightScreen(gender: "Male"),
        '/weight': (context) =>
            const WeightSelectorScreen(gender: "Male", height: 175),
        'age': (context) =>
            const DatePickerScreen(gender: "Male", height: 175, weight: 70),
        '/fitness_level': (context) => const FitnessLevelPage(
            gender: "Male",
            height: 175,
            weight: 70,
            dateOfBirth: "1990-01-01"), // Example usage
      },
    );
  }
}
