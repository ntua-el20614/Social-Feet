import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        decoration: _boxDecoration(),
        child: Center(
          // Use Center to align widgets vertically
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _welcomeBox(),
              SizedBox(height: 40),
              _inputField(screenWidth, 'Email'),
              _inputField(screenWidth, 'Password'),
              Padding(
                padding: EdgeInsets.only(
                    left: screenWidth * 0.1
                    ), // Adjust padding to align with input fields
                child: _forgotPassword(),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: screenWidth *
                        0.1), // Adjust padding to align with input fields
                child: _rememberMeCheckbox(),
              ),
              SizedBox(height: 300),
              _actionButton(context, 'Login', Color(0xFF8846DF), '/login'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _welcomeBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      color: Color(0x4D8846DF), // 30% opacity
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              // Go back logic
            },
          ),
          Text('Welcome back!',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
          SizedBox(width: 24), // Placeholder for alignment
        ],
      ),
    );
  }

  Widget _inputField(double screenWidth, String label) {
    return Container(
      width: screenWidth * 0.8, // 80% of screen width
      margin: EdgeInsets.only(top: 20),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
                15), // Increased border radius for a more curved look
          ),
        ),
      ),
    );
  }

  Widget _actionButton(
      BuildContext context, String text, Color color, String routeName) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, routeName); // Add navigation logic
        },
        style: ElevatedButton.styleFrom(
          primary: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(48),
          ),
          minimumSize: Size(182, 43), // Set the size here
        ),
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
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

  Widget _forgotPassword() {
    return Align(
      
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
    );
  }

  Widget _rememberMeCheckbox() {
    return Row(
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
    );
  }
}
