import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

// Function to upload file to Firebase Storage
  Future<String> uploadFile(File file, String destination) async {
    try {
      String fileName = path.basename(file.path);
      SettableMetadata metadata =
          SettableMetadata(contentType: _getContentType(fileName));
      TaskSnapshot uploadTaskSnapshot = await _storage
          .ref(destination)
          .child(fileName)
          .putFile(file, metadata);
      String downloadUrl = await uploadTaskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception("Error uploading file: $e");
    }
  }

// Helper function to determine the content type based on the file extension
  String _getContentType(String fileName) {
    String extension = path.extension(fileName).toLowerCase();
    switch (extension) {
      case '.jpg':
      case '.jpeg':
      case '.png':
        return 'image/jpeg';
      case '.mp3':
      case '.wav':
        return 'audio/mpeg';
      default:
        return 'application/octet-stream';
    }
  }

// Add more functions as needed for your specific use cases
}
