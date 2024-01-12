import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:socialfeet/main.dart';
import 'package:socialfeet/profile/editProfile.dart';

import 'package:socialfeet/messages/messages.dart';
import 'package:socialfeet/home/home.dart';
import 'package:socialfeet/map/map.dart';
//import 'package:socialfeet/profile/profile.dart';

class ProfilePage extends StatelessWidget {
  int _selectedIndex = 3; // Assuming 'Home' is the default selected item.

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final DatabaseReference usersRef = FirebaseDatabase.instance.ref('users');

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Start()),
                (Route<dynamic> route) =>
                    false, // This predicate will always return false, thus clearing all previous routes
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => EditProfileScreen()));

            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _getUserData(auth, usersRef),
        builder: (context, AsyncSnapshot<UserData> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            UserData user = snapshot.data!;
            return _buildUserProfile(context, user);
          } else {
            return Center(child: Text("No user data available"));
          }
        },
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Future<UserData> _getUserData(
      FirebaseAuth auth, DatabaseReference usersRef) async {
    User? currentUser = auth.currentUser;
    if (currentUser == null || currentUser.email == null) {
      throw Exception("User not logged in or email not available");
    }

    Query query = usersRef.orderByChild('email').equalTo(currentUser.email);
    DatabaseEvent event = await query.once();
    DataSnapshot snapshot = event.snapshot;

    if (snapshot.exists && snapshot.value is Map) {
      Map<dynamic, dynamic> usersMap = snapshot.value as Map<dynamic, dynamic>;
      if (usersMap.isNotEmpty) {
        Map<dynamic, dynamic> userData = usersMap.values.first;
        return UserData.fromMap(userData as Map<dynamic, dynamic>);
      }
    }
    throw Exception("User data not found");
  }

  Widget _buildUserProfile(BuildContext context, UserData user) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(1, 0),
          end: Alignment(0, 1),
          colors: [
            Colors.teal.withOpacity(0.4),
            Colors.deepPurple.withOpacity(0.4),
          ],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(user.profileImageUrl),
              ),
              SizedBox(height: 16),
              Text(
                '${user.name}',
                style: TextStyle(
                  fontSize: 18,
                  height: 1.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              Text(
                '${user.location}', // Replace with dynamic data if available
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              _buildActivityIcons(user),
              SizedBox(height: 16),
              _buildAboutMeSection(user.aboutMe),
            ],
          ),
        ),
      ),
    );
  }
Widget _buildActivityIcons(UserData user) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      if (user.showBike)
        Text('🚴', style: TextStyle(fontSize: 24)),
      if (user.showRun) 
        Text('🏃', style: TextStyle(fontSize: 24)),
      if (user.showWalk)
        Text('🚶', style: TextStyle(fontSize: 24)),
    ],
  );
}

  Widget _buildAboutMeSection(String aboutMe) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About me:',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFFFFFFFF),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 16),
            padding: EdgeInsets.all(12),
            width: 300,
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.teal.withOpacity(0.4),
                  Colors.deepPurple.withOpacity(0.4),
                ],
              ),
              borderRadius: BorderRadius.all(Radius.circular(0)),
              border: Border.all(color: Colors.black, width: 1),
            ),
            child: Text(
              aboutMe,
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.message),
          label: '',
          backgroundColor: Colors.black,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '',
          backgroundColor: Colors.black,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: '',
          backgroundColor: Colors.black,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
          backgroundColor: Colors.black,
        ),
      ],
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white.withOpacity(0.6),
      selectedFontSize: 12,
      unselectedFontSize: 12,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.black,
      currentIndex: _selectedIndex,
      onTap: (index) => _onItemTapped(index, context), // Pass context here
    );
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MessagesPage()));
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
        break;
      case 2:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MapPage()));
        break;
      case 3:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ProfilePage()));
        break;
    }
  }
}

class UserData {
  String name;
  String email;
  String profileImageUrl;
  String location;
  bool showBike;
  bool showRun;
  bool showWalk;
  String aboutMe;

  UserData({
    required this.name,
    required this.email,
    required this.profileImageUrl,
    required this.location,
    required this.showBike,
    required this.showRun,
    required this.showWalk,
    required this.aboutMe,
  });

  factory UserData.fromMap(Map<dynamic, dynamic> data) {
    return UserData(
      name: data['fullname'] ?? 'No Name',
      email: data['email'] ?? 'No Email',
      profileImageUrl:
          data['profileImageUrl'] ?? 'https://via.placeholder.com/150',
      location:
          data['location'] ?? '',
      showBike: data['bicycle']['enabled'] ?? false,
      showRun: data['running']['enabled'] ?? false,
      showWalk: data['walking']['enabled'] ?? false,
      aboutMe: data['aboutMe'] ?? 'No Description',
    );
  }
}
