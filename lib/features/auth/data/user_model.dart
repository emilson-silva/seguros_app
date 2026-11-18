import 'package:seguros_app/features/auth/domain/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({required super.uid, required super.name, required super.cpf});

  factory UserModel.fromMap(String uid, Map<String, dynamic> map) => UserModel(
        uid: uid,
        name: (map['name'] as String?) ?? 'Usuário',
        cpf: (map['cpf'] as String?) ?? '',
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'cpf': cpf,
        'createdAt': DateTime.now().toUtc().toIso8601String(),
      };
}
