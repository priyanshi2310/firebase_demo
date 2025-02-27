import 'package:cloud_firestore/cloud_firestore.dart';

class CloudFirestoreService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  // const CloudFirestoreService(this.db);

  Future<String> add(Map<String, dynamic> data) async {
    // Add a new document with a generated ID
    final document = await db.collection('user').add(data);
    return document.id;
  }

   Stream<QuerySnapshot<Map<String, dynamic>>> getUsers() {
    return db.collection('user').snapshots();
  }
}
