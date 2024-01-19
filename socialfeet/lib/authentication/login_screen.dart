import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:socialfeet/home/home.dart';
 

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // Log the error code and message for more detailed information
      return null;
    } catch (e) {

      return null;
    }
  }
}

class DatabaseService {
  final FirebaseDatabase _database =
      FirebaseDatabase(databaseURL: "https://console.firebase.google.com/u/0/project/socialfeet-c8776/database/socialfeet-c8776-default-rtdb/data/~2F");

  DatabaseReference getReference() {
    return _database.reference();
  }
}

class LoginScreen extends StatelessWidget {
  final AuthService _auth = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        decoration: _boxDecoration(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                color: Color(0x4D8846DF),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        Navigator.pop(
                            context); // Navigate back to the previous screen
                      },
                    ),
                    Text(
                      'Welcome back!',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 24),
                  ],
                ),
              ),
              SizedBox(height: 40),
              Container(
                width: screenWidth * 0.8,
                margin: EdgeInsets.only(top: 20),
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              Container(
                width: screenWidth * 0.8,
                margin: EdgeInsets.only(top: 20),
                child: TextFormField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    fillColor: Colors.white,
                    filled: true, 
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: screenWidth * 0.1),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {
                      // Forgot password logic
                    },
                    child: Text(
                      'I forgot my password...',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: screenWidth * 0.1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: false, // Bind this to a state variable
                      onChanged: (bool? value) {
                        // Handle change
                      },
                    ),
                    Text('Remember me'),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ElevatedButton(
                  onPressed: () async {
                    final String email = emailController.text.trim();
                    final String password = passwordController.text.trim();

                    if (email.isNotEmpty && password.isNotEmpty) {
                      try {
                        final User? user = await _auth
                            .signInWithEmailAndPassword(email, password);

                        if (user != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('Login failed. Check your credentials.'),
                            ),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Error signing in. Please try again later.'),
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text('Please enter both email and password.'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF8846DF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(48),
                    ),
                    minimumSize: Size(182, 43),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment(-0.21, -0.98),
        end: Alignment(0.21, 0.98),
        colors: [Color(0x4C36DDA6), Color(0x4C8846DF)],
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: LoginScreen(),
  ));
}
