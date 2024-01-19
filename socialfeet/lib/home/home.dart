import 'package:flutter/material.dart';

import 'package:socialfeet/messages/messages.dart';
//import 'package:socialfeet/home/home.dart';
import 'package:socialfeet/map/map.dart';
import 'package:socialfeet/profile/profile.dart';

import 'package:socialfeet/home/buddy_profile.dart';
import 'package:socialfeet/home/home_filter.dart';
import 'package:firebase_database/firebase_database.dart';

Future<List<UserProfile>> fetchUserProfilesFromDatabase() async {
  DatabaseReference usersRef = FirebaseDatabase.instance.ref('users');
  DatabaseEvent event = await usersRef.once();
  List<UserProfile> userProfiles = [];

  if (event.snapshot.exists) {
    Map<dynamic, dynamic> usersMap =
        event.snapshot.value as Map<dynamic, dynamic>;
    usersMap.forEach((key, value) {
      var user = UserProfile(
        name: value['fullname'] ??
            'Unknown', // Replace 'Unknown' with a default name if username is not present
        username: value['username'],
        location: value['location'],
        photo: value['profileImageUrl'] ?? '',
        showBike: value['bicycle']['enabled'] ?? false,
        showRun: value['running']['enabled'] ?? false,
        showWalk: value['walking']['enabled'] ?? false,
      );
      userProfiles.add(user);
    });
  } else {
    print("No users found!");
  }
  return userProfiles;
}

class UserProfile {
  final String name;
  final String username;
  final String photo;
  final String location;
  final bool showBike;
  final bool showRun;
  final bool showWalk;

  UserProfile(
      {required this.name,
      required this.username,
      required this.location,
      this.photo = "",
      this.showBike = false,
      this.showRun = false,
      this.showWalk = false});
}

class HomePage extends StatefulWidget {
  bool filterBike;
  bool filterRun;
  bool filterWalk;
  String filterLocation;

  HomePage({
    Key? key,
    this.filterLocation = "",
    this.filterBike = true,
    this.filterRun = true,
    this.filterWalk = true,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController searchController = TextEditingController();
  int _selectedIndex = 1; // Assuming 'Home' is the default selected item.

  List<UserProfile> userProfiles = [];

  @override
  void initState() {
    super.initState();
    loadUserProfiles();
  }

  void loadUserProfiles() async {
    List<UserProfile> profiles = await fetchUserProfilesFromDatabase();
    for (var profile in profiles) {
      print(
          "Profile: ${profile.name}, Location: ${profile.location} , Bike: ${profile.showBike}, Run: ${profile.showRun}, Walk: ${profile.showWalk}");
    }

    setState(() {
      userProfiles = profiles; // Update the state with fetched profiles
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

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

  List<UserProfile> getFilteredProfiles() {
    return userProfiles.where((profile) {
      bool matchesFilter = false;

      if (widget.filterBike &&
          profile.showBike &&
          (widget.filterLocation == profile.location ||
              widget.filterLocation == "")) {
        matchesFilter = true;
      }
      if (widget.filterRun &&
          profile.showRun &&
          (widget.filterLocation == profile.location ||
              widget.filterLocation == "")) {
        matchesFilter = true;
      }
      if (widget.filterWalk &&
          profile.showWalk &&
          (widget.filterLocation == profile.location ||
              widget.filterLocation == "")) {
        matchesFilter = true;
      }
      return matchesFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: _buildAppBar(context),
        body: _buildBody(context),
        bottomNavigationBar: _buildBottomBar(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: TextField(
        decoration: InputDecoration(
          hintText: 'Choose your Buddy!',
          border: InputBorder.none,
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.filter_list),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeFilter(
                filterBike: widget.filterBike,
                filterRun: widget.filterRun,
                filterWalk: widget.filterWalk,
                filterLocation: widget.filterLocation,
              ),
            ),
          );

          if (result != null) {
            setState(() {
              widget.filterBike = result['filterBike'];
              widget.filterRun = result['filterRun'];
              widget.filterWalk = result['filterWalk'];
              widget.filterLocation = result['filterLocation'];
            });
          }
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (userProfiles.isEmpty) {
      return Center(
          child:
              CircularProgressIndicator()); // Show loading indicator while data is loading
    }
    List<UserProfile> filteredProfiles = getFilteredProfiles();

    if (filteredProfiles.isEmpty) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 3),
          gradient: LinearGradient(
            begin: Alignment(1, 0),
            end: Alignment(0, 1),
            colors: [
              Colors.teal.withOpacity(0.75),
              Colors.deepPurple.withOpacity(0.75)
            ],
          ),
        ),
        child: Center(
          child: Text(
            "No users in this location based on your filters",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 3),
        gradient: LinearGradient(
          begin: Alignment(1, 0),
          end: Alignment(0, 1),
          colors: [
            Colors.teal.withOpacity(0.75),
            Colors.deepPurple.withOpacity(0.75)
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: Colors.green.withOpacity(0.3),
            width: double.infinity,
            padding: EdgeInsets.all(10),
            child: _buildTitle(),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisExtent: 158,
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                ),
                physics: BouncingScrollPhysics(),
                itemCount: filteredProfiles.length,
                itemBuilder: (context, index) {
                  return _buildCharacterCard(
                    context,
                    profile: filteredProfiles[index],
                    imageUrl: './lib/photos/nophoto.png',
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'Find your Buddy',
      style: TextStyle(
        color: Colors.black,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildImage(String imageUrl) {
    if (imageUrl.startsWith('http') || imageUrl.startsWith('https')) {
      return Image.network(imageUrl, fit: BoxFit.cover);
    } else {
      return Image.asset(imageUrl, fit: BoxFit.cover);
    }
  }

  Widget _buildCharacterCard(BuildContext context,
      {required UserProfile profile, required String imageUrl}) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BuddyProfile(
              username: profile.username, // Pass the encoded email identifier
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Expanded(
            child: profile.photo.isNotEmpty
                ? Image.network(profile.photo, fit: BoxFit.cover)
                : Image.asset("lib/photos/nophoto.png", fit: BoxFit.cover),
          ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(profile.name,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (profile.showBike)
                  _buildActivityIcon(Icons.directions_bike, '🚴'),
                if (profile.showRun) _buildActivityIcon(Icons.run_circle, '🏃'),
                if (profile.showWalk)
                  _buildActivityIcon(Icons.directions_walk, '🚶'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityIcon(IconData icon, String emoji) {
    return Column(
      children: [
        //Icon(icon),
        Text(emoji, style: TextStyle(fontSize: 24)),
      ],
    );
  }

  Widget _buildBottomBar() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: ' ',
            backgroundColor: Colors.black),
        BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.black),
        BottomNavigationBarItem(
            icon: Icon(Icons.map), label: ' ', backgroundColor: Colors.black),
        BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: ' ',
            backgroundColor: Colors.black),
      ],
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white.withOpacity(0.6),
      selectedFontSize: 12,
      unselectedFontSize: 12,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.black,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
    );
  }
}
