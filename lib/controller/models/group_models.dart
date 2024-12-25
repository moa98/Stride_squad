import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModels {
  String? id;
  String? title;
  String? description;
  String? noOfParticipants;
  String? userName;
  List<String>? totalParticipants;

  GroupModels({
    this.noOfParticipants,
    this.title,
    this.description,
    this.id,
  });

  GroupModels.fromSnapSHot(DocumentSnapshot<Map<String, dynamic>> data) {
    id = data.id;
    title = data.data()!["title"] ?? "";
    noOfParticipants = data.data()!["no_of_participants"] ?? "";
    description = data.data()!["description"] ?? "";
    userName = data.data()!["user_name"] ?? "";
    totalParticipants =
        List<String>.from(data.data()?["total_participants"] ?? []);
  }
}
