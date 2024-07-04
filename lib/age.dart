import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Import Cupertino for iOS style date picker
import 'fittness_level.dart'; // Import FitnessLevelPage

class DatePickerScreen extends StatefulWidget {
  const DatePickerScreen({super.key});

  @override
  State<DatePickerScreen> createState() => _DatePickerScreenState();
}

class _DatePickerScreenState extends State<DatePickerScreen> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account', style: TextStyle(fontSize: 24)),
        backgroundColor: Colors.pink,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Expanded(
            child: Center(
              child: Text(
                'Age',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const Text(
            'Choose your date of birth.',
            style: TextStyle(fontSize: 24),
          ),
          Expanded(
            flex: 3,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: selectedDate,
              onDateTimeChanged: (newDate) {
                if (newDate != selectedDate) {
                  setState(() {
                    selectedDate = newDate;
                  });
                }
              },
              minimumYear: 1900,
              maximumDate: DateTime.now(),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Using the theme's background color
              use24hFormat: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85, // Adjust width to 85% of screen width
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FitnessLevelPage()),
                    );
                  },
                  child: const Text('Continue', style: TextStyle(fontSize: 20)),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50), // Standard height
                    backgroundColor: Colors.pink,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85, // Adjust width to 85% of screen width
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Previous', style: TextStyle(fontSize: 20)),
                  style: TextButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    foregroundColor: Colors.pink, // This sets the text color in TextButtons
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
