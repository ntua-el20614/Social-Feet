import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  final DatabaseReference databaseReference = FirebaseDatabase.instance.reference();

  Future<dynamic> readData(String path) async {
    DatabaseEvent databaseEvent = await databaseReference.child(path).once();
    if (databaseEvent.snapshot.value != null) {
      return databaseEvent.snapshot.value;
    } else {
      print('No data available at $path.');
      return null;
    }
  }
}
