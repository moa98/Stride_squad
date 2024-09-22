import 'package:flutter/material.dart';
import 'package:stridesquad1/GroupAloneScreen.dart';

class DifficultyLevelScreen extends StatefulWidget {
  const DifficultyLevelScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DifficultyLevelScreenState createState() => _DifficultyLevelScreenState();
}

class _DifficultyLevelScreenState extends State<DifficultyLevelScreen> {
  String selectedDifficultyLevel = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Difficulty Level'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Color.fromARGB(255, 255, 255, 255), // White background
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(flex: 1), // Adjust the flex value as needed
            const Text(
              'How would you describe your difficulty level?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            difficultyLevelButton(
              'Easy',
              'Suitable for beginners with no prior experience.',
            ),
            difficultyLevelButton(
              'Medium',
              'For those with some experience in fitness routines.',
            ),
            difficultyLevelButton(
              'Hard',
              'Challenging routines for experienced individuals.',
            ),
            Spacer(flex: 2), // Adjust the flex value as needed
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: selectedDifficultyLevel.isEmpty
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GroupAloneScreen(),
                              ),
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(
                          255, 138, 252, 154), // Green background
                      padding:
                          EdgeInsets.symmetric(horizontal: 120, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 106, 63, 156),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: BorderSide(
                        color:
                            Color.fromARGB(255, 106, 63, 156), // Purple border
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 120, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                    child: const Text(
                      'Previous',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 106, 63, 156),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget difficultyLevelButton(String level, String description) {
    bool isSelected = selectedDifficultyLevel == level;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDifficultyLevel = level;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
        padding: EdgeInsets.all(16.0),
        constraints: BoxConstraints(minWidth: double.infinity, minHeight: 80),
        decoration: BoxDecoration(
          color: isSelected
              ? Color.fromARGB(255, 138, 252, 154)
              : Colors.grey[200],
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
}