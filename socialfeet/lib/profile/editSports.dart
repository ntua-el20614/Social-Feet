import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class editSportsScreen extends StatefulWidget {
  @override
  _EditSportsScreenState createState() => _EditSportsScreenState();
}

class _EditSportsScreenState extends State<EditSportsScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final DatabaseReference usersRef = FirebaseDatabase.instance.ref('users');
  String? currentUsername;
  Map<String, Map<String, dynamic>> sportsData = {};

  @override
  void initState() {
    super.initState();
    _loadSportsData();
  }

  void _loadSportsData() async {
    User? currentUser = auth.currentUser;
    if (currentUser != null) {
      Query query = usersRef.orderByChild('email').equalTo(currentUser.email);
      DatabaseEvent event = await query.once();
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists && snapshot.value is Map) {
        Map<dynamic, dynamic> usersMap = Map<dynamic, dynamic>.from(snapshot.value as Map);
        Map<dynamic, dynamic> userData = usersMap.values.first as Map<dynamic, dynamic>;
        setState(() {
          currentUsername = userData['username'] as String?;
          sportsData = {
            'bicycle': Map<String, dynamic>.from(userData['bicycle'] as Map),
            'running': Map<String, dynamic>.from(userData['running'] as Map),
            'walking': Map<String, dynamic>.from(userData['walking'] as Map),
          };
        });
      }
    }
  }

  void _saveSportsChanges() async {
    if (currentUsername == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Unable to update sports data. Username is not available.'),
      ));
      return;
    }

    await usersRef.child(currentUsername!).update({
      'bicycle': sportsData['bicycle'],
      'running': sportsData['running'],
      'walking': sportsData['walking'],
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Sports data updated successfully!'),
    ));
  }

  Widget _buildSportBox(String sportName, Map<String, dynamic> sportData) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                sportName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Switch(
                value: sportData['enabled'] ?? false,
                onChanged: (bool newValue) {
                  setState(() {
                    sportData['enabled'] = newValue;
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              labelText: 'Average Speed',
            ),
            controller: TextEditingController(text: sportData['speed']?.toString()),
            onChanged: (val) {
              sportData['speed'] = double.tryParse(val) ?? 0;
            },
          ),
          SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              labelText: 'Total Distance',
            ),
            controller: TextEditingController(text: sportData['distance']?.toString()),
            onChanged: (val) {
              sportData['distance'] = double.tryParse(val) ?? 0;
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Sports'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF36DDA6), Color(0xFF8846DF)],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (sportsData.isNotEmpty) ...[
                _buildSportBox('Biking', sportsData['bicycle']!),
                _buildSportBox('Running', sportsData['running']!),
                _buildSportBox('Walking', sportsData['walking']!),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _saveSportsChanges,
                  child: Text('Save Changes'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
