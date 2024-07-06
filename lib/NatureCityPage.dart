import 'package:flutter/material.dart';

class NatureCityPage extends StatefulWidget {
  @override
  _NatureCityPageState createState() => _NatureCityPageState();
}

class _NatureCityPageState extends State<NatureCityPage> {
  String? _selectedOption;

  void _onOptionSelected(String option) {
    setState(() {
      _selectedOption = option;
    });
  }

  void _onContinuePressed() {
    // Handle the continue button press
    if (_selectedOption != null) {
      print('Selected option: $_selectedOption');
      // Navigate to the next page or perform the desired action
    } else {
      // Show a message to select an option
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an option')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NatureCity'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Where do you prefer to run: in nature or in the city?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            _buildOptionButton('Nature'),
            SizedBox(height: 20),
            _buildOptionButton('City'),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: _onContinuePressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: TextStyle(fontSize: 16),
              ),
              child: Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(String option) {
    return ElevatedButton(
      onPressed: () => _onOptionSelected(option),
      style: ElevatedButton.styleFrom(
        foregroundColor: _selectedOption == option ? Colors.white : Colors.black, backgroundColor: _selectedOption == option ? Colors.pink : Colors.grey[200],
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        textStyle: TextStyle(fontSize: 16),
      ),
      child: Text(option),
    );
  }
}
