import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:particeproject/src/uifriestore.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  Future<Position> _getCurrentLocation() async {
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Method to start background location tracking
  void _startBackgroundLocationTracking() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      // Handle the obtained position here
      print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
    } catch (e) {
      print('Error obtaining location: $e');
    }
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  Future<void> _signInWithEmailAndPassword() async {
    if (_formKey.currentState!.validate()) {
      try {
        final email = _emailController.text.trim();
        final password = _passwordController.text.trim();

        // Sign in with email and password
        final userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // If sign-in is successful, navigate to the next screen
        if (userCredential.user != null) {
          // Obtain the userId
          _startBackgroundLocationTracking();

          // Navigate to LocationScreen with userId
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (context) => LocationScreen()),
          // );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('Failed to sign in. Please check your credentials.'),
            ),
          );
        }
      } catch (e) {
        print('Error signing in: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'please signup.'),
          ),
        );
      }
    }
  }

  Future<void> _registerWithEmailAndPassword() async {
    if (_formKey.currentState!.validate()) {
      try {
        final email = _emailController.text.trim();
        final password = _passwordController.text.trim();

        // Create a new user with email and password
        final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        String userId = userCredential.user!.uid;
        // If registration is successful, navigate to the next screen
        if (userCredential.user != null) {
          // Get the current location
          Position position = await _getCurrentLocation();
          // Navigate to LocationScreen with latitude and longitude
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to register. Please try again later.'),
            ),
          );
        }
      } catch (e) {
        print('Error registering user: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'please singup.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: _emailValidator,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: _passwordValidator,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Validate the form
                  if (_formKey.currentState!.validate()) {
                    try {
                      // Sign in with email and password
                      final email = _emailController.text.trim();
                      final password = _passwordController.text.trim();
                      final userCredential =
                          await _auth.signInWithEmailAndPassword(
                        email: email,
                        password: password,
                      );

                      // Check if authentication is successful
                      if (userCredential.user != null) {
                        // Get the current location
                        Position position = await _getCurrentLocation();

                        // Navigate to the LocationScreen with the obtained latitude and longitude
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LocationScreen(
                              latitude: position.latitude,
                              longitude: position.longitude,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Failed to sign in. Please check your credentials.'),
                          ),
                        );
                      }
                    } catch (e) {
                      print('Error signing in: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'signup Please and try later.'),
                        ),
                      );
                    }
                  }
                },
                child: Text('Login'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _registerWithEmailAndPassword();
                  if (_auth.currentUser != null) {
                    _startBackgroundLocationTracking();
                  }
                },
                child: Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
