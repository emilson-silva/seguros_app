import 'package:equatable/equatable.dart';

sealed class FamilyEvent extends Equatable {
  const FamilyEvent();

  @override
  List<Object?> get props => [];
}

class FamilyWatchStarted extends FamilyEvent {
  const FamilyWatchStarted(this.uid);
  final String uid;

  @override
  List<Object?> get props => [uid];
}

class FamilyMemberAdded extends FamilyEvent {
  const FamilyMemberAdded({required this.name, required this.relationship});
  final String name;
  final String relationship;

  @override
  List<Object?> get props => [name, relationship];
}

class FamilyMemberRemoved extends FamilyEvent {
  const FamilyMemberRemoved(this.memberId);
  final String memberId;

  @override
  List<Object?> get props => [memberId];
}
