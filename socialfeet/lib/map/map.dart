import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:socialfeet/messages/messages.dart';
import 'package:socialfeet/home/home.dart';
//import 'package:socialfeet/map/map.dart';
import 'package:socialfeet/profile/profile.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  int _selectedIndex = 2;
  GoogleMapController? mapController; // Controller for Google map
  LatLng _center = const LatLng(37.979064, 23.783042); // Default location
  final Set<Marker> _markers = {}; // Markers for pinned locations
  bool _isLoading = true; // Loading state
  String _searchQuery = '';

  TextEditingController _searchController = TextEditingController();

  Set<Circle> _userLocationCircle = {}; // Initialize the set for the circle

  // Filter variables
  bool filterBike = true;
  bool filterRun = true;
  bool filterWalk = true;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _loadMarkers();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _loadMarkers() async {
    DatabaseReference locationsRef =
        FirebaseDatabase.instance.ref('location'); // Adjusted path
    DatabaseEvent event = await locationsRef.once();
    print("locationsRef: $locationsRef");
    print("event: $event");
    if (event.snapshot.exists) {
      Map<dynamic, dynamic> locations =
          event.snapshot.value as Map<dynamic, dynamic>;
      print("locations: $locations");
      setState(() {
        _markers.clear();
        locations.forEach((key, value) {
          final markerInfo = Map<String, dynamic>.from(value);

          // Check if the location matches the selected filters
          bool matchesFilter = (filterBike && markerInfo['isBike']) ||
              (filterRun && markerInfo['isRun']) ||
              (filterWalk && markerInfo['isWalk']);

          if (matchesFilter) {
            final LatLng position =
                LatLng(markerInfo['lat'], markerInfo['long']);
            final String name = markerInfo['name'];
            final String info = markerInfo['Info'];
            print("Position: $position");

            _markers.add(
              Marker(
                markerId: MarkerId(key),
                position: position,
                infoWindow: InfoWindow(title: name, snippet: info),
                icon: BitmapDescriptor.defaultMarker,
              ),
            );
          }
        });
      });
    } else {
      print("No locations found in the database.");
    }
  }

  _getUserLocation() async {
    var position = await _determinePosition();
    LatLng currentUserLocation = LatLng(position.latitude, position.longitude);

    setState(() {
      _center = currentUserLocation; // Update the map center to user location
      _isLoading = false;
      // Directly create and set the circle
      _userLocationCircle = {
        Circle(
          circleId: CircleId("user_location"),
          center: currentUserLocation,
          radius: 50, // Adjust the radius as needed
          fillColor: Colors.blue.withOpacity(0.5), // Semi-transparent blue fill
          strokeColor: Colors.blue, // Blue border
          strokeWidth: 2, // Border width
        ),
      };
    });
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search here...',
        suffixIcon: Icon(Icons.search),
      ),
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
        if (_searchQuery.isNotEmpty) {
          _searchPlaces(_searchQuery);
        }
      },
    );
  }

  Future<void> _searchPlaces(String query) async {
    var response = await http.get(
      Uri.parse(
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=AIzaSyDOrWSyOjNy_XKyMq61dQodqKmLPluyWtI'),
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var predictions = data['predictions'];
      if (predictions.isNotEmpty) {
        var placeId = predictions[0]['place_id'];
        _getPlaceDetails(placeId);
      }
    } else {
      // Handle error
    }
  }

  Future<void> _getPlaceDetails(String placeId) async {
    var response = await http.get(
      Uri.parse(
          'https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeId&key=AIzaSyDOrWSyOjNy_XKyMq61dQodqKmLPluyWtI'),
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var location = data['result']['geometry']['location'];
      _moveMapToLocation(location['lat'], location['lng']);
    } else {}
  }

  void _moveMapToLocation(double lat, double lng) {
    mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(lat, lng),
          zoom: 14.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              _searchPlaces(value);
            }
          },
          decoration: InputDecoration(
            hintText: 'Search here...',
            suffixIcon: Icon(Icons.search),
          ),
        ),
      ),
      body: Column(
        children: [
          _buildFilterBar(), // Filter bar
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _center,
                      zoom: 17.0,
                    ),
                    markers: _markers,
                    circles: _userLocationCircle, // Add the circle set here
                  ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildFilterBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FilterChip(
          label: Text('Bike'),
          selected: filterBike,
          onSelected: (bool value) {
            setState(() {
              filterBike = value;
              _loadMarkers();
            });
          },
        ),
        FilterChip(
          label: Text('Run'),
          selected: filterRun,
          onSelected: (bool value) {
            setState(() {
              filterRun = value;
              _loadMarkers();
            });
          },
        ),
        FilterChip(
          label: Text('Walk'),
          selected: filterWalk,
          onSelected: (bool value) {
            setState(() {
              filterWalk = value;
              _loadMarkers();
            });
          },
        ),
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
            icon: Icon(Icons.home), label: '', backgroundColor: Colors.black),
        BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Maps',
            backgroundColor: Colors.black),
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

  void _handleTap(LatLng point) {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(point.toString()),
          position: point,
          infoWindow: InfoWindow(
            title: 'Custom Location',
            snippet: 'New Marker',
          ),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
