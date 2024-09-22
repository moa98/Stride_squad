import 'package:flutter/material.dart';
import 'signup_page.dart';  // Make sure this import is correct for your project

class FitnessLevelPage extends StatefulWidget {
  final String gender;
  final double height;
  final double weight;
  final String dateOfBirth;

  const FitnessLevelPage({
    super.key,
    required this.gender,
    required this.height,
    required this.weight,
    required this.dateOfBirth,
  });

  @override
  _FitnessLevelPageState createState() => _FitnessLevelPageState();
}

class _FitnessLevelPageState extends State<FitnessLevelPage> {
  String selectedFitnessLevel = '';

  Widget fitnessLevelButton(String level, String description) {
    bool isSelected = selectedFitnessLevel == level;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFitnessLevel = level;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
        padding: EdgeInsets.all(16.0),
        constraints: BoxConstraints(minWidth: double.infinity, minHeight: 80),
        decoration: BoxDecoration(
          color: isSelected ? Color.fromARGB(255, 138, 252, 154) : Colors.grey[200],
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Color.fromARGB(255, 138, 252, 154).withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              level,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.black : Colors.grey[700],
              ),
            ),
            SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Fitness Level'),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Spacer(flex: 1),
            Text(
              'How would you describe your fitness level?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            fitnessLevelButton(
              'Beginner',
              'You are new to fitness and just starting out.',
            ),
            fitnessLevelButton(
              'Intermediate',
              'You have some experience with fitness routines.',
            ),
            fitnessLevelButton(
              'Advanced',
              'You are highly experienced with rigorous fitness routines.',
            ),
            Spacer(flex: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: ElevatedButton(
                onPressed: selectedFitnessLevel.isEmpty ? null : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignUpPage(),  // Ensure this route is correctly implemented
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 138, 252, 154),
                  padding: EdgeInsets.symmetric(horizontal: 120, vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 106, 63, 156),
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
