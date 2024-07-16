import 'package:flutter/material.dart';
import 'package:stridesquad1/tracksPages.dart';

class NatureCityPage extends StatefulWidget {
  @override
  _NatureCityPageState createState() => _NatureCityPageState();
}

class _NatureCityPageState extends State<NatureCityPage> {
  String selectedOption = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Running Preference'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Color.fromARGB(255, 255, 255, 255), // White background
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Spacer(flex: 1), // Adjust the flex value as needed
            Text(
              'Where do you prefer to run: in nature or in the city?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            optionButton(
              'Nature',
              'Experience the tranquility of natural surroundings.',
              'assets/nature.jpg', 
            ),
            optionButton(
              'City',
              'Enjoy the energy of an urban environment.',
              'assets/city.jpg', 
            ),
            Spacer(flex: 2), 
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: selectedOption.isEmpty
                        ? null
                        : () {
                            print('Selected option: $selectedOption');
                            // Navigate to the RouteMapScreen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TracksPage(),
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

  Widget optionButton(String option, String description, String imagePath) {
    bool isSelected = selectedOption == option;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedOption = option;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
        padding: const EdgeInsets.all(16.0),
        constraints: BoxConstraints(minWidth: double.infinity, minHeight: 120),
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
        child: Row(
          children: [
            Image.asset(imagePath, height: 80, width: 80),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.black : Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
