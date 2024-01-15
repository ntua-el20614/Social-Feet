import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to send a message. You might need to adjust parameters according to your needs.
  Future<DocumentReference> sendMessage(String chatId, String userId,
      String type, String content, String? url) async {
    var message = {
      'senderId': userId,
      'type': type, // 'text', 'voice', or 'image'
      'content': content,
      'timestamp': FieldValue
          .serverTimestamp(), // Automatically get the server timestamp
      'url': url, // For voice and image messages, this is the download URL
    };

    return await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(message);
  }

  // Function to read messages from a chat.
  Stream<QuerySnapshot> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Add more functions as needed for your specific use cases.
}
