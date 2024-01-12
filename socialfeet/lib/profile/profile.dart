import 'package:flutter/material.dart';
import 'package:socialfeet/authentication/login_screen.dart';
import 'package:socialfeet/editProfile/editProfile.dart';

class User {
  String nameandsurname;
  String email;
  String profileImageUrl;

  User({required this.nameandsurname, required this.email, required this.profileImageUrl});
}

void displayIcons(bool bike, bool run, bool walk) {
  List<String> icons = [];

  if (bike) {
    icons.add('🚴');
  }

  if (run) {
    icons.add('🏃');
  }

  if (walk) {
    icons.add('🚶');
  }

  String iconsString = icons.join('  ');

  print('Icons: $iconsString');
}

class ProfileDisplayScreen extends StatelessWidget {
  final User user;
  final bool bike;
  final bool run;
  final bool walk;
  final String aboutMe;

  ProfileDisplayScreen({
    required this.user,
    required this.bike,
    required this.run,
    required this.walk,
    required this.aboutMe,
  });

  @override
  Widget build(BuildContext context) {
    displayIcons(bike, run, walk);

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ));
            },
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => EditProfileScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
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
                  '${user.nameandsurname}',
                  style: TextStyle(
                    fontSize: 18,
                    height: 1.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  '${calculateAge()} years old, ${userLocation}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (bike) Text('🚴', style: TextStyle(fontSize: 24)),
                    if (run) Text('🏃', style: TextStyle(fontSize: 24)),
                    if (walk) Text('🚶', style: TextStyle(fontSize: 24)),
                  ],
                ),
                SizedBox(height: 16),
                Container(
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
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildBottomBar() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.message),
          label: ' ',
          backgroundColor: Colors.black,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
          backgroundColor: Colors.black,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: ' ',
          backgroundColor: Colors.black,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: ' ',
          backgroundColor: Colors.black,
        ),
      ],
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white.withOpacity(0.6),
      selectedFontSize: 12,
      unselectedFontSize: 12,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.black,
      currentIndex: 3,
      onTap: (index) {
        // Handle navigation items if needed
      },
    );
  }

  int calculateAge() {
    // TODO: Implement the logic to calculate the age based on the user's date of birth
    // For now, return a placeholder value
    return 21;
  }

  String get userLocation => 'Athens';
}

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final TextEditingController searchController = TextEditingController();
  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Handle other navigation items if needed
        break;
      case 1:
        // Handle other navigation items if needed
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MapPage()),
        );
        break;
      case 3:
        User existingUser = User(
          nameandsurname: 'John Doe',
          email: 'john.doe@example.com',
          profileImageUrl: 'URL_TO_YOUR_PROFILE_IMAGE',
        );

        bool bike = true;
        bool run = true;
        bool walk = true;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileDisplayScreen(
              user: existingUser,
              bike: bike,
              run: run,
              walk: walk,
              aboutMe: 'Add your description here',
            ),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: _buildBody(context),
        bottomNavigationBar: _buildBottomBar(),
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
            Colors.teal.withOpacity(0.4),
            Colors.deepPurple.withOpacity(0.4),
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
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              // Your other content here
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.message),
          label: ' ',
          backgroundColor: Colors.black,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
          backgroundColor: Colors.black,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: ' ',
          backgroundColor: Colors.black,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: ' ',
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
      onTap: _onItemTapped,
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User existingUser = User(
      nameandsurname: 'John Doe',
      email: 'john.doe@example.com',
      profileImageUrl: 'URL_TO_YOUR_PROFILE_IMAGE',
    );

    bool bike = true;
    bool run = true;
    bool walk = true;

    return MaterialApp(
      title: 'Your App',
      home: ProfileDisplayScreen(
        user: existingUser,
        bike: bike,
        run: run,
        walk: walk,
        aboutMe: 'Add your description here',
      ),
    );
  }
}
