import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seguros_app/core/error/failure.dart';
import 'package:seguros_app/features/auth/domain/usecases/auth_usecases.dart';
import 'package:seguros_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:seguros_app/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required GetCurrentUser getCurrentUser,
    required SignIn signIn,
    required Register register,
    required SignOut signOut,
  })  : _getCurrentUser = getCurrentUser,
        _signIn = signIn,
        _register = register,
        _signOut = signOut,
        super(AuthInitial()) {
    on<AuthStarted>(_onStarted);
    on<AuthLoginRequested>(_onLogin);
    on<AuthRegisterRequested>(_onRegister);
    on<AuthLogoutRequested>(_onLogout);
  }

  final GetCurrentUser _getCurrentUser;
  final SignIn _signIn;
  final Register _register;
  final SignOut _signOut;

  Future<void> _onStarted(AuthStarted event, Emitter<AuthState> emit) async {
    final user = await _getCurrentUser();
    emit(user != null ? Authenticated(user) : Unauthenticated());
  }

  Future<void> _onLogin(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) =>
      _run(emit, () async {
        final user = await _signIn(
          cpf: event.cpf,
          password: event.password,
          remember: event.remember,
        );
        emit(Authenticated(user));
      });

  Future<void> _onRegister(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) =>
      _run(emit, () async {
        final user = await _register(
          name: event.name,
          cpf: event.cpf,
          password: event.password,
        );
        emit(Authenticated(user));
      });

  Future<void> _onLogout(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _signOut();
    emit(Unauthenticated());
  }

  Future<void> _run(Emitter<AuthState> emit, Future<void> Function() body) async {
    emit(AuthLoading());
    try {
      await body();
    } on AppFailure catch (e) {
      emit(AuthFailure(e.message));
    } catch (_) {
      emit(const AuthFailure('Erro inesperado. Tente novamente.'));
    }
  }
}
