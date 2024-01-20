import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:socialfeet/messages/message_model.dart';

class ChatService {
   // Initialize Firebase Firestore and Firebase Authentication instances.
  // These instances are used to interact with Firebase services.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Method to get a stream of user data from the "Users" collection in Firestore.
  // This stream provides real-time updates whenever user data changes.
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user; // Convert each document to a map and return as a list.
      }).toList();
    });
  }

   // Method to send a text message. It takes the receiver's email and the message as parameters.
  Future<void> sendMessage(String receiverEmail, message) async {
    // Fetch current user's email from Firebase Authentication.
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now(); // Get the current timestamp.

    // Create a new message object using the Message model.
    Message newMessage = Message(
        senderEmail: currentUserEmail,
        receiverEmail: receiverEmail,
        message: message,
        timestamp: timestamp);

    // Construct a unique chat room ID using both user IDs.
    // This ID is used to store messages in a specific chat room in Firestore.
    List<String> chatRoomIDs = [currentUserEmail, receiverEmail];
    chatRoomIDs.sort();
    String chatRoomID = chatRoomIDs.join('_');

    // Save the message to Firestore under the constructed chat room ID.
    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());
  }

  // Method to retrieve a stream of messages between two users.
  // This stream provides real-time updates to messages in a chat room.
  Stream<QuerySnapshot> getMessages(String userEmail, otherUserEmail) {
    // Construct the chat room ID using both user IDs.
    List<String> chatRoomEmails = [userEmail, otherUserEmail];
    chatRoomEmails.sort();
    String chatRoomID = chatRoomEmails.join('_');

    // Retrieve and return a stream of messages ordered by timestamp.
    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
