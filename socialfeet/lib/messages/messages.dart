// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:socialfeet/messages/chat_screen.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  List<MessagesPageItem> MessagesPage = [];

  @override
  void initState() {
    super.initState();
    loadChats();
  }

  void loadChats() {
    // Assuming you have a user ID to fetch chats for that specific user
    String userId = _auth.currentUser!.uid;
    DatabaseReference chatsRef = _database.ref().child('chats/$userId');

    chatsRef.onValue.listen((event) {
      var chats = event.snapshot.value as Map<dynamic, dynamic>?;
      if (chats != null) {
        var loadedChats = chats.entries
            .map((e) => MessagesPageItem.fromMap(e.key, Map.from(e.value)))
            .toList();

        setState(() {
          MessagesPage = loadedChats;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: ListView.builder(
        itemCount: MessagesPage.length,
        itemBuilder: (context, index) {
          return MessagesPageTile(chat: MessagesPage[index]);
        },
      ),
    );
  }
}

class MessagesPageItem {
  final String chatId;
  final String lastMessage;
  final String timestamp;
  final String
      name; // You would fetch the name from the user's profile using the userId
  final String
      profileImageUrl; // Same as above, this would come from user's profile

  MessagesPageItem({
    required this.chatId,
    required this.lastMessage,
    required this.timestamp,
    required this.name,
    required this.profileImageUrl,
  });

  factory MessagesPageItem.fromMap(String chatId, Map<String, dynamic> data) {
    return MessagesPageItem(
      chatId: chatId,
      lastMessage: data['lastMessage'] ?? '',
      timestamp: data['timestamp'] ?? '',
      name: data['name'] ?? '',
      profileImageUrl: data['profileImageUrl'] ?? '',
    );
  }
}

class MessagesPageTile extends StatelessWidget {
  final MessagesPageItem chat;

  const MessagesPageTile({Key? key, required this.chat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(chat.profileImageUrl),
      ),
      title: Text(chat.name),
      subtitle: Text(chat.lastMessage),
      trailing: Text(chat.timestamp),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(chatId: chat.chatId),
          ),
        );
      },
    );
  }
/*
  Widget _buildNewMessageIndicator(int newMessagesCount) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$newMessagesCount',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
  */
}
