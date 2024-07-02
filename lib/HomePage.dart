import 'package:flutter/material.dart';
import 'InformationAboutPath';
import 'track.dart'; // Import the track class

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<String> friends = ["Alice", "Bob", "Charlie"];
  List<track> tracks = [
    track(
      pathId: "Track 1",
      startingPoint: "Point A",
      finishPoint: "Point B",
      length: 10,
      popularity: 75,
      difficultyStars: 3,
      cleanStars: 4,
      incline: 2,
      safety: 5,
      reviews: ["Great path!"],
      media: ["image1.jpg"],
    ),
    track(
      pathId: "Track 2",
      startingPoint: "Point C",
      finishPoint: "Point D",
      length: 15,
      popularity: 80,
      difficultyStars: 4,
      cleanStars: 5,
      incline: 4,
      safety: 5,
      reviews: ["Challenging but fun!"],
      media: ["image2.jpg"],
    ),
    track(
      pathId: "Track 3",
      startingPoint: "Point E",
      finishPoint: "Point F",
      length: 8,
      popularity: 60,
      difficultyStars: 2,
      cleanStars: 3,
      incline: 1,
      safety: 4,
      reviews: ["Good for beginners."],
      media: ["image3.jpg"],
    ),
  ];

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

  void _navigateToPathInformation(BuildContext context, track selectedPath) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => InformationAboutPathScreen(path: selectedPath)),
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
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
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
    return ListView.builder(
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
    );
  }
}
