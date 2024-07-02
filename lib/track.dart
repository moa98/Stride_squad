class track {
  String pathId;
  String startingPoint;
  String finishPoint;
  double length;
  double popularity; // 0-100
  double difficultyStars;
  double cleanStars;
  double incline;
  double safety;
  List<String> reviews;
  List<String> media;

  track({
    required this.pathId,
    required this.startingPoint,
    required this.finishPoint,
    required this.popularity,
    required this.difficultyStars,
    required this.cleanStars,
    required this.incline,
    required this.safety,
    required this.reviews,
    required this.media,
    required this.length,
  });

  // Convert a Path instance to a map
  Map<String, dynamic> toMap() {
    return {
      'pathId': pathId,
      'startingPoint': startingPoint,
      'finishPoint': finishPoint,
      'popularity': popularity,
      'difficultyStars': difficultyStars,
      'cleanStars': cleanStars,
      'incline': incline,
      'safety': safety,
      'reviews': reviews,
      'media': media,
      'length': length,
    };
  }

  // Create a Path instance from a map
  factory track.fromMap(Map<String, dynamic> map) {
    return track(
      pathId: map['pathId'],
      startingPoint: map['startingPoint'],
      finishPoint: map['finishPoint'],
      popularity: map['popularity'],
      difficultyStars: map['difficultyStars'],
      cleanStars: map['cleanStars'],
      incline: map['incline'],
      safety: map['safety'],
      reviews: List<String>.from(map['reviews']),
      media: List<String>.from(map['media']),
      length: map['length'],
    );
  }
}
