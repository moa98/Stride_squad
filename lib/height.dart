import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'weight.dart'; // Ensure this import is correct

class HeightScreen extends StatefulWidget {
  final String gender;
  const HeightScreen({super.key, required this.gender});

  @override
  State<HeightScreen> createState() => _HeightScreenState();
}

class _HeightScreenState extends State<HeightScreen> {
  double _currentHeight = 100.0; // Default height

  @override
  Widget build(BuildContext context) {
    double imageHeight = _currentHeight * 2; // Scale factor for image height
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account', style: TextStyle(fontSize: 24)),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Enter your height',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '${_currentHeight.toStringAsFixed(0)} cm',
                    style: const TextStyle(fontSize: 24),
                  ),
                  Slider(
                    value: _currentHeight,
                    min: 100,
                    max: 220,
                    divisions: 120,
                    label: _currentHeight.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        _currentHeight = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Image.asset(
                    'assets/height.png', // Ensure this path is correct
                    height: imageHeight,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WeightSelectorScreen(
                      gender: widget.gender,
                      height: _currentHeight,
                    ),
                  ),
                );
              },
              child: const Text('Continue',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Color.fromARGB(255, 138, 252, 154),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 20),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Navigate back to the previous screen
              },
              child: const Text('Previous',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
