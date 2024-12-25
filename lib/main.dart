import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stridesquad1/gender.dart';
import 'package:stridesquad1/height.dart';
import 'package:stridesquad1/login.dart';
import 'package:stridesquad1/signup_page.dart';
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

    return GetMaterialApp(
      title: 'StrideSquad',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) => const MyHomePage(),
        '/login': (context) => LoginPage(),
        '/gender': (context) => const GenderSelectScreen(),
        '/height': (context) => const HeightScreen(gender: "Male"),
        '/weight': (context) =>
            const WeightSelectorScreen(gender: "Male", height: 175),
        '/age': (context) =>
            const DatePickerScreen(gender: "Male", height: 175, weight: 70),
        '/fitness_level': (context) => const FitnessLevelPage(
            gender: "Male", height: 175, weight: 70, dateOfBirth: "1990-01-01"),
        '/signup': (context) => const SignUpPage(
            gender: "Male",
            height: 175,
            weight: 70,
            dateOfBirth: "1990-01-01",
            fitnessLevel: "beginner"),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/Logo.jpg',
                height: 300,
                width: 300,
              ),
              const SizedBox(height: 15),
              Text(
                'StrideSquad',
                style: GoogleFonts.montserrat(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.white,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Explore | Trek | Connect',
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  color: Colors.green[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Discover Outdoor Escapes\nAnytime, Anywhere, with Fresh Content!',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  color: Colors.green[600],
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/gender'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green[700],
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 8,
                ),
                child: Text(
                  'Get Started',
                  style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/login'),
                child: Text(
                  'Already have an account? Log In',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    color: Colors.green[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
