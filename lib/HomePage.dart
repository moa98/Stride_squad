import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'DifficultyLevel.dart';
import 'InformationAboutPath.dart';
import 'track.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StrideSquad',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        backgroundColor: Color.fromARGB(255, 255, 255, 255), // Darker green color
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: _addFriend,
            iconSize: 35, // Making the icon larger
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
              children: [
                const SizedBox(height: 16.0),
                _buildProfileSection(),
                Container(
                  margin: const EdgeInsets.all(16.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Week goal: 50 km",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      LinearProgressIndicator(
                        value: 35 / 50,
                        backgroundColor: Colors.grey[300],
                        color: Color.fromRGBO(35, 47, 62, 1), // Darker green color
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "35 km done, 15 km left",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      _navigateToDifficultyLevelScreen(context);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color.fromARGB(255, 138, 252, 154),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    child: const Text('Start Run'),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Recent activity",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                ...tracks.map((track) {
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset(
                          'assets/path.jpg', // Use the correct path to your asset image
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(track.Name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${track.length} km"),
                          Row(
                            children: List.generate(5, (index) {
                              return Icon(
                                index < track.popularity ? Icons.star : Icons.star_border,
                                color: Colors.yellow,
                                size: 16.0,
                              );
                            }),
                          ),
                        ],
                      ),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {
                        _navigateToPathInformation(context, track);
                      },
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0), // Added padding to avoid overflow
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 30.0, left: 16.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Hello Marah",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10), // Space between text and profile image
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/female.jpg'), // Path to profile image
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Handle edit profile button press
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text('Edit Profile'),
                    ),
                    SizedBox(height: 10), // Space between buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.location_on, color: Colors.black),
                        SizedBox(width: 5),
                        Text(
                          'Haifa',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
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
