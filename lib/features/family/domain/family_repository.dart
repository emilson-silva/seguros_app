import 'package:seguros_app/features/family/domain/family_member.dart';

abstract class FamilyRepository {
  Stream<List<FamilyMember>> watchMembers(String uid);

  Future<void> addMember(
    String uid, {
    required String name,
    required String relationship,
  });

  Future<void> removeMember(String uid, String memberId);
}
