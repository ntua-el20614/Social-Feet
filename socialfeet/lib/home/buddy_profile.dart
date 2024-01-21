import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:socialfeet/messages/message_page.dart';

class BuddyProfile extends StatefulWidget {
  final String username;

  BuddyProfile({Key? key, required this.username}) : super(key: key);

  @override
  _BuddyProfileState createState() => _BuddyProfileState();
}

class _BuddyProfileState extends State<BuddyProfile> {
  String name = "";
  String profileImageUrl = "";
  String email = "";
  bool showBike = false;
  bool showRun = false;
  bool showWalk = false;
  double bikeSpeed = 0.0;
  double bikeDistance = 0.0;
  double runSpeed = 0.0;
  double runDistance = 0.0;
  double walkSpeed = 0.0;
  double walkDistance = 0.0;
  String aboutMe = "";
  String location = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    DatabaseReference userRef =
        FirebaseDatabase.instance.ref('users/${widget.username}');
    DatabaseEvent event = await userRef.once();

    if (event.snapshot.exists) {
      var userData = event.snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        name = userData['fullname'] ?? '';
        email = userData['email'] ?? '';
        profileImageUrl =
            userData['profileImageUrl'] ?? './lib/photos/nophoto.png';
        showBike = userData['bicycle']['enabled'] ?? false;
        bikeSpeed = userData['bicycle']['speed']?.toDouble() ?? 0.0;
        bikeDistance = userData['bicycle']['distance']?.toDouble() ?? 0.0;
        showRun = userData['running']['enabled'] ?? false;
        runSpeed = userData['running']['speed']?.toDouble() ?? 0.0;
        runDistance = userData['running']['distance']?.toDouble() ?? 0.0;
        showWalk = userData['walking']['enabled'] ?? false;
        walkSpeed = userData['walking']['speed']?.toDouble() ?? 0.0;
        walkDistance = userData['walking']['distance']?.toDouble() ?? 0.0;
        aboutMe = userData['aboutMe'] ?? '';
        location = userData['location'] ?? '';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
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
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 55,
                        backgroundImage: profileImageUrl.isNotEmpty
                            ? NetworkImage(profileImageUrl)
                                as ImageProvider<Object>
                            : AssetImage("./lib/photos/nophoto.png")
                                as ImageProvider<Object>,
                        backgroundColor: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      name,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      aboutMe,
                      style: TextStyle(
                          fontSize: 18, color: Colors.black.withOpacity(0.6)),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Message_Chat(
                              receiverEmail: email,
                              //receiverProfileImageUrl: profileImageUrl,
                              receiverName: name,
                            ),
                          ),
                        );
                      }, // Implement message button action
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        // ... rest of the style code
                      ),
                      child: Text(
                        '💬',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                    Text(
                      location,
                      style: TextStyle(
                          fontSize: 18, color: Colors.black.withOpacity(0.6)),
                    ),
                    SizedBox(height: 20),
                    if (showBike)
                      _buildActivityBox('Biking🚴', bikeSpeed, bikeDistance),
                    SizedBox(height: 20),
                    if (showRun)
                      _buildActivityBox('Running🏃', runSpeed, runDistance),
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
