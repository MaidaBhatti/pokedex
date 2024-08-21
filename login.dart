import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/screens/home.dart';
import 'package:flutter_application_1/screens/signup.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text(
          'Login ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Color.fromARGB(197, 232, 223, 235),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 85, 77, 77),
      ),
    
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('login1.jpg'), // Add your image path here
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              color: Colors.grey.withOpacity(0.8),
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'scary.jpg', 
                      height: 100,
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 12.0),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () async {
                        String email = _emailController.text;
                        String password = _passwordController.text;
                        try {
                          final UserCredential userCredential =
                              await _auth.signInWithEmailAndPassword(
                            email: email,
                            password: password,
                          );
                          String? uid = userCredential.user?.uid;
                          if (uid != null) {
                            await _firestore.collection('users').doc(uid).set({
                              'email': email,
                              'lastLogin': FieldValue.serverTimestamp(),
                            });
                            print('User logged in: $uid');
                            print('Email: $email, Password: $password');

                            // Navigate to home screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(),
                              ),
                            );
                          } else {
                            print('Failed to get user UID.');
                          }
                        } catch (e) {
                          print('Failed to log in: $e');
                        }
                      },
                      child: Text('Login'),
                    ),
                    SizedBox(height: 12.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUpPage(),
                          ),
                        );
                      },
                      child: Text('Sign Up'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
