import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uid;
  String name;
  String email;
  String password;
  double distanceGoal;
  String gender;
  String fitnessLevel;
  int dateOfBirth;
  String imageUrl;
  String height;
  String weight;
  List<String> trackIds; // New field to store track IDs

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.password,
    required this.distanceGoal,
    required this.gender,
    required this.fitnessLevel,
    required this.dateOfBirth,
    required this.imageUrl,
    required this.height,
    required this.weight,
    this.trackIds = const [], // Initialize with an empty list by default
  });

  // Convert a UserModel to a map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'password': password,
      'distanceGoal': distanceGoal,
      'gender': gender,
      'fitness_level': fitnessLevel,
      'dateOfBirth': dateOfBirth,
      'imageUrl': imageUrl,
      'height': height,
      'weight': weight,
      'trackIds': trackIds, // Add trackIds to the map
    };
  }

  // Create a UserModel from a map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      password: map['password'], // added missing fields
      distanceGoal: map['distanceGoal'],
      gender: map['gender'],
      fitnessLevel: map['fitness_level'],
      dateOfBirth: map['dateOfBirth'],
      imageUrl: map['imageUrl'],
      height: map['height'],
      weight: map['weight'],
      trackIds:
          List<String>.from(map['trackIds'] ?? []), // Ensure it handles nulls
    );
  }

  // Convert a UserModel to JSON
  Map<String, dynamic> toJson() {
    return toMap(); // Directly reuse the toMap() function
  }
}

//function to add track for user-- I will check it when Mohammed solves the recommendation sys.
void addTrackToUser(UserModel user, String trackId) async {
  try {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'trackIds': FieldValue.arrayUnion([trackId])
    });
  } catch (e) {
    print('Error updating user with new trackId: $e');
    // Handle the error appropriately
  }
}
