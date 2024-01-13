import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:socialfeet/home/home.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:socialfeet/profile/editSports.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController dobController =
      TextEditingController(); // Date of Birth

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  Future<bool> registerUser(context, String email, String password,
      String fullname, String username, String location) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      _saveUserDataToDatabase(email, username, fullname,location);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Successful Registration")),
      );
      return true;
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase Auth errors here
      final String errorMessage = e.message ?? "Unknown error occurred";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $errorMessage")),
      );
      return false;
    } catch (e) {
      // Handle other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("General Error: $e")),
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    double containerWidth = screenSize.width;
    double containerHeight = screenSize.height;

    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: containerWidth,
        height: containerHeight,
        decoration: _boxDecoration(),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 100),
              _welcomeBox(context),
              SizedBox(height: 20),
              _inputField(screenWidth, 'Username', usernameController),
              _inputField(screenWidth, 'Fullname', fullnameController),
              _inputField(screenWidth, 'Email', emailController),
              _inputField(screenWidth, 'Password', passwordController,
                  isPassword: true),
              _inputField(
                  screenWidth, 'Confirm Password', confirmPasswordController,
                  isPassword: true),
              _inputField(screenWidth, 'Location (City)', dobController),
              SizedBox(height: 30),
              Text(
                'By registering, you are agreeing to our\nTerms of Use and Privacy Policy.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),
              _registerButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _welcomeBox(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      color: Color.fromARGB(70, 54, 221, 166),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Text('Welcome!',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
          SizedBox(width: 24), // Placeholder for alignment
        ],
      ),
    );
  }

  Widget _inputField(
      double screenWidth, String label, TextEditingController controller,
      {bool isPassword = false}) {
    return Container(
      width: screenWidth * 0.8,
      margin: EdgeInsets.only(top: 20),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        obscureText: isPassword,
      ),
    );
  }

  Widget _registerButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final String email = emailController.text.trim();
        final String password = passwordController.text.trim();
        final String username = usernameController.text.trim();
        final String fullname = fullnameController.text.trim();
        final String location = dobController.text.trim();

        bool isRegistered =
            await registerUser(context, email, password, fullname, username,location);
        if (isRegistered) {
          _saveUserDataToDatabase(email, username, fullname,location);
          if (isRegistered) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("User registered successfully!")),
            );

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditSportsScreen()),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Invalid input or password mismatch")),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        primary: Color(0xFF36DDA6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(48),
        ),
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      ),
      child: Text(
        'Register',
        style: TextStyle(color: Colors.white, fontSize: 16),
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

  void _saveUserDataToDatabase(String email, String username, String fullname, String location) {
    // Encode the email to be a valid Firebase key
    try {
      String encodedEmail = email.split('@').first.replaceAll('.', ',');
      DatabaseReference userRef = _database.ref("users/$encodedEmail");

      userRef.set({
        'email': email,
        'aboutMe': '',
        'username': username,
        'fullname': fullname,
        'location':location,
        'running': {
          'distance': 0,
          'enabled': false,
          'speed': 0,
        },
        'bicycle': {
          'distance': 0,
          'enabled': false,
          'speed': 0,
        },
        'walking': {
          'distance': 0,
          'enabled': false,
          'speed': 0,
        },
      }).then((_) {
        print("User data saved successfully");
      }).catchError((error) {
        print("Error saving user data: $error");
      });
    } catch (e) {
      print("An exception occurred: $e");
    }
  }
}
