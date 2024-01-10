// This is the content of firebase_service.dart
import 'package:socialfeet/firebase_service.dart';

class FirebaseService {
  final DatabaseReference databaseReference = FirebaseDatabase.instance.reference();

  void readData(String path) {
    databaseReference.child(path).once().then((DataSnapshot snapshot) {
      print('Data : ${snapshot.value}');
    });
  }
}
