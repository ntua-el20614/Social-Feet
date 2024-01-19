// shake_to_navigate.dart

import 'package:flutter/material.dart';
import 'package:shake_event/shake_event.dart';
import 'package:socialfeet/profile/profile.dart';

class ShakeToNavigate extends StatefulWidget {
  @override
  _ShakeToNavigateState createState() => _ShakeToNavigateState();
}

class _ShakeToNavigateState extends State<ShakeToNavigate> with ShakeHandler {
  @override
  void initState() {
    super.initState();
    startListeningShake(20); // Adjust sensitivity as needed
  }

  @override
  void shakeListener() {
    // Navigate to the profile page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfilePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Shake your phone to go to your profile page.'),
    );
  }
}
