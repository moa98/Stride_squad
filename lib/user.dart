class UserModel {
  String uid;
  String name;
  String email;
  String password;
  double distanceGoal;
  String gender;
  String fitness_level; 
  int dateOfBirth;
  String imageUrl;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.password,
    required this.distanceGoal,
    required this.gender,
    required this.fitness_level,
    required this.dateOfBirth,
    required this.imageUrl,
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
      'fitness_level': fitness_level,
      'dateOfBirth': dateOfBirth,
      'imageUrl': imageUrl,
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
      fitness_level: map['fitness_level'],
      dateOfBirth: map['dateOfBirth'],
      imageUrl: map['imageUrl'],
    );
  }
}
