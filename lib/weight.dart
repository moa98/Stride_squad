import 'package:flutter/material.dart';
import 'package:animated_weight_picker/animated_weight_picker.dart';
import 'age.dart';

class WeightSelectorScreen extends StatefulWidget {
  @override
  _WeightSelectorScreenState createState() => _WeightSelectorScreenState();
}

class _WeightSelectorScreenState extends State<WeightSelectorScreen> {
  double minWeight = 40;
  double maxWeight = 150;
  double selectedWeight = 70.0; // Default initial weight

  @override
  void initState() {
    super.initState();
    selectedWeight = minWeight; // Ensure initial weight is set as a double
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 80,
                backgroundImage: const AssetImage(
                    'assets/female.png'), // Ensure you have this asset
                backgroundColor: Colors.grey[200],
              ),
              const SizedBox(height: 40),
              const Text(
                'Weight',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Please choose your weight',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 10),
              Text(
                '${selectedWeight.toStringAsFixed(1)} kg',
                style:
                    const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              SizedBox(
                height: 200,
                child: AnimatedWeightPicker(
                  min: minWeight,
                  max: maxWeight,
                  onChange: (newValue) {
                    setState(() {
                      selectedWeight = double.tryParse(newValue.toString()) ??
                          selectedWeight;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                       Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DatePickerScreen()),
                      );
                    },
                    child: const Text('Continue',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Color.fromARGB(255, 138, 252, 154),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 20),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                         Navigator.pop(context); // Go back to the previous screen
                    },
                    child: const Text('Previous',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
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
      ),
    );
  }
}