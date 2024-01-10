import 'package:flutter/material.dart';
import '/firebase_service.dart';

class Start extends StatefulWidget {
  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  final FirebaseService firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    var data = await firebaseService.readData('your_data_path');
    // Do something with the data
    print('Loaded data: $data');
  }

  @override
  Widget build(BuildContext context) {
    // Build your Start screen UI here
    return Scaffold(
      // Your Start screen layout
    );
  }
}
