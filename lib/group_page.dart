import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stridesquad1/controller/auth_controller.dart';
import 'package:stridesquad1/controller/groups_controller.dart';
import 'package:stridesquad1/controller/models/group_models.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({super.key});

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  GroupsController groupsController = Get.put(GroupsController());
  AuthController authController = Get.put(AuthController());

  @override
  void initState() {
    groupsController.fetchGroup();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All groups'),
      ),
      body: GetX<GroupsController>(
          init: groupsController,
          builder: (cont) {
            return ListView.builder(
                itemCount: cont.getGroupsList.length,
                itemBuilder: (context, index) {
                  GroupModels groupModels = cont.getGroupsList[index];
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    decoration: BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 10)
                    ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          groupModels.title!,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          groupModels.description!,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'No of Participent: ${groupModels.noOfParticipants}',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Join Participent: ${groupModels.totalParticipants!.length}',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                if (int.parse(groupModels.noOfParticipants!) <
                                    groupModels.totalParticipants!.length) {
                                  Get.snackbar(
                                      'Group is full', 'This group is full',
                                      backgroundColor: Colors.green.shade400,
                                      colorText: Colors.white);
                                } else if (groupModels.totalParticipants!
                                    .contains(
                                  authController.auth.currentUser!.uid,
                                )) {
                                  Get.snackbar('Already join',
                                      'you already join this group',
                                      backgroundColor: Colors.green.shade400,
                                      colorText: Colors.white);
                                } else {
                                  groupsController.addMemberToGroup(
                                      groupModels.id!,
                                      authController.auth.currentUser!.uid);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors
                                    .green.shade400, // Set the background color
                                foregroundColor:
                                    Colors.white, // Set the text color
                              ),
                              child: Text('Join group'),
                            )
                          ],
                        )
                      ],
                    ),
                  );
                });
          }),
    );
  }
}
