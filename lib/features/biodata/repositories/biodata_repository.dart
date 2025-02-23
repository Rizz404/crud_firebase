import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:saturday_firebase_project/features/biodata/model/biodata_model.dart';

class BiodataRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'biodata';

  Future<void> createBiodata(BiodataModel biodata) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(biodata.id)
          .set(biodata.toMap());
    } catch (e) {
      throw Exception('Failed to create biodata: $e');
    }
  }

  Stream<List<BiodataModel>> getAllBiodata() {
    return _firestore.collection(_collection).snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => BiodataModel.fromMap(doc.data())).toList());
  }

  Future<BiodataModel?> getBiodataById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (doc.exists) {
        return BiodataModel.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get biodata: $e');
    }
  }

  Future<void> updateBiodata(String id, BiodataModel biodata) async {
    try {
      await _firestore.collection(_collection).doc(id).update(biodata.toMap());
    } catch (e) {
      throw Exception('Failed to update biodata: $e');
    }
  }

  Future<void> deleteBiodata(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete biodata: $e');
    }
  }

  Stream<List<BiodataModel>> searchBiodata(String query) {
    return _firestore
        .collection(_collection)
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: '$query\uf8ff')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BiodataModel.fromMap(doc.data()))
            .toList());
  }
}
