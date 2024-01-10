import 'package:flutter/material.dart';


import 'package:socialfeet/messages/messages.dart';
import 'package:socialfeet/home/home.dart';
import 'package:socialfeet/map/map.dart';
import 'package:socialfeet/profile/profile.dart';

class HomeFilter extends StatefulWidget {
  bool filterBike;
  bool filterRun;
  bool filterWalk;

  HomeFilter({
    Key? key,
    required this.filterBike,
    required this.filterRun,
    required this.filterWalk,
  }) : super(key: key);

  @override
  _HomeFilterState createState() => _HomeFilterState();
}

class _HomeFilterState extends State<HomeFilter> {
  int _selectedIndex = 1; // Assuming 'Home' is the default selected item.

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose your filters!'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-0.21, -0.98),
            end: Alignment(0.21, 0.98),
            colors: [Color(0x4C36DDA6), Color(0x4C8846DF)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: ElevatedButton(
                child: Text('Apply Filters'),
                onPressed: () {
                  Navigator.pop(context, {
                    'filterBike': widget.filterBike,
                    'filterRun': widget.filterRun,
                    'filterWalk': widget.filterWalk,
                  });
                },
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _filterButton('🚴 Bike', widget.filterBike, () {
                      setState(() => widget.filterBike = !widget.filterBike);
                    }),
                    _filterButton('🏃 Run', widget.filterRun, () {
                      setState(() => widget.filterRun = !widget.filterRun);
                    }),
                    _filterButton('🚶 Walk', widget.filterWalk, () {
                      setState(() => widget.filterWalk = !widget.filterWalk);
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }
  Widget _filterButton(String title, bool isActive, VoidCallback toggleFilter) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 25),
    child: ElevatedButton(
      onPressed: toggleFilter,
      style: ElevatedButton.styleFrom(
        primary: isActive ? Colors.teal : Colors.grey[300],
        padding: EdgeInsets.symmetric(horizontal: 75, vertical: 25),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.black, width: 2), // Added black border
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.black,
          fontSize: 30,
        ),
      ),
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