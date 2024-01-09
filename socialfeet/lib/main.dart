import 'package:flutter/material.dart';

import '/authentication/login_screen.dart';
import '/authentication/register_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SocialFeet',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Start(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
      },
    );
  }
}

class Start extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Obtain the screen size
    var screenSize = MediaQuery.of(context).size;
    
    double containerWidth = screenSize.width; 
    double containerHeight = screenSize.height; 

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          // Makes the content scrollable
          child: Container(
            width: containerWidth,
            height: containerHeight,
            clipBehavior: Clip.antiAlias,
            decoration: _boxDecoration(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _logoSection(context),
                _titleText('Find your fitness buddy!'),
                _actionButton(context, 'Login', Color(0xFF8846DF), '/login'),
                _actionButton(
                    context, 'Register', Color(0xFF36DDA6), '/register'),
              ],
            ),
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

  Widget _logoSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Text(
            'SocialFeet',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.w700, color: Colors.black),
          ),
          SizedBox(height: 52), // This SizedBox acts as a margin of 52px

          Image.asset(
            './lib/photos/logo.png',
            width: 198, // Set width to 198px
            height: 198, // Set height to 198px
            fit: BoxFit
                .cover, // Cover ensures the image covers the box without changing aspect ratio
          ), // Make sure this path matches the one in your pubspec.yaml
        ],
      ),
    );
  }

  Widget _titleText(String text) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(children: [
          SizedBox(height: 52), // This SizedBox acts as a margin of 52px

          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.w700, color: Colors.black),
          ),
          SizedBox(height: 52), // This SizedBox acts as a margin of 52px
        ]));
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
          style:
              TextStyle(color: Colors.white), // Change the text color to black
        ),
      ),
    );
  }
}

