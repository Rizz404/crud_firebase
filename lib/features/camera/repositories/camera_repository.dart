import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:saturday_firebase_project/features/camera/model/camera_model.dart';

class CameraRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'camera';

  Future<void> createCamera(CameraModel camera) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(camera.id)
          .set(camera.toMap());
    } catch (e) {
      throw Exception('Failed to create camera: $e');
    }
  }

  Stream<List<CameraModel>> getAllCamera() {
    return _firestore.collection(_collection).snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => CameraModel.fromMap(doc.data())).toList());
  }

  Future<CameraModel?> getCameraById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (doc.exists) {
        return CameraModel.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get camera: $e');
    }
  }

  Future<void> updateCamera(String id, CameraModel camera) async {
    try {
      await _firestore.collection(_collection).doc(id).update(camera.toMap());
    } catch (e) {
      throw Exception('Failed to update camera: $e');
    }
  }

  Future<void> deleteCamera(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete camera: $e');
    }
  }

  Stream<List<CameraModel>> searchCamera(String query) {
    return _firestore
        .collection(_collection)
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: '$query\uf8ff')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CameraModel.fromMap(doc.data()))
            .toList());
  }
}
