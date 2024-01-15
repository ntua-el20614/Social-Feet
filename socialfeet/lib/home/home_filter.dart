import 'package:flutter/material.dart';


import 'package:socialfeet/messages/messages.dart';
import 'package:socialfeet/home/home.dart';
import 'package:socialfeet/map/map.dart';
import 'package:socialfeet/profile/profile.dart';

class HomeFilter extends StatefulWidget {
  bool filterBike;
  bool filterRun;
  bool filterWalk;
  String filterLocation;

  HomeFilter({
    Key? key,
    required this.filterBike,
    required this.filterRun,
    required this.filterWalk,
    required this.filterLocation,
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
  final TextEditingController _cityController = TextEditingController(); // Controller for city input

  @override
  void initState() {
    super.initState();
    _cityController.text = widget.filterLocation; // Initialize controller with existing filterLocation
  }
  
  @override
  void dispose() {
    _cityController.dispose(); // Dispose the controller when the widget is disposed
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment(0, -1),
        end: Alignment(0, 1),
        colors: [Color(0xFF36DDA6), Color(0xFF8846DF)],  
      ),
    ),
    child: Scaffold(
      appBar: AppBar(
        title: Text('Choose your filters!'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.transparent, // Make Scaffold background transparent
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ElevatedButton(
                    child: Text('Apply Filters'),
                    onPressed: () {
                      Navigator.pop(context, {
                        'filterBike': widget.filterBike,
                        'filterRun': widget.filterRun,
                        'filterWalk': widget.filterWalk,
                        'filterLocation': _cityController.text,
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _cityController,
                    decoration: InputDecoration(
                      labelText: 'Enter City',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
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
          ],
        ),
      ),
    
    bottomNavigationBar: BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.message),
          label: '',
          backgroundColor: Colors.black,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
          backgroundColor: Colors.black,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: '',
          backgroundColor: Colors.black,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: '',
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
    ),
  ));
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
          side: BorderSide(color: Colors.black, width: 2),
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

  
  

}