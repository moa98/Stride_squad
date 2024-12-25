import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/instance_manager.dart';
import 'package:stridesquad1/controller/auth_controller.dart';
import 'HomePage.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StrideSquad'),
        backgroundColor: Colors.white,
        shadowColor: Colors.green,
      ),
      body: Container(
        color: Colors.white, // Change background to white
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset('assets/Logo.jpg', height: 300), // Logo at the top
              Expanded(
                child: SingleChildScrollView(
                  // Ensure scrolling when keyboard is visible
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Log in',
                        style: TextStyle(
                          fontSize: 34, // Increased font size
                          fontWeight: FontWeight.bold,
                          color: Colors
                              .black, // Better contrast with white background
                        ),
                      ),
                      const SizedBox(height: 32), // Increased spacing
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: const TextStyle(
                              fontSize: 20), // Increased label font size
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                20), // Slightly more rounded corners
                          ),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),
                      const SizedBox(height: 24), // Increased spacing
                      TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: const TextStyle(
                              fontSize: 20), // Increased label font size
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                20), // Slightly more rounded corners
                          ),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 24), // Increased spacing
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20), // Added padding to bottom
                child: ElevatedButton(
                  onPressed: () async {
                    String email = emailController.text.trim();
                    String password = passwordController.text.trim();

                    authController.login(
                        email: email, password: password, context: context);
                  },
                  child: const Text(
                    'Log In',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold, // Increased font size
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(
                        255, 138, 252, 154), // Styled like previous buttons
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20), // Increased corner radius
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 140,
                      vertical: 20,
                    ), // Increased padding
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
