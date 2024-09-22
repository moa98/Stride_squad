import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'fittness_level.dart'; // Make sure this is the correct path

class DatePickerScreen extends StatefulWidget {
  final String gender;
  final double height;
  final double weight;

  const DatePickerScreen({
    super.key,
    required this.gender,
    required this.height,
    required this.weight,
  });

  @override
  State<DatePickerScreen> createState() => _DatePickerScreenState();
}

class _DatePickerScreenState extends State<DatePickerScreen> {
  DateTime selectedDate = DateTime.now(); // Default to current date

  void _showDatePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 300,
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: selectedDate,
                onDateTimeChanged: (newDate) {
                  setState(() {
                    selectedDate = newDate;
                  });
                },
                minimumYear: 1900,
                maximumDate: DateTime.now(),
                use24hFormat: true,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
            CupertinoButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = "${selectedDate.toLocal()}".split(' ')[0]; // Convert to string

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: Colors.white,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Image.asset('assets/age.jpg', width: 250, height: 250, fit: BoxFit.cover),
          const SizedBox(height: 20),
          Text(
            'Your Date Of Birth',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => _showDatePicker(context),
            child: Container(
              width: 300,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(4)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(formattedDate, style: const TextStyle(fontSize: 18, color: Colors.black), textAlign: TextAlign.center),
                  ),
                  const Icon(Icons.calendar_today, color: Colors.black),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FitnessLevelPage(
                    gender: widget.gender,
                    height: widget.height,
                    weight: widget.weight,
                    dateOfBirth: formattedDate, // Pass date as a string
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: const Color.fromARGB(255, 138, 252, 154),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30.0),
            ),
            child: const Text('Continue', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
