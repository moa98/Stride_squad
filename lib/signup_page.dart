import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stridesquad1/user.dart';
import 'HomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpPage extends StatefulWidget {
  final String gender;
  final double height;
  final double weight;
  final String dateOfBirth;
  final String fitnessLevel;

  const SignUpPage({
    super.key,
    required this.gender,
    required this.height,
    required this.weight,
    required this.dateOfBirth,
    required this.fitnessLevel,
  });

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  Future<void> _signUp() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        // Extract year from the date string
        int yearOfBirth = DateTime.parse(widget.dateOfBirth).year;

        // Assuming successful signup, create user model
        UserModel newUser = UserModel(
          uid: userCredential.user!.uid,
          name: _nameController.text,
          email: _emailController.text,
          password: _passwordController
              .text, // Consider not storing passwords in Firestore
          distanceGoal: 0.0, // Default or ask user to set this
          gender: widget.gender,
          fitnessLevel: widget.fitnessLevel,
          dateOfBirth: yearOfBirth, // Store only the year
          imageUrl: '', // Default or let user upload an image
          height: widget.height.toString(),
          weight: widget.weight.toString(),
        );
        // Save newUser to Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(newUser.uid)
            .set(newUser.toMap());
        print("User Name: ${_nameController.text}");
        // Navigate to HomePage or success page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(userName: _nameController.text),
          ),
        );
      } catch (e) {
        print("Failed to sign up: $e");
        // Handle errors or show an alert dialog
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up"), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Sign Up to StrideSquad',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      labelText: 'Full Name', border: OutlineInputBorder()),
                  validator: (value) => value != null && value.isNotEmpty
                      ? null
                      : 'Name is required',
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      labelText: 'Email Address', border: OutlineInputBorder()),
                  validator: (value) => value != null && value.isNotEmpty
                      ? null
                      : 'Email is required',
                ),
                TextFormField(
                  controller: _userNameController,
                  decoration: InputDecoration(
                      labelText: 'Username', border: OutlineInputBorder()),
                  validator: (value) => value != null && value.isNotEmpty
                      ? null
                      : 'Username is required',
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (value) => value != null && value.isNotEmpty
                      ? null
                      : 'Password is required',
                ),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () => setState(() =>
                          _obscureConfirmPassword = !_obscureConfirmPassword),
                    ),
                  ),
                  validator: (value) => value == _passwordController.text
                      ? null
                      : 'Passwords do not match',
                ),
                ElevatedButton(
                  onPressed: _signUp,
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  child: Text('Sign Up', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
