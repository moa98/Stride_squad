import 'package:flutter/material.dart';
import 'track.dart';

class InformationAboutPathScreen extends StatelessWidget {
  final Track path;

  InformationAboutPathScreen({required this.path});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[50],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Pop the current screen to go back
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.pink[50],
          child: Column(
            children: <Widget>[
              Container(
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/path.jpg'), // Ensure this image exists
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 16,
                      bottom: 16,
                      child: Text(
                        path.pathId,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Regarding the path',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Starting Point: ${path.startingPoint}\nFinish Point: ${path.finishPoint}\nLength: ${path.length} km\nPopularity: ${path.popularity} %',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    _buildStarRow('Difficulty:', path.difficultyStars.toInt()),
                    _buildStarRow('Cleanliness:', path.cleanStars.toInt()),
                    _buildStarRow('Incline:', path.incline.toInt()),
                    _buildStarRow('Safety:', path.safety.toInt()),
                    SizedBox(height: 8),
                    Text(
                      'Reviews:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    ...path.reviews.map((review) => Text(
                      review,
                      style: TextStyle(fontSize: 16),
                    )).toList(),
                    SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Write a review',
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Add your logic here
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Text('Take this route', style: TextStyle(fontSize: 16)),
                    ),
                    SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: () {
                        // Add your logic here
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        side: BorderSide(color: Colors.pink),
                      ),
                      child: Text(
                        'Share it with friends',
                        style: TextStyle(color: Colors.pink, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStarRow(String label, int stars) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(width: 8),
        Row(
          children: List.generate(5, (index) {
            return Icon(
              index < stars ? Icons.star : Icons.star_border,
              color: Colors.yellow[700],
            );
          }),
        ),
      ],
    );
  }
}
