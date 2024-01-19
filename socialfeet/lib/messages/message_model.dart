import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderName;
  final String senderEmail;
  final String senderProfileImageUrl;
  final String receiverName;
  final String receiverEmail;
  final String receiverProfileImageUrl;
  final String message;
  final Timestamp timestamp;

  Message({
    required this.senderName,
    required this.senderEmail,
    required this.senderProfileImageUrl,
    required this.receiverName,
    required this.receiverEmail,
    required this.receiverProfileImageUrl,
    required this.message,
    required this.timestamp,
  });

  // convert to map
  Map<String, dynamic> toMap() {
    return {
      'senderName': senderName,
      'senderEmail': senderEmail,
      'senderProfileImageUrl': senderProfileImageUrl,
      'receiverName': receiverName,
      'receiverEmail': receiverEmail,
      'receiverProfileImageUrl': receiverProfileImageUrl,
      'message': 'message',
      'timestamp': timestamp,
    };
  }

  // Factory constructor to create a Message object from a map
  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderName: map['senderName'],
      senderEmail: map['senderEmail'],
      senderProfileImageUrl: map['senderProfileImageUrl'],
      receiverName: map['receiverName'],
      receiverEmail: map['receiverEmail'],
      receiverProfileImageUrl: map['receiverProfileImageUrl'],
      message: map['message'],
      timestamp: map['timestamp'],
    );
  }
}
