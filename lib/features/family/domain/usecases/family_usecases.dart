import 'package:seguros_app/features/family/domain/family_member.dart';
import 'package:seguros_app/features/family/domain/family_repository.dart';

class WatchFamily {
  const WatchFamily(this._repo);
  final FamilyRepository _repo;
  Stream<List<FamilyMember>> call(String uid) => _repo.watchMembers(uid);
}

class AddFamilyMember {
  const AddFamilyMember(this._repo);
  final FamilyRepository _repo;
  Future<void> call(
    String uid, {
    required String name,
    required String relationship,
  }) =>
      _repo.addMember(uid, name: name, relationship: relationship);
}

class RemoveFamilyMember {
  const RemoveFamilyMember(this._repo);
  final FamilyRepository _repo;
  Future<void> call(String uid, String memberId) =>
      _repo.removeMember(uid, memberId);
}
