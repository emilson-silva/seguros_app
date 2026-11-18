import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:seguros_app/core/error/failure.dart';
import 'package:seguros_app/features/auth/domain/auth_repository.dart';
import 'package:seguros_app/features/auth/domain/usecases/auth_usecases.dart';
import 'package:seguros_app/features/auth/domain/user_entity.dart';
import 'package:seguros_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:seguros_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:seguros_app/features/auth/presentation/bloc/auth_state.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repo;
  const user = UserEntity(uid: 'u1', name: 'Caio Maximo', cpf: '52998224725');

  AuthBloc buildBloc() => AuthBloc(
        getCurrentUser: GetCurrentUser(repo),
        signIn: SignIn(repo),
        register: Register(repo),
        signOut: SignOut(repo),
      );

  setUp(() => repo = MockAuthRepository());

  blocTest<AuthBloc, AuthState>(
    'AuthStarted sem sessão -> Unauthenticated',
    setUp: () => when(() => repo.currentUser()).thenAnswer((_) async => null),
    build: buildBloc,
    act: (b) => b.add(AuthStarted()),
    expect: () => [Unauthenticated()],
  );

  blocTest<AuthBloc, AuthState>(
    'AuthStarted com sessão -> Authenticated',
    setUp: () => when(() => repo.currentUser()).thenAnswer((_) async => user),
    build: buildBloc,
    act: (b) => b.add(AuthStarted()),
    expect: () => [const Authenticated(user)],
  );

  blocTest<AuthBloc, AuthState>(
    'login com sucesso -> Loading, Authenticated',
    setUp: () => when(
      () => repo.signIn(cpf: '52998224725', password: '123456', remember: true),
    ).thenAnswer((_) async => user),
    build: buildBloc,
    act: (b) =>
        b.add(const AuthLoginRequested('52998224725', '123456', remember: true)),
    expect: () => [AuthLoading(), const Authenticated(user)],
  );

  blocTest<AuthBloc, AuthState>(
    'login com credenciais inválidas -> Loading, AuthFailure',
    setUp: () => when(
      () => repo.signIn(
        cpf: any(named: 'cpf'),
        password: any(named: 'password'),
        remember: any(named: 'remember'),
      ),
    ).thenThrow(const AppFailure('CPF ou senha inválidos.')),
    build: buildBloc,
    act: (b) => b.add(const AuthLoginRequested('52998224725', 'errada')),
    expect: () => [AuthLoading(), const AuthFailure('CPF ou senha inválidos.')],
  );

  blocTest<AuthBloc, AuthState>(
    'erro inesperado vira mensagem genérica',
    setUp: () => when(
      () => repo.signIn(
        cpf: any(named: 'cpf'),
        password: any(named: 'password'),
        remember: any(named: 'remember'),
      ),
    ).thenThrow(StateError('boom')),
    build: buildBloc,
    act: (b) => b.add(const AuthLoginRequested('52998224725', '123456')),
    expect: () => [
      AuthLoading(),
      const AuthFailure('Erro inesperado. Tente novamente.'),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'cadastro com sucesso -> Loading, Authenticated',
    setUp: () => when(
      () => repo.register(name: 'Caio Maximo', cpf: '52998224725', password: '123456'),
    ).thenAnswer((_) async => user),
    build: buildBloc,
    act: (b) => b.add(
      const AuthRegisterRequested(
        name: 'Caio Maximo',
        cpf: '52998224725',
        password: '123456',
      ),
    ),
    expect: () => [AuthLoading(), const Authenticated(user)],
  );

  blocTest<AuthBloc, AuthState>(
    'logout -> Unauthenticated',
    setUp: () => when(() => repo.signOut()).thenAnswer((_) async {}),
    build: buildBloc,
    act: (b) => b.add(AuthLogoutRequested()),
    expect: () => [Unauthenticated()],
    verify: (_) => verify(() => repo.signOut()).called(1),
  );
}
