import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home.dart';

class SignUpPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Sign Up Failed'),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text(
          'Sign Up',
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
            image: AssetImage('signup.jpg'), 
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              color: const Color.fromARGB(255, 206, 195, 195),
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                              await _auth.createUserWithEmailAndPassword(
                            email: email,
                            password: password,
                          );
                          String uid = userCredential.user!.uid;
                          await _firestore.collection('users').doc(uid).set({
                            'email': email,
                            'registrationDate': FieldValue.serverTimestamp(),
                          });
                          print('User signed up: $uid');
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ),
                          );
                        } catch (e) {
                          print('Failed to sign up: $e');
                          if (e is FirebaseAuthException) {
                            if (e.code == 'invalid-email') {
                              _showErrorDialog(
                                  context, 'The email address is badly formatted.');
                            } else if (e.code == 'email-already-in-use') {
                              _showErrorDialog(
                                  context, 'The email address is already in use by another account.');
                            } else {
                              _showErrorDialog(context, 'An unknown error occurred.');
                            }
                          }
                        }
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
