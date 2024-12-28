import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';
import 'package:stridesquad1/HomePage.dart';

class AuthController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  // FirebaseMessaging messaging = FirebaseMessaging.instance;

  final firebaseUser = Rxn<User>();
  User get users => firebaseUser.value!;

  @override
  void onInit() {
    firebaseUser.bindStream(auth.authStateChanges());

    super.onInit();
  }

  RxString name = ''.obs;

  Future<void> login(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      // Sign in with Firebase Authentication
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the user's UID
      String uid = userCredential.user!.uid;

      // Retrieve the user's name from Firestore
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      // Extract the user's name from the document
      String userName = userDoc['name'] ?? 'User';
      name.value = userDoc['name'] ?? 'User';
      // Navigate to HomePage and pass the user's name
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(userName: userName),
        ),
      );
    } catch (e) {
      // Show error message on failure
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to log in: ${e.toString()}'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }
}
