import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  const UserEntity({required this.uid, required this.name, required this.cpf});

  final String uid;
  final String name;
  final String cpf;

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    if (parts.isEmpty) return '?';
    final first = parts.first[0];
    final last = parts.length > 1 ? parts.last[0] : '';
    return (first + last).toUpperCase();
  }

  @override
  List<Object?> get props => [uid, name, cpf];
}
