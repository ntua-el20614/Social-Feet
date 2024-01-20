import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:socialfeet/messages/message_page.dart'; // Adjust the import as necessary

import 'package:socialfeet/map/map.dart';
import 'package:socialfeet/home/home.dart';
import 'package:socialfeet/profile/profile.dart';
class MessagesPage extends StatefulWidget {
  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final FirebaseAuth _authService = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? currentUserEmail;
  Map<String, DocumentSnapshot> lastMessages = {};
  int _selectedIndex = 0; 

  @override
  void initState() {
    super.initState();
    getCurrentUserEmail();
    getLastMessages();
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

  void getCurrentUserEmail() {
    User? currentUser = _authService.currentUser;
    if (currentUser != null) {
      currentUserEmail = currentUser.email;
    }
  }

  void getLastMessages() async {
    if (currentUserEmail == null) {
      print("No user logged in");
      return;
    }

    QuerySnapshot querySnapshot = await _firestore.collection('messages')
        .where('senderEmail', isEqualTo: currentUserEmail)
        .get();

    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      String? conversationId = data['conversationId'];
      if (conversationId == null) continue;

      Timestamp? timestamp = data['timestamp'] as Timestamp?;
      if (timestamp == null) continue;

      if (!lastMessages.containsKey(conversationId) ||
          (lastMessages[conversationId]!.get('timestamp') as Timestamp).compareTo(timestamp) < 0) {
        lastMessages[conversationId] = doc;
      }
    }

    setState(() {}); // Update the UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Messages"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.grey,
      ),
      body: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 3),
          gradient: LinearGradient(
            begin: Alignment(1, 0),
            end: Alignment(0, 1),
            colors: [
              Colors.teal.withOpacity(0.75),
              Colors.deepPurple.withOpacity(0.75),
            ],
          ),
        ),
        child: lastMessages.isNotEmpty
            ? ListView.builder(
                itemCount: lastMessages.length,
                itemBuilder: (context, index) {
                  String conversationId = lastMessages.keys.elementAt(index);
                  DocumentSnapshot messageDoc = lastMessages[conversationId]!;
                  Map<String, dynamic> data = messageDoc.data() as Map<String, dynamic>;
                  String otherUserEmail = data['senderEmail'] == currentUserEmail
                      ? data['receiverEmail']
                      : data['senderEmail'];

                  return ListTile(
                    title: Text(otherUserEmail ?? "Unknown User"),
                    subtitle: Text(data['message'] ?? "No message"),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Message_Chat(receiverEmail: otherUserEmail),
                      ));
                    },
                  );
                },
              )
            : Center(child: Text('No messages yet')),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildBottomBar() {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.message),
          label: 'Messages',
          backgroundColor: Colors.black
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: ' ',
          backgroundColor: Colors.black
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: ' ',
          backgroundColor: Colors.black
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: ' ',
          backgroundColor: Colors.black
        ),
      ],
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white.withOpacity(0.6),
      selectedFontSize: 12,
      unselectedFontSize: 12,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.black,
      currentIndex: 0, // Adjust this as needed
      
      onTap: _onItemTapped,
    );
  }
}
