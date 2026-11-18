import 'package:seguros_app/features/family/data/family_firestore_datasource.dart';
import 'package:seguros_app/features/family/domain/family_member.dart';
import 'package:seguros_app/features/family/domain/family_repository.dart';

class FamilyRepositoryImpl implements FamilyRepository {
  FamilyRepositoryImpl(this._remote);
  final FamilyFirestoreDataSource _remote;

  @override
  Stream<List<FamilyMember>> watchMembers(String uid) => _remote.watch(uid);

  @override
  Future<void> addMember(
    String uid, {
    required String name,
    required String relationship,
  }) =>
      _remote.add(uid, name, relationship);

  @override
  Future<void> removeMember(String uid, String memberId) =>
      _remote.remove(uid, memberId);
}
