import 'package:cloud_firestore/cloud_firestore.dart';

class Track {
  final String pathId;
  final String Name;
  final String startingPoint;
  final String finishPoint;
  final int length;
  final int popularity;
  final int difficultyStars;
  final int cleanStars;
  final int incline;
  final int safety;
  final List<String> reviews;
  final List<String> media;

  Track({
    required this.Name,
    required this.pathId,
    required this.startingPoint,
    required this.finishPoint,
    required this.length,
    required this.popularity,
    required this.difficultyStars,
    required this.cleanStars,
    required this.incline,
    required this.safety,
    required this.reviews,
    required this.media,
  });

  factory Track.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Track(
      pathId: data['pathId'] ?? '',
      Name: data['Name'] ?? '',
      startingPoint: data['startingPoint'] ?? '',
      finishPoint: data['finishPoint'] ?? '',
      length: _toInt(data['length']),
      popularity: _toInt(data['popularity']),
      difficultyStars: _toInt(data['difficultyStars']),
      cleanStars: _toInt(data['cleanStars']),
      incline: _toInt(data['incline']),
      safety: _toInt(data['safety']),
      reviews: List<String>.from(data['reviews'] ?? []),
      media: List<String>.from(data['media'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'pathId': pathId,
      'Name': Name,
      'startingPoint': startingPoint,
      'finishPoint': finishPoint,
      'length': length,
      'popularity': popularity,
      'difficultyStars': difficultyStars,
      'cleanStars': cleanStars,
      'incline': incline,
      'safety': safety,
      'reviews': reviews,
      'media': media,
    };
  }

  static int _toInt(dynamic value) {
    if (value is int) {
      return value;
    } else if (value is double) {
      return value.toInt();
    } else {
      return 0;
    }
  }
}
