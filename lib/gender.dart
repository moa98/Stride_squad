import 'package:flutter/material.dart';
import 'height.dart';

class GenderSelectScreen extends StatefulWidget {
  const GenderSelectScreen({super.key});

  @override
  State<GenderSelectScreen> createState() => _GenderSelectScreenState();
}

class _GenderSelectScreenState extends State<GenderSelectScreen> {
  String? selectedGender;

  Widget genderOption(String gender, String imagePath, Color color) {
    bool isSelected = selectedGender == gender;
    return GestureDetector(
      onTap: () => setState(() => selectedGender = gender),
      child: Card(
        color: isSelected ? color : Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(imagePath, height: 150), // Adjust height as necessary
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(gender, style: const TextStyle(fontSize: 20)),
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
        title: const Text('Create Account'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Please fill in the true information (optional)',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),
            genderOption('Female', 'assets/female.png', Colors.pink.shade100),
            genderOption('Male', 'assets/male.png', Colors.blue.shade100),
            const SizedBox(height: 20),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: selectedGender != null
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HeightScreen()),
                          );
                        }
                      : null,
                  child: const Text('Continue',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    minimumSize:
                        const Size(double.infinity, 50), // specific height
                    backgroundColor: selectedGender != null
                        ? Color.fromARGB(255, 138, 252, 154)
                        : const Color.fromARGB(255, 255, 255, 255),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HeightScreen()),
                    );
                  },
                  child: const Text('Skip',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    minimumSize:
                        const Size(double.infinity, 50), // specific height
                    backgroundColor: Color.fromARGB(255, 255, 255, 255),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}