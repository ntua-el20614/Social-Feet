import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialfeet/messages/message_bubble.dart';
import 'package:socialfeet/messages/message_model.dart';
import 'package:socialfeet/messages/messages_service.dart';
import 'package:socialfeet/messages/mytextfield.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessagesPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverName;
  final String receiverProfileImageUrl;

  const MessagesPage({
    super.key,
    required this.receiverEmail,
    required this.receiverName,
    required this.receiverProfileImageUrl,
  });

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _messageController.addListener(() => setState(() {}));
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      // Create message object
      final currentUser = _auth.currentUser!;
      final newMessage = Message(
        senderName: currentUser.displayName ?? 'Anonymous',
        senderEmail: currentUser.email!,
        senderProfileImageUrl:
            currentUser.photoURL ?? 'https://via.placeholder.com/150',
        receiverName: widget.receiverName,
        receiverEmail: widget.receiverEmail,
        receiverProfileImageUrl: widget.receiverProfileImageUrl,
        message: _messageController.text,
        timestamp: Timestamp.now(),
      );

      // Send message
      await _chatService.sendMessage(newMessage);

      // Clear controller
      _messageController.clear();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUserEmail = _auth.currentUser!.email!;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverEmail),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: _chatService.getMessages(
                  currentUserEmail, widget.receiverEmail),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text("No messages yet"));
                }
                final messages = snapshot.data!;
                return ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return ChatBubble(
                      message: message.message,
                      isCurrentUser: message.senderEmail == currentUserEmail,
                    );
                  },
                );
              },
            ),
          ),
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: MyTextField(
              controller: _messageController,
              hintText: "Type a message",
              obscureText: false,
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: sendMessage,
          ),
        ],
      ),
    );
  }
}
