import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:stridesquad1/fittness_level.dart';

class DatePickerScreen extends StatefulWidget {
  const DatePickerScreen({super.key});

  @override
  State<DatePickerScreen> createState() => _DatePickerScreenState();
}

class _DatePickerScreenState extends State<DatePickerScreen> {
  DateTime selectedDate = DateTime.now();

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: Colors.white,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Image.asset(
            'assets/age.jpg',
            width: 250,
            height: 250,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 20),
          Text(
            'Your Date Of Birth',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'We use your date of birth to show you more appropriate results.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ),
          const SizedBox(height: 40),
          GestureDetector(
            onTap: () => _showDatePicker(context),
            child: Container(
              width: 300,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      "${selectedDate.toLocal()}".split(' ')[0],
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Icon(Icons.calendar_today, color: Colors.black),
                ],
              ),
            ),
          ),
          Expanded(child: Container()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
            child: Container(
              constraints:
                  const BoxConstraints(maxWidth: 400), // Limit button width
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FitnessLevelPage()),
                  );
                },
                child: const Text('Continue',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: const Color.fromARGB(255, 138, 252, 154),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 20, horizontal: 30.0),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Container(
              constraints:
                  const BoxConstraints(maxWidth: 400), // Limit button width
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Previous',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}