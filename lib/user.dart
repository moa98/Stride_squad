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
    required this.weight
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
      'height' : height,
      'weight' : weight,
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
      weight: map['weight']
    );
  }
}
