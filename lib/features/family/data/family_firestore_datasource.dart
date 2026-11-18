import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seguros_app/features/family/domain/family_member.dart';

/// Coleção: users/{uid}/family/{memberId} -> { name, relationship, createdAt }
class FamilyFirestoreDataSource {
  FamilyFirestoreDataSource(this._db);
  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> _col(String uid) =>
      _db.collection('users').doc(uid).collection('family');

  Stream<List<FamilyMember>> watch(String uid) {
    return _col(uid).orderBy('createdAt').snapshots().map(
          (snap) => snap.docs
              .map(
                (d) => FamilyMember(
                  id: d.id,
                  name: (d.data()['name'] as String?) ?? '',
                  relationship: (d.data()['relationship'] as String?) ?? '',
                ),
              )
              .toList(),
        );
  }

  // Timestamp.now() (e não serverTimestamp) para o stream local já vir ordenado
  // e sem valores nulos enquanto a escrita está pendente.
  Future<void> add(String uid, String name, String relationship) =>
      _col(uid).add({
        'name': name,
        'relationship': relationship,
        'createdAt': Timestamp.now(),
      });

  Future<void> remove(String uid, String memberId) =>
      _col(uid).doc(memberId).delete();
}
