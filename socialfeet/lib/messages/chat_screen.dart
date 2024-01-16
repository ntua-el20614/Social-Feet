import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart'; // For picking images
// Import any other packages you need for audio recording

class ChatScreen extends StatefulWidget {
  final String chatId;

  const ChatScreen({Key? key, required this.chatId}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final TextEditingController _messageController = TextEditingController();

  // Function to send text messages
  void _sendTextMessage() async {
    String text = _messageController.text.trim();
    if (text.isNotEmpty) {
      var message = {
        'text': text,
        'senderId': _auth.currentUser!.uid,
        'timestamp': FieldValue.serverTimestamp(),
        'type': 'text',
      };
      await _firestore
          .collection('chats/${widget.chatId}/messages')
          .add(message);
      _messageController.clear();
    }
  }

  // Function to send image messages
  void _sendImageMessage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      var file = await pickedFile.readAsBytes();
      String fileName =
          'photos/${widget.chatId}/${DateTime.now().millisecondsSinceEpoch.toString()}.jpg';

      try {
        // Upload to Firebase Storage
        var task = await _storage.ref(fileName).putData(file);
        String fileUrl = await task.ref.getDownloadURL();

        // Save message in Firestore
        var message = {
          'senderId': _auth.currentUser!.uid,
          'timestamp': FieldValue.serverTimestamp(),
          'type': 'image',
          'url': fileUrl,
        };
        await _firestore
            .collection('chats/${widget.chatId}/messages')
            .add(message);
      } catch (e) {
        // Handle errors
      }
    }
  }

  // Add a function for sending voice messages similar to _sendImageMessage

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('chats/${widget.chatId}/messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListView(
                  reverse: true,
                  children: snapshot.data!.docs.map((doc) {
                    var message = doc.data() as Map<String, dynamic>;
                    return MessageTile(
                      text: message['text'],
                      senderId: message['senderId'],
                      type: message['type'],
                      url: message['url'],
                    );
                  }).toList(),
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
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed:
                _sendImageMessage, // Call the function to send image messages
          ),
          // Add an icon button for sending voice messages
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration:
                  InputDecoration.collapsed(hintText: "Type a message..."),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed:
                _sendTextMessage, // Call the function to send text messages
          ),
        ],
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String text;
  final String senderId;
  final String type;
  final String? url;

  const MessageTile({
    Key? key,
    required this.text,
    required this.senderId,
    required this.type,
    this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (type == 'text') {
      return ListTile(
        title: Text(text),
        subtitle: Text(senderId),
      );
    } else if (type == 'image') {
      return ListTile(
        title: Image.network(url ?? ''),
        subtitle: Text(senderId),
      );
    }
    // Add a case for 'voice' type
    return SizedBox.shrink();
  }
}
