import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'track.dart';

class InformationAboutPathScreen extends StatefulWidget {
  final Track path;

  InformationAboutPathScreen({required this.path});

  @override
  _InformationAboutPathScreenState createState() => _InformationAboutPathScreenState();
}

class _InformationAboutPathScreenState extends State<InformationAboutPathScreen> {
  final TextEditingController _reviewController = TextEditingController();
  VideoPlayerController? _videoController;
  List<XFile> _mediaFiles = [];
  int _likes = 0;  // Initialization of likes counter
  int _dislikes = 0;  // Initialization of dislikes counter
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _reviewController.dispose();
    _videoController?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _pickMedia() async {
    final ImagePicker _picker = ImagePicker();
    final List<XFile>? selectedFiles = await _picker.pickMultiImage();
    if (selectedFiles != null && selectedFiles.isNotEmpty) {
      setState(() {
        _mediaFiles.addAll(selectedFiles);
        _loadMedia();
      });
    }
  }

  void _loadMedia() {
    _mediaFiles.forEach((file) async {
      if (file.mimeType?.startsWith('video/') ?? false) {
        _videoController = VideoPlayerController.file(File(file.path))
          ..initialize().then((_) {
            setState(() {});
          });
      }
    });
  }

  Widget _mediaBuilder(BuildContext context, int index) {
    XFile file = _mediaFiles[index];
    bool isVideo = file.mimeType?.startsWith('video/') ?? false;
    if (isVideo) {
      return _videoController != null && _videoController!.value.isInitialized
          ? AspectRatio(
              aspectRatio: _videoController!.value.aspectRatio,
              child: VideoPlayer(_videoController!),
            )
          : Container(color: Colors.black);
    } else {
      return Image.file(File(file.path), fit: BoxFit.cover);
    }
  }

  void _incrementLikes() {
    setState(() {
      _likes++;
    });
  }

  void _incrementDislikes() {
    setState(() {
      _dislikes++;
    });
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
                              child: PageView.builder(
                                controller: _pageController,
                                itemCount: _mediaFiles.length,
                                itemBuilder: (context, index) => _mediaBuilder(context, index),
                              ),
                            ),
                            Positioned(
                              left: 10,
                              child: IconButton(
                                icon: Icon(Icons.arrow_back_ios, size: 30, color: Colors.white),
                                onPressed: () {
                                  if (_pageController.page! > 0) {
                                    _pageController.previousPage(
                                        duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
                                  }
                                },
                              ),
                            ),
                            Positioned(
                              right: 10,
                              child: IconButton(
                                icon: Icon(Icons.arrow_forward_ios, size: 30, color: Colors.white),
                                onPressed: () {
                                  if (_pageController.page! < _mediaFiles.length - 1) {
                                    _pageController.nextPage(
                                        duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
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
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                          TextField(
                            controller: _reviewController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Write a review',
                            ),
                            maxLines: 5,
                          ),
                          SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  widget.path.reviews.add(_reviewController.text);
                                  _reviewController.clear();
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 138, 252, 154),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              ),
                              child: Text(
                                'Submit',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
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
