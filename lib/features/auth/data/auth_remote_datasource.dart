import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:seguros_app/core/constants/app_constants.dart';
import 'package:seguros_app/core/utils/cpf_validator.dart';
import 'package:seguros_app/features/auth/data/user_model.dart';

/// Firebase Auth não tem login por CPF: usamos um e-mail sintético derivado do CPF
/// (ex.: 52998224725@app.seguros) como identificador. O perfil fica em `users/{uid}`.
class AuthRemoteDataSource {
  AuthRemoteDataSource(this._auth, this._db);

  final FirebaseAuth _auth;
  final FirebaseFirestore _db;

  bool get hasSession => _auth.currentUser != null;

  String _emailFromCpf(String cpf) =>
      '${CpfValidator.digitsOnly(cpf)}@${AppConstants.syntheticEmailDomain}';

  Future<UserModel?> currentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    return _fetchProfile(user.uid);
  }

  Future<UserModel> signIn(
    String cpf,
    String password, {
    required bool remember,
  }) async {
    if (kIsWeb) {
      // No mobile a sessão sempre persiste; no web controlamos pela persistência.
      await _auth.setPersistence(
        remember ? Persistence.LOCAL : Persistence.SESSION,
      );
    }

    final cred = await _auth.signInWithEmailAndPassword(
      email: _emailFromCpf(cpf),
      password: password,
    );

    return _fetchProfile(cred.user!.uid);
  }

  Future<UserModel> register(
    String name,
    String cpf,
    String password,
  ) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: _emailFromCpf(cpf),
      password: password,
    );

    final user = cred.user!;

    final model = UserModel(
      uid: user.uid,
      name: name,
      cpf: CpfValidator.digitsOnly(cpf),
    );

    try {
      await _db.collection('users').doc(model.uid).set(
            model.toMap(),
          );
    } catch (_) {
      // Rollback: remove a conta caso o perfil não seja salvo.
      try {
        await user.delete();
      } catch (_) {
        // Preserva a exceção original.
      }

      rethrow;
    }

    return model;
  }

  Future<void> signOut() => _auth.signOut();

  Future<UserModel> _fetchProfile(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    final data = doc.data();

    if (data == null) {
      return UserModel(
        uid: uid,
        name: 'Usuário',
        cpf: '',
      );
    }

    return UserModel.fromMap(uid, data);
  }
}
