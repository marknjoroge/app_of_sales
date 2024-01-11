import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestoreDB = FirebaseFirestore.instance;

  // Create a new document in the specified collection
  void create(String collection, Map<String, dynamic> data) async {
    // CollectionReference collectionRef = FirebaseFirestore.instance.collection(collection);
    // collectionRef.add(data);
    // return collectionRef.id;
    final docRef = _firestoreDB.collection(collection).doc();

    final docId = await docRef.set(data);

    // return docId;
  }

  // Read all documents from the specified collection
  Future<List> readAll(String collection, String date) async {
    return await _firestoreDB
        .collection(collection)
        .get()
        .then((value) => value.docs);
  }

  // Read a specific document from the specified collection by ID
  Future<Map<String, dynamic>?> readById(String collection, String id) async {
    final DocumentSnapshot doc =
        await _firestoreDB.collection(collection).doc(id).get();
    if (doc.exists) {
      return {...doc.data() as Map<String, dynamic>, 'id': doc.id};
    } else {
      return null;
    }
  }

  // Update a document in the specified collection by ID
  Future<void> update(
      String collection, String id, Map<String, dynamic> data) async {
    await _firestoreDB.collection(collection).doc(id).update(data);
  }

  // Delete a document from the specified collection by ID
  Future<void> delete(String collection, String id) async {
    await _firestoreDB.collection(collection).doc(id).delete();
  }
}
