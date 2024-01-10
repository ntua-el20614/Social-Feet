import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.reference();

  // Function to read data from Firebase Realtime Database
  Future<DataSnapshot> readData(String path) async {
    DatabaseEvent event = await _dbRef.child(path).once();
    return event.snapshot;
  }

  // Function to write data to Firebase Realtime Database
  Future<void> writeData(String path, Map data) async {
    await _dbRef.child(path).set(data);
  }

  // Function to update data in Firebase Realtime Database
  Future<void> updateData(String path, Map<String, Object?> data) async {
    await _dbRef.child(path).update(data);
  }


  // Add more functions as needed for your specific use cases
}

