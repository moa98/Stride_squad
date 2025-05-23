import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'DifficultyLevel.dart';
import 'GroupDetails.dart';
import 'InformationAboutPath.dart';
import 'track.dart';

class HomePage extends StatefulWidget {
  final String userName; // Accept the user's name

  const HomePage({super.key, required this.userName});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Track> tracks = [];

  @override
  void initState() {
    super.initState();
    print("Initializing HomePage state...");
    _getCurrentLocation();
    fetchUserTracks();
  }

  String address = 'Fetching address...';
  Future<void> _getCurrentLocation() async {
    try {
      // Check for permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) {
          setState(() {
            address = 'Location permissions are permanently denied.';
          });
          return;
        }
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Get address from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark place = placemarks.first;

      setState(() {
        address =
            '${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
      });
    } catch (e) {
      setState(() {
        address = 'Error fetching location: $e';
      });
    }
  }

  Future<void> fetchUserTracks() async {
    print("fetchUserTracks called"); // Check if this gets printed
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      print("Current User ID: $userId");

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (userDoc.exists) {
        List<dynamic> trackIds = userDoc['trackIds'] ?? [];
        print("Track IDs from User Document: $trackIds");

        if (trackIds.isNotEmpty) {
          QuerySnapshot trackSnapshot = await FirebaseFirestore.instance
              .collection('tracks')
              .where('pathId', whereIn: trackIds)
              .get();
          List<Track> userTracks = trackSnapshot.docs
              .map((doc) => Track.fromFirestore(doc))
              .toList();
          print("Tracks Fetched: ${userTracks.length}");

          setState(() {
            tracks = userTracks;
          });
        } else {
          setState(() {
            tracks = [];
          });
        }
      }
    } catch (e) {
      print('Error fetching user tracks: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StrideSquad'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.group_add),
            onPressed: _createGroup,
            iconSize: 35,
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
                    Color.fromARGB(255, 156, 221, 95),
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
                        offset: const Offset(0, 3),
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
                        color: const Color.fromRGBO(35, 47, 62, 1),
                      ),
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
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DifficultyLevelScreen()), // This should refer to the widget, not a method
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: Text(
                    'Start Run',
                    style: TextStyle(fontSize: 18),
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
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset(
                          'assets/path.jpg',
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
                                index < track.popularity
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.yellow,
                                size: 16.0,
                              );
                            }),
                          ),
                        ],
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        _navigateToPathInformation(context, track);
                      },
                    ),
                  );
                }),
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30.0, left: 16.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Hello ${widget.userName}",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage(
                          'assets/female.jpg'), // Path to profile image
                    ),
                    const SizedBox(height: 10),
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
                      child: const Text('Edit Profile'),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.location_on, color: Colors.black),
                        SizedBox(width: 5),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.85,
                          child: Text(
                            address,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
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

  void _createGroup() {
    // Navigate to the GroupDetails page after the group is created or initialized
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CreateGroupPage(), // Replace with your actual GroupDetails page
      ),
    );
  }

  void _navigateToPathInformation(BuildContext context, Track selectedTrack) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InformationAboutPathScreen(path: selectedTrack),
      ),
    );
  }
}
