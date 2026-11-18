import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:seguros_app/core/error/failure.dart';
import 'package:seguros_app/core/storage/local_storage.dart';
import 'package:seguros_app/core/utils/cpf_validator.dart';
import 'package:seguros_app/features/auth/data/auth_remote_datasource.dart';
import 'package:seguros_app/features/auth/domain/auth_repository.dart';
import 'package:seguros_app/features/auth/domain/user_entity.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remote, this._storage);

  final AuthRemoteDataSource _remote;
  final LocalStorage _storage;

  @override
  Future<UserEntity?> currentUser() async {
    try {
      // Mobile: sem "Lembrar sempre", não restaura a sessão anterior.
      if (!kIsWeb && !_storage.remember && _remote.hasSession) {
        await _remote.signOut();
        return null;
      }
      return await _remote.currentUser();
    } on FirebaseException {
      return null;
    }
  }

  @override
  Future<UserEntity> signIn({
    required String cpf,
    required String password,
    required bool remember,
  }) =>
      _guard(() async {
        final user = await _remote.signIn(cpf, password, remember: remember);
        await _storage.saveRemember(
          remember: remember,
          cpf: CpfValidator.digitsOnly(cpf),
        );
        return user;
      });

  @override
  Future<UserEntity> register({
    required String name,
    required String cpf,
    required String password,
  }) =>
      _guard(() async {
        final user = await _remote.register(name, cpf, password);
        await _storage.saveRemember(
          remember: true,
          cpf: CpfValidator.digitsOnly(cpf),
        );
        return user;
      });

  @override
  Future<void> signOut() => _remote.signOut();

  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on FirebaseAuthException catch (e) {
      throw AppFailure(_authMessage(e.code));
    } on FirebaseException catch (e) {
      throw AppFailure('Erro ao acessar os dados (${e.code}).');
    }
  }

  String _authMessage(String code) => switch (code) {
        'user-not-found' ||
        'wrong-password' ||
        'invalid-credential' ||
        'invalid-email' =>
          'CPF ou senha inválidos.',
        'email-already-in-use' => 'Já existe uma conta com este CPF.',
        'weak-password' => 'Senha muito fraca. Use ao menos 6 caracteres.',
        'network-request-failed' => 'Sem conexão. Verifique sua internet.',
        'too-many-requests' => 'Muitas tentativas. Tente novamente mais tarde.',
        _ => 'Erro de autenticação ($code).',
      };
}
