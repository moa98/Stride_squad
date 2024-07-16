import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'DifficultyLevel.dart';
import 'InformationAboutPath.dart';
import 'track.dart';

class tracksPage extends StatefulWidget {
  @override
  _tracksPageState createState() => _tracksPageState();
}

class _tracksPageState extends State<tracksPage> {
  List<String> friends = ["Alice", "Bob", "Charlie"];
  List<Track> tracks = [];

  @override
  void initState() {
    super.initState();
    fetchTracks();
  }

  Future<void> fetchTracks() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('tracks').get();
      setState(() {
        tracks = snapshot.docs.map((doc) => Track.fromFirestore(doc)).toList();
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StrideSquad'),
        backgroundColor: Colors.white,
        shadowColor: Colors.green,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: _addFriend,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.blueAccent,
                    Color.fromARGB(255, 156, 221, 95)
                  ],
                ),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Section with Greeting
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            AssetImage('assets/profile_picture.jpg'),
                        radius: 30,
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Good morning!",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            "Marah",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search path',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                // Category Tabs
                Container(
                  height: 50,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    children: [
                      CategoryTab(label: 'All', isSelected: true),
                      CategoryTab(label: 'Sidewalks'),
                      CategoryTab(label: 'Trails'),
                      CategoryTab(label: 'Tracks'),
                      CategoryTab(label: 'Beaches'),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                // Paths Section
                Container(
                  height: 200,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 16.0),
                    children: [
                      PathCard(
                          imagePath: 'assets/hayarkonpark.jpg',
                          title: 'Hayarkon Park',
                          location: 'Tel Aviv, Israel'),
                      PathCard(
                          imagePath: 'assets/path.jpg',
                          title: 'Thames Path',
                          location: 'London, UK'),
                    ],
                  ),
                ),
                // Popular Paths Section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Popular',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                ...tracks.map((track) {
                  return PopularPathCard(
                    imagePath:
                        'assets/path.jpg', // Update with appropriate image path
                    title: track.Name,
                    location: "${track.length} km",
                    rating: 5, // Update with actual rating if available
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addFriend() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String friendName = '';
        return AlertDialog(
          title: const Text('Add Friend'),
          content: TextField(
            onChanged: (value) {
              friendName = value;
            },
            decoration: const InputDecoration(hintText: "Enter friend's name"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                setState(() {
                  friends.add(friendName);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToDifficultyLevelScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DifficultyLevelScreen()),
    );
  }

  void _navigateToPathInformation(BuildContext context, Track selectedPath) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => InformationAboutPathScreen(path: selectedPath)),
    );
  }
}

class CategoryTab extends StatelessWidget {
  final String label;
  final bool isSelected;

  CategoryTab({required this.label, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Chip(
        label: Text(label),
        backgroundColor: isSelected ? Colors.pink : Colors.grey[200],
        labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
      ),
    );
  }
}

class PathCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String location;

  PathCard(
      {required this.imagePath, required this.title, required this.location});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 160,
          child: Stack(
            children: [
              Image.asset(imagePath,
                  fit: BoxFit.cover, width: 160, height: 200),
              Positioned(
                bottom: 10,
                left: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                    Text(location,
                        style: TextStyle(color: Colors.white, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PopularPathCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String location;
  final int rating;

  PopularPathCard(
      {required this.imagePath,
      required this.title,
      required this.location,
      required this.rating});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20)),
              child: Image.asset(imagePath,
                  width: 100, height: 80, fit: BoxFit.cover),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(location,
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                    Row(
                      children: List.generate(
                          rating,
                          (index) =>
                              Icon(Icons.star, color: Colors.amber, size: 16)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


