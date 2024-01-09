import 'package:flutter/material.dart';

import 'package:socialfeet/messages/messages.dart';
import 'package:socialfeet/home/home.dart';
import 'package:socialfeet/map/map.dart';
import 'package:socialfeet/profile/profile.dart';


class UserProfile {
  final String name;
  final bool showBike;
  final bool showRun;
  final bool showWalk;

  UserProfile(
      {required this.name,
      this.showBike = false,
      this.showRun = false,
      this.showWalk = false});
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController searchController = TextEditingController();
  int _selectedIndex = 1; // Assuming 'Home' is the default selected item.

  final List<UserProfile> userProfiles = [
    UserProfile(
        name: 'Kennedy', showBike: true, showRun: false, showWalk: true),
    UserProfile(
        name: 'Joey Mills', showBike: true, showRun: false, showWalk: true),
    UserProfile(
        name: 'Elizabeth Bathory', showBike: true, showRun: false, showWalk: true),
    UserProfile(
        name: 'Alan Wake', showBike: true, showRun: false, showWalk: true),
    UserProfile(
        name: 'Rachel Forest', showBike: true, showRun: false, showWalk: true),
    UserProfile(
        name: 'Rachel Tree', showBike: true, showRun: false, showWalk: false),
    UserProfile(
        name: 'Anderson', showBike: false, showRun: false, showWalk: true),
    UserProfile(
        name: 'John Cena', showBike: true, showRun: true, showWalk: true),
    UserProfile(
        name: 'John Locke', showBike: false, showRun: true, showWalk: true),
    UserProfile(
        name: 'John Kennedy', showBike: true, showRun: true, showWalk: false),
  ];

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
        onPressed: () {},
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
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
                itemCount: userProfiles.length,
                itemBuilder: (context, index) {
                  return _buildCharacterCard(
                    context,
                    profile: userProfiles[index],
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
    return Container(
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
