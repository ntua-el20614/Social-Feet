import 'package:flutter/material.dart';

class BuddyProfile extends StatelessWidget {
  final String name;
  final bool showBike;
  final bool showRun;
  final bool showWalk;
  final double bikeSpeed;
  final double bikeDistance;
  final double runSpeed;
  final double runDistance;
  final double walkSpeed;
  final double walkDistance;

  BuddyProfile({
    Key? key,
    required this.name,
    this.showBike = false,
    this.showRun = false,
    this.showWalk = false,
    this.bikeSpeed = 0.0,
    this.bikeDistance = 0.0,
    this.runSpeed = 0.0,
    this.runDistance = 0.0,
    this.walkSpeed = 0.0,
    this.walkDistance = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(1, 0),
            end: Alignment(0, 1),
            colors: [
              Colors.teal.withOpacity(0.4),
              Colors.deepPurple.withOpacity(0.4)
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 75, 16, 0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, size: 30),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
              // ... existing widgets ...
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.white, // Border color
                child: CircleAvatar(
                  radius: 55, // Slightly smaller to show the white border
                  backgroundImage: NetworkImage(""), // Use imagePath for profile picture
                  backgroundColor: Colors.grey, // Placeholder color if the image fails to load
                )),
              SizedBox(height: 20),
              Text(
                name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "21 years old, lives in Athens",
                style: TextStyle(
                    fontSize: 18, color: Colors.black.withOpacity(0.6)),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {}, // Implement message button action
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  shape: CircleBorder(),
                ),
                child: Text(
                  '💬',
                  style: TextStyle(fontSize: 24),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.1),
                decoration: _boxDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("about me",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black.withOpacity(0.6))),
                    SizedBox(height: 5),
                    Text("is something important"),
                  ],
                ),
              ),
              SizedBox(height: 20),
              SizedBox(height: 20),
              
              if (showBike)
                _buildActivityBox('Biking🚴', bikeSpeed, bikeDistance),
              SizedBox(height: 20),
              if (showRun) _buildActivityBox('Running🏃', runSpeed, runDistance),
              SizedBox(height: 20),
              if (showWalk)
                _buildActivityBox('Walking🚶', walkSpeed, walkDistance),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityBox(String activity, double speed, double distance) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$activity',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text('Average Speed: ${speed.toStringAsFixed(2)} km/h'),
          Text('Total Distance: ${distance.toStringAsFixed(2)} km'),
        ],
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment(0, 1),
        end: Alignment(1, 0),
        colors: [
          Colors.teal.withOpacity(0.4),
          Colors.deepPurple.withOpacity(0.4)
        ],
      ),
      border: Border.all(color: Colors.black, width: 1.5),
      borderRadius: BorderRadius.circular(10),
    );
  }

   
}
