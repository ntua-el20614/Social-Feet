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
        showBike: value['bicycle']['enabled'] ?? false,
        showRun: value['running']['enabled'] ?? false,
        showWalk: value['walking']['enabled'] ?? false,
      );
      userProfiles.add(user);
    });
  }else{
    print("No users found!");
  }
  return userProfiles;
}

class UserProfile {
  final String name;
  final String username; 

  final bool showBike;
  final bool showRun;
  final bool showWalk;

  UserProfile(
      {required this.name,
          required this.username, 

      this.showBike = false,
      this.showRun = false,
      this.showWalk = false});
}

class HomePage extends StatefulWidget {
  bool filterBike;
  bool filterRun;
  bool filterWalk;

  HomePage({
    Key? key,
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
/*
  final List<UserProfile> userProfiles = [
    UserProfile(name: 'Kennedy', showBike: false, showRun: false, showWalk: false), // we see no "kennedy"
    UserProfile(name: 'Joey Mills', showBike: false, showRun: false, showWalk: true),
    UserProfile(name: 'Elizabeth Bathory', showBike: false, showRun: true, showWalk: false),
    UserProfile(name: 'Alan Wake', showBike: false, showRun: true, showWalk: true),
    UserProfile(name: 'Rachel Forest', showBike: true, showRun: false, showWalk: false),
    UserProfile(name: 'Rachel Tree', showBike: true, showRun: false, showWalk: true),
    UserProfile(name: 'Anderson', showBike: true, showRun: true, showWalk: false),
    UserProfile(name: 'John Cena', showBike: true, showRun: true, showWalk: true),
    UserProfile(name: 'John Locke', showBike: false, showRun: true, showWalk: false),
    UserProfile(name: 'John Kennedy', showBike: false, showRun: false, showWalk: true),
  ]*/

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
          "Profile: ${profile.name}, Bike: ${profile.showBike}, Run: ${profile.showRun}, Walk: ${profile.showWalk}");
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
      if (widget.filterBike && profile.showBike) {
        matchesFilter = true;
      }
      if (widget.filterRun && profile.showRun) {
        matchesFilter = true;
      }
      if (widget.filterWalk && profile.showWalk) {
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
        controller: searchController,
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
              ),
            ),
          );

          if (result != null) {
            setState(() {
              widget.filterBike = result['filterBike'];
              widget.filterRun = result['filterRun'];
              widget.filterWalk = result['filterWalk'];
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
                    imageUrl: 'https://via.placeholder.com/155x95',
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

  Widget _buildCharacterCard(BuildContext context,
      {required UserProfile profile, required String imageUrl}) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BuddyProfile(
              username:
                  profile.username, // Pass the encoded email identifier
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
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.network(imageUrl, fit: BoxFit.cover),
              ),
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
