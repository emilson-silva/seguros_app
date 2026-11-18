import 'package:equatable/equatable.dart';
import 'package:seguros_app/features/family/domain/family_member.dart';

enum FamilyStatus { loading, loaded, failure }

class FamilyState extends Equatable {
  const FamilyState({
    this.status = FamilyStatus.loading,
    this.members = const [],
    this.errorMessage,
  });

  final FamilyStatus status;
  final List<FamilyMember> members;
  final String? errorMessage;

  /// `errorMessage` não é preservado: cada cópia limpa o erro anterior.
  FamilyState copyWith({
    FamilyStatus? status,
    List<FamilyMember>? members,
    String? errorMessage,
  }) =>
      FamilyState(
        status: status ?? this.status,
        members: members ?? this.members,
        errorMessage: errorMessage,
      );

  @override
  List<Object?> get props => [status, members, errorMessage];
}
