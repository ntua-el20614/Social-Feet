import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    double containerWidth = screenSize.width; // 90% of the screen width
    double containerHeight =
        screenSize.height; // 80% of the screen height, adjust as needed

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
              SizedBox(height: 100), // Adjust as needed
              _welcomeBox(),
              SizedBox(height: 20),
              _inputField(screenWidth, 'Name'),
              _inputField(screenWidth, 'Surname'),
              _inputField(screenWidth, 'Email / Phone'),
              _inputField(screenWidth, 'Password', isPassword: true),
              _inputField(screenWidth, 'Confirm Password', isPassword: true),
              _inputField(screenWidth,
                  'Date of Birth'), // Adjust for date picker or similar
              SizedBox(height: 30),
              Text(
                'By registering, you are agreeing to our\nTerms of Use and Privacy Policy.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14, // Smaller font size
                  fontWeight: FontWeight.bold, // Bolder text
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

  Widget _welcomeBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      color: Color.fromARGB(70, 54, 221, 166),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              // Go back logic
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

  Widget _inputField(double screenWidth, String label,
      {bool isPassword = false}) {
    return Container(
      width: screenWidth * 0.8,
      margin: EdgeInsets.only(top: 20),
      child: TextFormField(
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
      onPressed: () {
        // Registration logic
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
}
