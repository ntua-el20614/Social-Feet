import 'package:flutter/material.dart';
//import 'package:socialfeet/messages/messages.dart';
import 'package:socialfeet/home/home.dart';
import 'package:socialfeet/map/map.dart';
import 'package:socialfeet/profile/profile.dart';
import 'package:firebase_core/firebase_core.dart';
import "package:firebase_database/firebase_database.dart" show DatabaseEvent, DatabaseReference, FirebaseDatabase;

class MessagesPage extends StatefulWidget {
  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class Message {
  String senderId;
  String text;
  DateTime timestamp;
  bool isRead;

  Message({required this.senderId, required this.text, required this.timestamp, this.isRead = false});
}

class ChatSummary {
  String userName;
  String lastMessage;
  String profileImageUrl;
  int unreadCount;
  DateTime lastMessageTime;

  ChatSummary({
    required this.userName,
    required this.lastMessage,
    required this.profileImageUrl,
    required this.unreadCount,
    required this.lastMessageTime,
  });
}

class FirebaseService {
  Future<List<ChatSummary>> fetchChatSummaries(String currentUserId) async {
    DatabaseReference chatsRef = FirebaseDatabase.instance.ref('chats/$currentUserId');
    DatabaseEvent event = await chatsRef.once();

    List<ChatSummary> chatSummaries = [];
    if (event.snapshot.exists) {
      Map<dynamic, dynamic> chatsMap = 
        event.snapshot.value as Map<dynamic, dynamic>;
      chatsMap.forEach((key, value) {
        ChatSummary summary = ChatSummary(
          userName: value['userName'],
          lastMessage: value['lastMessage'],
          profileImageUrl: value['profileImageUrl'],
          unreadCount: value['unreadCount'],
          lastMessageTime: DateTime.parse(value['lastMessageTime']),
        );
        chatSummaries.add(summary);
      });
    } else{
      print("No chats found!");
    }
    chatSummaries.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
    return chatSummaries;
  }
}

class _MessagesPageState extends State<MessagesPage> {
  final TextEditingController searchController = TextEditingController();
  int _selectedIndex = 0; // Assuming 'Home' is the default selected item.

  List<ChatSummary> chatSummaries = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadChatSummaries();
  }

  void loadChatSummaries() async {
    String currentUserId = 'current_user_id'; // Replace with actual ID     TO DO
    List<ChatSummary> summaries = await FirebaseService().fetchChatSummaries(currentUserId);
    setState(() {
      chatSummaries = summaries;
      isLoading = false;
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
  if (isLoading) {
    return Center(child: CircularProgressIndicator());
  } else if (chatSummaries.isEmpty) {
    return Center(child: Text("No messages yet."));
  }

  return Container(
    // Existing decoration code...
    child: Column(
      children: [
        // Existing search bar code...
        Expanded(
          child: ListView.builder(
            itemCount: chatSummaries.length, // Use the length of your chat summaries list
            itemBuilder: (context, index) {
              final chatSummary = chatSummaries[index];
              final timeAgo = _calculateTimeAgo(chatSummary.lastMessageTime);
              
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(chatSummary.profileImageUrl),
                ),
                title: Text(chatSummary.userName),
                subtitle: Text(chatSummary.lastMessage),
                trailing: Text(timeAgo),
              );
            },
          ),
        ),
      ],
    ),
  );
}

String _calculateTimeAgo(DateTime dateTime) {
  final Duration difference = DateTime.now().difference(dateTime);

  if (difference.inMinutes < 1) {
    return 'just now';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} min';
  } else if (difference.inHours < 24) {
    return '${difference.inHours}h';
  } else {
    return '${difference.inDays}d';
  }
}

    Widget _buildBottomBar() {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
            backgroundColor: Colors.black),
        BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
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