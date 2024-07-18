import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io'; // For platform detection

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isSignUpScreen = true; // Toggle between Login and Sign Up
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _password = '';
  bool _isLoading = false;

  // Function to dynamically generate the base URL based on the platform
  String getBaseUrl() {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:5000'; // Android emulator
    } else if (Platform.isIOS) {
      return 'http://localhost:5000'; // iOS emulator
    } else {
      return 'http://localhost:5000'; // Web or other platforms
    }
  }

  // Function to handle Login/Sign Up
  Future<void> _authenticate() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      final url = _isSignUpScreen ? '${getBaseUrl()}/signup' : '${getBaseUrl()}/login'; // Dynamic URL
      final body = _isSignUpScreen
          ? {
        'name': _name,
        'email': _email,
        'password': _password,
      }
          : {
        'email': _email,
        'password': _password,
      };

      try {
        // Make HTTP request
        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json', // Set content type to JSON
          },
          body: json.encode(body), // Convert body to JSON
        );

        if (response.statusCode == 200) {
          // Handle successful response
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(_isSignUpScreen ? 'Sign Up successful!' : 'Login successful!'),
          ));

          // Navigate to FeatureSelectionScreen on successful login
          Navigator.pushReplacementNamed(context, '/featureSelection');
        } else {
          // Handle errors
          final responseData = json.decode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(responseData['message']),
          ));
        }
      } catch (error) {
        // Handle network error
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Something went wrong!'),
        ));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Image.asset(
                    'assets/images/logo.jpg',
                    height: 100,
                    width: 100,
                  ),
                  SizedBox(height: 20),

                  // Title
                  Text(
                    _isSignUpScreen ? 'Create Your WatchMan ID' : 'Login with your Watchman ID',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),

                  // Name field (only for Sign Up)
                  if (_isSignUpScreen)
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _name = value!;
                      },
                    ),
                  SizedBox(height: 20),

                  // Email field
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _email = value!;
                    },
                  ),
                  SizedBox(height: 20),

                  // Password field
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _password = value!;
                    },
                  ),
                  SizedBox(height: 20),

                  // Social Media Login Buttons (Using SVG icons)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Google Login
                      IconButton(
                        icon: SvgPicture.asset(
                          'assets/images/google.svg',
                          height: 30,
                          width: 30,
                        ),
                        onPressed: () {
                          // Handle Google Login
                        },
                      ),

                      // Facebook Login
                      IconButton(
                        icon: SvgPicture.asset(
                          'assets/images/facebook.svg',
                          height: 30,
                          width: 30,
                        ),
                        onPressed: () {
                          // Handle Facebook Login
                        },
                      ),

                      // GitHub Login
                      IconButton(
                        icon: SvgPicture.asset(
                          'assets/images/github.svg',
                          height: 30,
                          width: 30,
                        ),
                        onPressed: () {
                          // Handle GitHub Login
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // Submit button
                  _isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                    onPressed: _authenticate,
                    child: Text(_isSignUpScreen ? 'Sign Up' : 'Login'),
                  ),

                  SizedBox(height: 20),

                  // Toggle between Sign Up and Login
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isSignUpScreen = !_isSignUpScreen;
                      });
                    },
                    child: Text(
                      _isSignUpScreen ? 'Already have an account? Login' : 'Don’t have an account? Sign Up',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
