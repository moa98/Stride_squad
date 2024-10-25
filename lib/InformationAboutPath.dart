import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'track.dart'; // Ensure this is correctly imported with your Track class

class InformationAboutPathScreen extends StatefulWidget {
  final Track path;

  InformationAboutPathScreen({Key? key, required this.path}) : super(key: key);

  @override
  _InformationAboutPathScreenState createState() =>
      _InformationAboutPathScreenState();
}

class _InformationAboutPathScreenState
    extends State<InformationAboutPathScreen> {
  List<VideoPlayerController> _videoControllers = [];
  List<String> _mediaUrls = [];
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _mediaUrls = widget.path.media;
    _setupDocumentListener();
  }

  @override
  void dispose() {
    _videoControllers.forEach((controller) => controller.dispose());
    _pageController.dispose();
    super.dispose();
  }

  void _setupDocumentListener() {
    FirebaseFirestore.instance
        .collection('tracks')
        .doc(widget.path.pathId)
        .snapshots()
        .listen((docSnapshot) {
      if (docSnapshot.exists) {
        setState(() {
          _mediaUrls =
              List<String>.from(docSnapshot.data()?['mediaUrls'] ?? []);
        });
      }
    });
  }

  Future<void> _pickMedia() async {
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
    }
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
    setState(() {
      _mediaUrls.add(downloadUrl);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.path.Name),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_a_photo),
            onPressed: _pickMedia,
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Text(
                    'Welcome to ${widget.path.Name}!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Length: ${widget.path.length} km, Popularity: ${widget.path.popularity}/5',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Information: ${widget.path.informationPath}',
                    style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                  ),
                  SizedBox(height: 20),
                  _mediaUrls.isEmpty
                      ? Center(child: Text('No media available'))
                      : Container(
                          height: 300,
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: _mediaUrls.length,
                            itemBuilder: (_, index) => Image.network(
                                _mediaUrls[index],
                                fit: BoxFit.cover),
                          ),
                        ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Color.fromARGB(255, 138, 252, 154),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
