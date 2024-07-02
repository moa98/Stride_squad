import 'package:flutter/material.dart';
// Import AgePage

class GenderPage extends StatefulWidget {
  @override
  _GenderPageState createState() => _GenderPageState();
}

class _GenderPageState extends State<GenderPage> {
  String selectedGender = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Match the background color of the main theme
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 40),
            Text(
              'Create Account',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Use a contrasting color for text
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: LinearProgressIndicator(
                value: 0.25,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent),
              ),
            ),
            Spacer(flex: 2),
            Text(
              'Optional: Share your gender identity (for personalization)',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedGender = 'Female';
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                          color: selectedGender == 'Female'
                              ? Colors.greenAccent[100]
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: selectedGender == 'Female' ? Colors.greenAccent : Colors.grey,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/female.jpg',
                              width: 100,
                              height: 100,
                            ),
                            SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedGender = 'Male';
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                          color: selectedGender == 'Male'
                              ? Colors.greenAccent[100]
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: selectedGender == 'Male' ? Colors.greenAccent : Colors.grey,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/male.jpg',
                              width: 100,
                              height: 100,
                            ),
                            SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(flex: 3),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: ElevatedButton(
                onPressed: selectedGender.isEmpty
                    ? null
                    : () {
                        Navigator.pushNamed(context, '/measurements'); // Navigate to the new screen
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedGender.isEmpty ? Colors.grey : Colors.greenAccent,
                  padding: EdgeInsets.symmetric(vertical: 20.0),
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
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/measurements'); // Navigate to the new screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: Text(
                  'Skip',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
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
