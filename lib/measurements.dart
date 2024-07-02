import 'package:flutter/material.dart';
import 'package:animated_weight_picker/animated_weight_picker.dart';
import 'age.dart';  // Ensure the correct path to the AgeScreen

class HeightWeightSelectorScreen extends StatefulWidget {
  @override
  _HeightWeightSelectorScreenState createState() => _HeightWeightSelectorScreenState();
}

class _HeightWeightSelectorScreenState extends State<HeightWeightSelectorScreen> {
  double _currentHeight = 166;
  double minWeight = 40;
  double maxWeight = 150;
  String selectedWeight = '70.0'; // Default value for the weight

  @override
  void initState() {
    selectedWeight = minWeight.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Height and Weight Selector'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Height Section
              Text(
                'Height',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Please choose your height',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 20),
              Text(
                '${_currentHeight.toInt()} cm',
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Container(
                height: 150,
                child: RotatedBox(
                  quarterTurns: -1,
                  child: Slider(
                    value: _currentHeight,
                    min: 140,
                    max: 200,
                    divisions: 60,
                    onChanged: (value) {
                      setState(() {
                        _currentHeight = value;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 40),

              // Weight Section
              Text(
                'Weight',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Please choose your weight',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 20),
              Text(
                '$selectedWeight kg',
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Container(
                height: 200, // Adjust this height as needed
                child: AnimatedWeightPicker(
                  min: minWeight,
                  max: maxWeight,
                  onChange: (newValue) {
                    setState(() {
                      selectedWeight = newValue;
                    });
                  },
                ),
              ),
              SizedBox(height: 40),

              // Next Button
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => AgePage()),  // Navigate to AgeScreen
                  );
                },
                child: Text('NEXT'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
