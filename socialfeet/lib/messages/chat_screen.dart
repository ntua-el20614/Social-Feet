// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart'; // For date formatting

class ChatScreen extends StatefulWidget {
  final String chatId;

  const ChatScreen({super.key, required this.chatId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final TextEditingController _messageController = TextEditingController();

  late DatabaseReference _messagesRef;
  final List<Message> _messages = [];

  @override
  void initState() {
    super.initState();
    _messagesRef = _database.ref().child('chats/${widget.chatId}/messages');
    _messagesRef.onChildAdded.listen(_onMessageAdded);
  }

  void _onMessageAdded(DatabaseEvent event) {
    setState(() {
      _messages.add(Message.fromSnapshot(event.snapshot));
    });
  }

  void _sendMessage() {
    String text = _messageController.text.trim();
    if (text.isNotEmpty) {
      var message = {
        'text': text,
        'senderId': _auth.currentUser!.uid,
        'timestamp': ServerValue.timestamp,
      };
      _messagesRef.push().set(message);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
// Messages are displayed in reverse order, so that the latest message is at the bottom.
                final message = _messages[_messages.length - 1 - index];
                bool isMe = message.senderId == _auth.currentUser!.uid;
                return ListTile(
                  title: Align(
                    alignment:
                        isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isMe ? Colors.blue : Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(message.text,
                          style: TextStyle(
                              color: isMe ? Colors.white : Colors.black)),
                    ),
                  ),
                  subtitle: Align(
                    alignment:
                        isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Text(DateFormat('hh:mm a').format(
                        DateTime.fromMillisecondsSinceEpoch(
                            message.timestamp))),
                  ),
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration.collapsed(
                  hintText: "Type a message..."),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}

class Message {
  final String text;
  final String senderId;
  final int timestamp;

  Message(
      {required this.text, required this.senderId, required this.timestamp});

  factory Message.fromSnapshot(DataSnapshot snapshot) {
    var value = snapshot.value as Map<dynamic, dynamic>?;
    return Message(
      text: value?['text'] ?? '',
      senderId: value?['senderId'] ?? '',
      timestamp: value?['timestamp'] ?? 0,
    );
  }
}
