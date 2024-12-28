import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stridesquad1/controller/auth_controller.dart';
import 'package:stridesquad1/routeMap.dart';
import 'DifficultyLevel.dart';
import 'InformationAboutPath.dart';
import 'track.dart';

class TracksPage extends StatefulWidget {
  TracksPage({required this.isCity});

  bool isCity;

  @override
  _TracksPageState createState() => _TracksPageState();
}

class _TracksPageState extends State<TracksPage> {
  List<String> friends = ["Alice", "Bob", "Charlie"];
  List<Track> tracks = [];

  @override
  void initState() {
    print('track is ${widget.isCity}');
    super.initState();
    fetchTracks();
  }

  Future<void> fetchTracks() async {
    try {
      tracks.clear();
      List<Track> dataList = [];

      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('tracks').get();
      setState(() {
        dataList =
            snapshot.docs.map((doc) => Track.fromFirestore(doc)).toList();

        print('data list is ${dataList.length}');

        for (int i = 0; i < dataList.length; i++) {
          if (widget.isCity == dataList[i].isCity) {
            tracks.add(dataList[i]);
          }
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchTracksbyCategory(String category) async {
    try {
      tracks.clear();
      List<Track> dataList = [];
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('tracks')
          .where('type', isEqualTo: category)
          .get();
      setState(() {
        dataList =
            snapshot.docs.map((doc) => Track.fromFirestore(doc)).toList();

        for (int i = 0; i < dataList.length; i++) {
          if (widget.isCity == dataList[i].isCity) {
            tracks.add(dataList[i]);
          }
        }

        // tracks = snapshot.docs.map((doc) => Track.fromFirestore(doc)).toList();
      });
    } catch (e) {
      print(e);
    }
  }

  // void _navigateToRouteMapScreen(BuildContext context) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => RouteMapScreen()),
  //   );
  // }

  String getGreeting() {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour >= 5 && hour < 12) {
      return 'Good Morning';
    } else if (hour >= 12 && hour < 18) {
      return 'Good Afternoon';
    } else {
      return 'Hello';
    }
  }

  AuthController authController = Get.put(AuthController());

  TextEditingController serchController = TextEditingController();

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Section with Greeting
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage('assets/female.jpg'),
                        radius: 30,
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getGreeting(),
                            style: TextStyle(fontSize: 16),
                          ),
                          Obx(
                            () => Text(
                              authController.name.value,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
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
                    controller: serchController,
                    onChanged: (value) {
                      setState(() {});
                    },
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
                      categoryTab(label: 'All', isSelected: 0),
                      categoryTab(label: 'Sidewalks', isSelected: 1),
                      categoryTab(label: 'Trails', isSelected: 2),
                      categoryTab(label: 'Tracks', isSelected: 3),
                      categoryTab(label: 'Beaches', isSelected: 4),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                // Paths Section
                Container(
                    height: 200,
                    child: ListView.builder(
                        itemCount: tracks.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          Track track = tracks[index];
                          return track.Name.toLowerCase()
                                  .contains(serchController.text.toLowerCase())
                              ? PathCard(
                                  imagePath: track.url,
                                  title: track.Name,
                                  location: track.finishPoint)
                              : SizedBox();
                        })

                    // ListView(
                    //   scrollDirection: Axis.horizontal,
                    //   padding: const EdgeInsets.only(left: 16.0),
                    //   children: [
                    //     PathCard(
                    //         imagePath: 'assets/hayarkonpark.jpg',
                    //         title: 'Hayarkon Park',
                    //         location: 'Tel Aviv, Israel'),
                    //     PathCard(
                    //         imagePath: 'assets/path.jpg',
                    //         title: 'Thames Path',
                    //         location: 'London, UK'),
                    //   ],
                    // ),
                    ),
                // Popular Paths Section
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Popular',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                // ...tracks.map((track) {
                //   return PopularPathCard(
                //     imagePath:
                //         'assets/path.jpg', // Update with appropriate image path
                //     title: track.Name,
                //     location: "${track.length} km",
                //     rating: track
                //         .popularity, // Update with actual rating if available
                //     onTap: () => _navigateToRouteMapScreen(context),
                //   );
                // }).toList(),

                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: tracks.length,
                  itemBuilder: (context, index) {
                    final track = tracks[index]; // Get the current track
                    return track.Name.toLowerCase()
                            .contains(serchController.text.toLowerCase())
                        ? PopularPathCard(
                            imagePath:
                                track.url, // Update with appropriate image path
                            title: track.Name,
                            location: "${track.length} km",
                            rating: track
                                .popularity, // Update with actual rating if available
                            onTap: () {
                              if (index == 0) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RouteMapScreen(
                                            track: track,
                                            cityCenter:
                                                LatLng(32.0853, 34.7818),
                                            roadPoints: [
                                              LatLng(32.0809, 34.7806),
                                              LatLng(32.0812, 34.7815),
                                              LatLng(32.0820, 34.7827),
                                              LatLng(32.0832, 34.7841),
                                            ],
                                          )),
                                );
                              } else if (index == 1) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RouteMapScreen(
                                              track: track,
                                              cityCenter: const LatLng(
                                                  31.7683, 35.2137),
                                              roadPoints: const [
                                                LatLng(31.7693,
                                                    35.2127), // Start point of the road
                                                LatLng(31.7695,
                                                    35.2135), // Midpoint 1
                                                LatLng(31.7700,
                                                    35.2143), // Midpoint 2
                                                LatLng(31.7705,
                                                    35.2151), // End point of the road
                                              ])),
                                );
                              } else if (index == 2) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RouteMapScreen(
                                              track: track,
                                              cityCenter: const LatLng(
                                                  32.0652, 34.7768),
                                              roadPoints: const [
                                                LatLng(32.0646,
                                                    34.7760), // Start point of the road
                                                LatLng(32.0650,
                                                    34.7763), // Midpoint 1
                                                LatLng(32.0655,
                                                    34.7766), // Midpoint 2
                                                LatLng(32.0660,
                                                    34.7770), // End point of the road
                                              ])),
                                );
                              } else if (index == 3) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RouteMapScreen(
                                              track: track,
                                              cityCenter: const LatLng(
                                                  32.0656, 34.7768),
                                              roadPoints: [
                                                LatLng(32.0656,
                                                    34.7756), // Start of Rothschild Boulevard
                                                LatLng(32.0660,
                                                    34.7762), // Midpoint 1
                                                LatLng(32.0665,
                                                    34.7770), // Midpoint 2
                                                LatLng(32.0670,
                                                    34.7778), // End of Rothschild Boulevard
                                              ])),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RouteMapScreen(
                                            track: track,
                                            cityCenter:
                                                LatLng(32.0853, 34.7818),
                                            roadPoints: [
                                              LatLng(32.0809, 34.7806),
                                              LatLng(32.0812, 34.7815),
                                              LatLng(32.0820, 34.7827),
                                              LatLng(32.0832, 34.7841),
                                            ],
                                          )),
                                );
                              }
                            },
                          )
                        : SizedBox();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int selectedIndex = 0;

  Widget categoryTab({required String label, required int isSelected}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedIndex = isSelected;

            if (isSelected == 0) {
              fetchTracks();
            } else {
              fetchTracksbyCategory(label);
            }
          });
        },
        child: Chip(
          label: Text(label),
          backgroundColor: selectedIndex == isSelected
              ? const Color.fromARGB(255, 138, 252, 154)
              : Colors.grey[200],
          labelStyle: TextStyle(
              color: selectedIndex == isSelected ? Colors.white : Colors.black),
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
        backgroundColor: isSelected
            ? const Color.fromARGB(255, 138, 252, 154)
            : Colors.grey[200],
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
    print('image path ${imagePath}');
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 160,
          child: Stack(
            children: [
              Image.network(imagePath.trim(),
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
  final VoidCallback onTap;

  PopularPathCard(
      {required this.imagePath,
      required this.title,
      required this.location,
      required this.rating,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    print('image path is ${imagePath}');
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20)),
                child: Image.network(imagePath.trim(),
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
                            5,
                            (index) => Icon(
                                  index < rating
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.amber,
                                  size: 16,
                                )),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
