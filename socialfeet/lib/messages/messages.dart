import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socialfeet/messages/chat_screen.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('chats')
            .where('participants', arrayContains: _auth.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var chatData =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;
              String chatId = snapshot.data!.docs[index].id;
              return ChatListTile(
                chatId: chatId,
                lastMessage: chatData['lastMessage'] ?? 'No messages yet',
                participants: chatData['participants'],
              );
            },
          );
        },
      ),
    );
  }
}

class ChatListTile extends StatelessWidget {
  final String chatId;
  final String lastMessage;
  final List<String> participants;

  const ChatListTile({
    Key? key,
    required this.chatId,
    required this.lastMessage,
    required this.participants,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
// Assuming the first participant is the other user (not the current user)
    String otherUserId = participants.firstWhere(
        (id) => id != FirebaseAuth.instance.currentUser!.uid,
        orElse: () => '');
    return ListTile(
      title: Text(
          otherUserId), // You can replace this with fetching the user's name using otherUserId
      subtitle: Text(lastMessage),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(chatId: chatId),
          ),
        );
      },
    );
  }
}
