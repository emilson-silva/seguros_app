import 'package:equatable/equatable.dart';

class FamilyMember extends Equatable {
  const FamilyMember({
    required this.id,
    required this.name,
    required this.relationship,
  });

  final String id;
  final String name;
  final String relationship;

  @override
  List<Object?> get props => [id, name, relationship];
}
