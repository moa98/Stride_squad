import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:stridesquad1/NatureCityPage.dart';
import 'package:stridesquad1/controller/auth_controller.dart';
import 'package:stridesquad1/controller/models/group_models.dart';

class GroupsController extends GetxController {
  AuthController authController = Get.put(AuthController());

  Future<void> createGroup(
      {required String title,
      required String description,
      required String numberOfParticepent}) async {
    await FirebaseFirestore.instance.collection('groups').add({
      'title': title,
      'description': description,
      'date_time': DateTime.now(),
      'no_of_participants': numberOfParticepent,
      'user_name': await getUserName(),
      'user_id': authController.auth.currentUser!.uid,
      'total_participants': []
    }).then((value) {
      Get.back();
    });
  }

  Future<String> getUserName() async {
    String userName = '';
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(authController.auth.currentUser!.uid)
        .get();
    userName = userDoc['name'] ?? 'User';

    return userName;
  }

  Rx<List<GroupModels>> groupsList = Rx<List<GroupModels>>([]);
  List<GroupModels> get getGroupsList => groupsList.value;

  fetchGroup() {
    groupsList.bindStream(getGroupStream());
    //userList.close();
  }

  Stream<List<GroupModels>> getGroupStream() {
    return FirebaseFirestore.instance
        .collection('groups')
        .orderBy('date_time', descending: false)
        .snapshots()
        .map((event) {
      List<GroupModels> retVal = [];
      for (var element in event.docs) {
        GroupModels groupModels = GroupModels.fromSnapSHot(element);
        retVal.add(groupModels);
      }
      print('group list is ${retVal.length}');
      return retVal;
    });
  }

  Future<void> addMemberToGroup(String groupId, String newMember) async {
    try {
      // Reference to the Firestore document
      DocumentReference groupRef =
          FirebaseFirestore.instance.collection('groups').doc(groupId);

      // Add the new member to the array
      await groupRef.update({
        'total_participants': FieldValue.arrayUnion([newMember]),
      }).then((e) {
        Get.to(() => NatureCityPage());
      });

      print("Member added successfully!");
    } catch (e) {
      print("Failed to add member: $e");
    }
  }
}
