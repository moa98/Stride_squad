import 'package:flutter/material.dart';
import 'track.dart';

class InformationAboutPathScreen extends StatefulWidget {
  final Track path;

  InformationAboutPathScreen({required this.path});

  @override
  _InformationAboutPathScreenState createState() =>
      _InformationAboutPathScreenState();
}

class _InformationAboutPathScreenState
    extends State<InformationAboutPathScreen> {
  final TextEditingController _reviewController = TextEditingController();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  void _addReview() {
    setState(() {
      widget.path.reviews.add(_reviewController.text);
      _reviewController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Colors.white, // Change AppBar background color to white
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Pop the current screen to go back
          },
        ),
      ),
      body: Container(
        color: Colors.white, // Change the background color to white
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(16.0), // Set the radius here
                        child: Container(
                          height: 250, // Reduced height of the image container
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/path.jpg'), // Ensure this image exists
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Stack(
                            children: <Widget>[
                              Positioned(
                                right: 16,
                                top: 16,
                                child: IconButton(
                                  icon: Icon(Icons.share, color: Colors.white),
                                  onPressed: () {
                                    // Add your share logic here
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
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
                            'Length: ${widget.path.length} km',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 8),
                          _buildStarRow('Difficulty:',
                              widget.path.difficultyStars.toInt()),
                          _buildStarRow(
                              'Incline:', widget.path.incline.toInt()),
                          _buildStarRow('Safety:', widget.path.safety.toInt()),
                          SizedBox(height: 8),
                          Text(
                            'Reviews:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ...widget.path.reviews
                              .map((review) => Text(
                                    review,
                                    style: TextStyle(fontSize: 16),
                                  ))
                              .toList(),
                          SizedBox(height: 16),
                          TextField(
                            controller: _reviewController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Write a review',
                            ),
                            maxLines: 5, // Increased max lines
                          ),
                          SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: _addReview,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 138, 252, 154),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                              ),
                              child: Text(
                                'Submit',
                                style: TextStyle(
                                  fontSize: 18, // Decreased font size
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Add your logic here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(
                      255, 138, 252, 154), // Styled like previous buttons
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20), // Increased corner radius
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 80, vertical: 20), // Increased padding
                ),
                child: Text(
                  'Take this route',
                  style: TextStyle(
                    fontSize: 24, // Increased font size
                    fontWeight: FontWeight.bold, // Bold text
                  ),
                ),
              ),
            ),
          ],
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