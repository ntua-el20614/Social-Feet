import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FirebaseService {
  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<Map<String, dynamic>>> getChats() async {
    List<Map<String, dynamic>> chatList = [];

    // Assuming each user has a node with their uid and chats as children
    String userId = _auth.currentUser!.uid;
    DatabaseReference userChatsRef = databaseReference.child('chats/$userId');

    DatabaseEvent event = await userChatsRef.once();

    if (event.snapshot.exists) {
      Map<dynamic, dynamic> chats =
          event.snapshot.value as Map<dynamic, dynamic>;
      chats.forEach((key, value) {
        Map<String, dynamic> chatData = Map<String, dynamic>.from(value);
        chatData['chatId'] =
            key; // Assuming you want to pass the chatId as well
        chatList.add(chatData);
      });
    } else {
      if (kDebugMode) {
        print('No chat data available for user with id: $userId');
      }
    }

    return chatList;
  }

  // Keep the existing readData method as is for other uses
  Future<dynamic> readData(String path) async {
    DatabaseEvent databaseEvent = await databaseReference.child(path).once();
    if (databaseEvent.snapshot.value != null) {
      return databaseEvent.snapshot.value;
    } else {
      if (kDebugMode) {
        print('No data available at $path.');
      }
      return null;
    }
  }
}
