import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:socialfeet/messages/message_bubble.dart';
import 'package:socialfeet/messages/mytextfield.dart';

class Message_Chat extends StatefulWidget {
  final String receiverEmail;
  String receiverName;

  Message_Chat({
    super.key,
    this.receiverEmail = "receivernull@mail.com",
    this.receiverName = "receivernull",
  });

  @override
  State<Message_Chat> createState() => _Message_ChatState();
}   

class _Message_ChatState extends State<Message_Chat> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FirebaseAuth _authService = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        Future.delayed(
          const Duration(milliseconds: 500),
          () => scrollDown(),
        );
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    myFocusNode.dispose();
    super.dispose();
  }

  void scrollDown() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(seconds: 1),
          curve: Curves.fastOutSlowIn);
    }
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      String conversationId = getConversationId(
          _authService.currentUser!.email!, widget.receiverEmail);

      await _firestore.collection('messages').add({
        'senderEmail': _authService.currentUser!.email,
        'receiverEmail': widget.receiverEmail,
        'message': _messageController.text,
        'timestamp': FieldValue.serverTimestamp(),
        'conversationId': conversationId,
      });
      _messageController.clear();
      scrollDown();
    }
  }

  String getConversationId(String email1, String email2) {
    List<String> emails = [email1, email2];
    emails.sort();
    return emails.join('_');
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverEmail),
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
      child: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildUserInput(),
        ],
      ),
    ),
  );
  }

  Widget _buildMessageList() {
    String currentUserEmail = _authService.currentUser!.email!;
    String conversationId = getConversationId(currentUserEmail, widget.receiverEmail);

    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages')
          .where('conversationId', isEqualTo: conversationId)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error); // Log the error
          return Text("Error loading messages: ${snapshot.error}");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        return ListView(
          reverse: true,
          controller: _scrollController,
          children: snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(QueryDocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentUser = data['senderEmail'] == _authService.currentUser!.email!;
    var alignment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ChatBubble(
            message: data['message'],
            isCurrentUser: isCurrentUser,
          ),
        ],
      ),
    );
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Row(
        children: [
          Expanded(
            child: MyTextField(
              controller: _messageController,
              hintText: "Type a message",
              obscureText: false,
              focusNode: myFocusNode,
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.only(right: 25),
            child: IconButton(
              onPressed: sendMessage,
              icon: const Icon(
                Icons.arrow_upward,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
