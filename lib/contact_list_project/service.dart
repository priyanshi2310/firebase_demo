import 'package:cloud_firestore/cloud_firestore.dart';

class CloudFirestoreService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> add(Map<String, dynamic> data) async {
    final document = await db.collection('user').add(data);
    return document.id;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUsers() {
    return db.collection('user').snapshots();
  }

  Future<bool> updateUser(Map<String, dynamic> userData, String id) async {
    bool isError = false;
    await db
        .collection('user')
        .doc(id)
        .update(userData)
        .then(
          (value) {},
        )
        .catchError(
      (error, stackTrace) {
        isError = true;
      },
    );
    return isError;
  }

  Future<bool> deleteUser(String id) async {
    bool isError = false;
    await db
        .collection('user')
        .doc(id)
        .delete()
        .then(
          (value) {},
        )
        .catchError(
      (error, stackTrace) {
        isError = true;
      },
    );
    return isError;
  }
}
