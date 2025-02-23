import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:saturday_firebase_project/features/mahasiswa/model/mahasiswa_model.dart';

class MahasiswaRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'mahasiswa';

  Future<void> createMahasiswa(MahasiswaModel mahasiswa) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(mahasiswa.id)
          .set(mahasiswa.toMap());
    } catch (e) {
      throw Exception('Failed to create mahasiswa: $e');
    }
  }

  Stream<List<MahasiswaModel>> getAllMahasiswa() {
    return _firestore.collection(_collection).snapshots().map((snapshot) =>
        snapshot.docs
            .map((doc) => MahasiswaModel.fromMap(doc.data()))
            .toList());
  }

  Future<MahasiswaModel?> getMahasiswaById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (doc.exists) {
        return MahasiswaModel.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get mahasiswa: $e');
    }
  }

  Future<void> updateMahasiswa(String id, MahasiswaModel mahasiswa) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(id)
          .update(mahasiswa.toMap());
    } catch (e) {
      throw Exception('Failed to update mahasiswa: $e');
    }
  }

  Future<void> deleteMahasiswa(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete mahasiswa: $e');
    }
  }

  Stream<List<MahasiswaModel>> searchMahasiswa(String query) {
    return _firestore
        .collection(_collection)
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: '$query\uf8ff')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MahasiswaModel.fromMap(doc.data()))
            .toList());
  }
}
