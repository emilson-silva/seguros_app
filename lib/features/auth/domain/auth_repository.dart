import 'package:seguros_app/features/auth/domain/user_entity.dart';

/// Contrato de autenticação. Implementações lançam [AppFailure] em caso de erro.
abstract class AuthRepository {
  Future<UserEntity?> currentUser();

  Future<UserEntity> signIn({
    required String cpf,
    required String password,
    required bool remember,
  });

  Future<UserEntity> register({
    required String name,
    required String cpf,
    required String password,
  });

  Future<void> signOut();
}
