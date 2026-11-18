import 'package:seguros_app/features/auth/domain/auth_repository.dart';
import 'package:seguros_app/features/auth/domain/user_entity.dart';

class GetCurrentUser {
  const GetCurrentUser(this._repo);
  final AuthRepository _repo;
  Future<UserEntity?> call() => _repo.currentUser();
}

class SignIn {
  const SignIn(this._repo);
  final AuthRepository _repo;
  Future<UserEntity> call({
    required String cpf,
    required String password,
    required bool remember,
  }) =>
      _repo.signIn(cpf: cpf, password: password, remember: remember);
}

class Register {
  const Register(this._repo);
  final AuthRepository _repo;
  Future<UserEntity> call({
    required String name,
    required String cpf,
    required String password,
  }) =>
      _repo.register(name: name, cpf: cpf, password: password);
}

class SignOut {
  const SignOut(this._repo);
  final AuthRepository _repo;
  Future<void> call() => _repo.signOut();
}
