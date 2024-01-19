import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:socialfeet/messages/message_model.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Send message
  Future<void> sendMessage(Message message) async {
    // Construct chat room ID for 2 users
    String chatRoomID =
        _generateChatRoomID(message.senderEmail, message.receiverEmail);

    // Add to Firestore
    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(message.toMap());
  }

  // Generate Chat Room ID
  String _generateChatRoomID(String senderEmail, String receiverEmail) {
    List<String> ids = [senderEmail, receiverEmail];
    ids.sort();
    return ids.join('_');
  }

  // Get messages stream
  Stream<List<Message>> getMessages(
      String currentUserEmail, String otherUserEmail) {
    String chatRoomID = _generateChatRoomID(currentUserEmail, otherUserEmail);

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Message.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}
