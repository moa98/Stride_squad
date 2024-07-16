import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  VideoPlayerController? _videoController;
  List<String> _mediaUrls = [];
  int _likes = 0;
  int _dislikes = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _loadMedia();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadLikesAndDislikes();
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _pickMedia() async {
    final ImagePicker _picker = ImagePicker();
    final List<XFile>? selectedFiles = await _picker.pickMultiImage();
    if (selectedFiles != null && selectedFiles.isNotEmpty) {
      await _uploadMediaFiles(selectedFiles);
    }
  }

  Future<void> _uploadMediaFiles(List<XFile> files) async {
    for (var file in files) {
      String downloadUrl = await _uploadMediaFile(file);
      await _saveMediaUrlToFirestore(downloadUrl);
      print('Media URL uploaded: $downloadUrl');
    }
    _loadMedia(); // Reload media after upload
  }

  Future<String> _uploadMediaFile(XFile file) async {
    Reference storageRef = FirebaseStorage.instance
        .ref()
        .child("tracks/${widget.path.pathId}/${file.name}");
    UploadTask uploadTask = storageRef.putFile(File(file.path));

    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }

  Future<void> _saveMediaUrlToFirestore(String downloadUrl) async {
    DocumentReference trackRef =
        FirebaseFirestore.instance.collection('tracks').doc(widget.path.pathId);

    await trackRef.update({
      "mediaUrls": FieldValue.arrayUnion([downloadUrl])
    });
  }

  void _loadMedia() async {
    DocumentSnapshot<Map<String, dynamic>> docSnapshot = await FirebaseFirestore
        .instance
        .collection('tracks')
        .doc(widget.path.pathId)
        .get();

    if (docSnapshot.exists) {
      setState(() {
        _mediaUrls = List<String>.from(docSnapshot.data()?['mediaUrls'] ?? []);
        print('Loaded media URLs: $_mediaUrls');
      });
    }
  }

  void _loadLikesAndDislikes() async {
    DocumentSnapshot<Map<String, dynamic>> docSnapshot = await FirebaseFirestore
        .instance
        .collection('tracks')
        .doc(widget.path.pathId)
        .get();

    if (docSnapshot.exists) {
      setState(() {
        _likes = docSnapshot.data()?['likes'] ?? 0;
        _dislikes = docSnapshot.data()?['dislikes'] ?? 0;
      });
    }
  }

  void _incrementLikes() async {
    setState(() {
      _likes++;
    });
    DocumentReference trackRef =
        FirebaseFirestore.instance.collection('tracks').doc(widget.path.pathId);
    await trackRef.update({"likes": _likes});
  }

  void _incrementDislikes() async {
    setState(() {
      _dislikes++;
    });
    DocumentReference trackRef =
        FirebaseFirestore.instance.collection('tracks').doc(widget.path.pathId);
    await trackRef.update({"dislikes": _dislikes});
  }

  void _previewTrail() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Trail Preview'),
          content: Text(
              'Explore this 2.6-km out-and-back trail near Haifa, Haifa. Generally considered an easy route, it takes an average of 48 min to complete. This trail is great for running and walking, and it\'s unlikely you\'ll encounter many other people while exploring. The trail is open year-round and is beautiful to visit anytime. Dogs are welcome, but must be on a leash.'),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _mediaBuilder(BuildContext context, int index) {
    String url = _mediaUrls[index];
    bool isVideo = url.contains('.mp4');

    if (isVideo) {
      _videoController?.dispose();
      _videoController = VideoPlayerController.network(url)
        ..initialize().then((_) {
          setState(() {});
        });
      return _videoController != null && _videoController!.value.isInitialized
          ? AspectRatio(
              aspectRatio: _videoController!.value.aspectRatio,
              child: VideoPlayer(_videoController!),
            )
          : Container(color: Colors.black);
    } else {
      return Image.network(url, fit: BoxFit.cover);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_a_photo, color: Colors.black),
            onPressed: _pickMedia,
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 250,
                              child: Image.asset('assets/charles_river.jpg',
                                  fit: BoxFit.cover), // Image from assets
                            ),
                            Container(
                              height: 250,
                              child: PageView.builder(
                                controller: _pageController,
                                itemCount: _mediaUrls.length,
                                itemBuilder: (context, index) {
                                  return _mediaBuilder(context, index);
                                },
                              ),
                            ),
                            Positioned(
                              left: 10,
                              child: IconButton(
                                icon: Icon(Icons.arrow_back_ios,
                                    size: 30, color: Colors.white),
                                onPressed: () {
                                  if (_pageController.page! > 0) {
                                    _pageController.previousPage(
                                        duration: Duration(milliseconds: 400),
                                        curve: Curves.easeInOut);
                                  }
                                },
                              ),
                            ),
                            Positioned(
                              right: 10,
                              child: IconButton(
                                icon: Icon(Icons.arrow_forward_ios,
                                    size: 30, color: Colors.white),
                                onPressed: () {
                                  if (_pageController.page! <
                                      _mediaUrls.length - 1) {
                                    _pageController.nextPage(
                                        duration: Duration(milliseconds: 400),
                                        curve: Curves.easeInOut);
                                  }
                                },
                              ),
                            ),
                          ],
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
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Explore this 2.6-km out-and-back trail near Haifa, Haifa. Generally considered an easy route, it takes an average of 48 min to complete. This trail is great for running and walking, and it\'s unlikely you\'ll encounter many other people while exploring. The trail is open year-round and is beautiful to visit anytime. Dogs are welcome, but must be on a leash.',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Likes: $_likes   Dislikes: $_dislikes',
                            style: TextStyle(fontSize: 16),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: Icon(Icons.thumb_up, color: Colors.green),
                                onPressed: _incrementLikes,
                              ),
                              IconButton(
                                icon: Icon(Icons.thumb_down, color: Colors.red),
                                onPressed: _incrementDislikes,
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Reviews:',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          ...widget.path.reviews
                              .map((review) => Text(
                                    review,
                                    style: TextStyle(fontSize: 16),
                                  ))
                              .toList(),
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
                onPressed: _previewTrail,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 128, 209, 131),
                ),
                child: Text('Preview Trail'),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickMedia,
        tooltip: 'Add Photo/Video',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}