import 'package:flutter/material.dart';

import 'package:socialfeet/messages/messages.dart';
import 'package:socialfeet/home/home.dart';
//import 'package:socialfeet/map/map.dart';
import 'package:socialfeet/profile/profile.dart';


class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final TextEditingController searchController = TextEditingController();
  int _selectedIndex = 2; // Assuming 'Home' is the default selected item.



  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MapPage()));
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

          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              
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
            backgroundColor: Colors.black),
        BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
            backgroundColor: Colors.black),
        BottomNavigationBarItem(
            icon: Icon(Icons.map), label: 'Map', backgroundColor: Colors.black),
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
