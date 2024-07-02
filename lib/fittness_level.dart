import 'package:flutter/material.dart';
import 'signup_page.dart'; // Import SignUpPage

class FitnessLevelPage extends StatefulWidget {
  @override
  _FitnessLevelPageState createState() => _FitnessLevelPageState();
}

class _FitnessLevelPageState extends State<FitnessLevelPage> {
  String selectedFitnessLevel = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8E6E9), // Light pink background
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            Text(
              'Create Account',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: LinearProgressIndicator(
                value: 0.75,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
              ),
            ),
            Spacer(flex: 1), // Adjust the flex value as needed
            Text(
              'How would you describe your fitness level?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            fitnessLevelButton('Beginner'),
            fitnessLevelButton('Intermediate'),
            fitnessLevelButton('Advanced'),
            Spacer(flex: 2), // Adjust the flex value as needed
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: Text(
                      'Previous',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: selectedFitnessLevel.isEmpty
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignUpPage()),
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget fitnessLevelButton(String level) {
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
        decoration: BoxDecoration(
          color: isSelected ? Colors.pink[100] : Colors.grey[200],
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.pink.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ]
              : [],
        ),
        child: Text(
          level,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.black : Colors.grey[700],
          ),
        ),
      ),
    );
  }
}
