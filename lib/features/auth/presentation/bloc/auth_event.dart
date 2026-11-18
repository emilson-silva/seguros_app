import 'package:equatable/equatable.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthStarted extends AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  const AuthLoginRequested(this.cpf, this.password, {this.remember = false});

  final String cpf;
  final String password;
  final bool remember;

  @override
  List<Object?> get props => [cpf, password, remember];
}

class AuthRegisterRequested extends AuthEvent {
  const AuthRegisterRequested({
    required this.name,
    required this.cpf,
    required this.password,
  });

  final String name;
  final String cpf;
  final String password;

  @override
  List<Object?> get props => [name, cpf, password];
}

class AuthLogoutRequested extends AuthEvent {}
