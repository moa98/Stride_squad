import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'DifficultyLevel.dart';
import 'InformationAboutPath.dart';
import 'track.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String locationMessage = 'Current Location of the User';
  List<String> friends = ["Alice", "Bob", "Charlie"];
  List<Track> tracks = [];

  @override
  void initState() {
    super.initState();
    fetchTracks();
  }

  Future<void> fetchTracks() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('tracks').get();
      setState(() {
        tracks = snapshot.docs.map((doc) => Track.fromFirestore(doc)).toList();
      });
    } catch (e) {
      print(e);
    }
  }

  // Getting current location
  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  void _liveLocation() {
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      setState(() {
        locationMessage = 'Latitude: ${position.latitude}, Longitude: ${position.longitude}';
      });
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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

  void _shareTrack(String track) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: friends.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(friends[index]),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Shared $track with ${friends[index]}')),
                );
              },
            );
          },
        );
      },
    );
  }

  void _navigateToPathInformation(BuildContext context, Track selectedPath) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => InformationAboutPathScreen(path: selectedPath)),
    );
  }

  void _navigateToDifficultyLevelScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DifficultyLevelScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StrideSquad'),
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
                  colors: [Colors.blueAccent, Color.fromARGB(255, 156, 221, 95)],
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
                _onItemTapped(0); // Update index to home page
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Discover'),
              onTap: () {
                _onItemTapped(1); // Update index to discover page
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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blueAccent, Color.fromARGB(255, 156, 221, 95)],
          ),
        ),
        child: SafeArea(
          child: _selectedIndex == 0 ? buildHomePage() : buildAnotherPage(),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Discover',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addFriend,
        child: const Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  Widget buildHomePage() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Hello Marah",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
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
                  color: Colors.blueAccent,
                ),
                const SizedBox(height: 5),
                const Text(
                  "35 km done, 15 km left",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                locationMessage,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  try {
                    Position position = await _getCurrentLocation();
                    setState(() {
                      locationMessage = 'Lat: ${position.latitude}, Long: ${position.longitude}';
                    });
                    _liveLocation();
                  } catch (e) {
                    setState(() {
                      locationMessage = e.toString();
                    });
                  }
                },
                child: const Text('Get current location'),
              ),
              const SizedBox(height: 20),
            ],
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
                  color: Colors.white,
                ),
              ),
            ),
          ),
          ...tracks.map((path) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        path.pathId,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${path.startingPoint} to ${path.finishPoint}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        "${path.length} km",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        "Popularity: ${path.popularity}%",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        "Difficulty: ${path.difficultyStars} stars",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () {
                      _navigateToPathInformation(context, path);
                    },
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget buildAnotherPage() {
    return Stack(
      children: [
        Positioned.fill(
          child: ListView.builder(
            itemCount: tracks.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                child: ListTile(
                  title: Text(tracks[index].pathId),
                  trailing: IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () {
                      _shareTrack(tracks[index].pathId);
                    },
                  ),
                  onTap: () {
                    _navigateToPathInformation(context, tracks[index]);
                  },
                ),
              );
            },
          ),
        ),
        Positioned(
          left: MediaQuery.of(context).size.width / 2 - 70, // Adjust this value to center the button horizontally
          bottom: 16.0,
          child: FloatingActionButton.extended(
            onPressed: () {
              _navigateToDifficultyLevelScreen(context);
            },
            icon: const Icon(Icons.directions_run),
            label: const Text('Start Run'),
            backgroundColor: Colors.blueAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            extendedPadding: EdgeInsets.symmetric(horizontal: 20),
          ),
        ),
      ],
    );
  }
}