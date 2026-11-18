import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:seguros_app/core/theme/app_theme.dart';
import 'package:seguros_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:seguros_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:seguros_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:seguros_app/features/auth/presentation/pages/login_page.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

void main() {
  late MockAuthBloc bloc;

  setUpAll(() => registerFallbackValue(AuthStarted()));

  setUp(() {
    bloc = MockAuthBloc();
    whenListen(
      bloc,
      const Stream<AuthState>.empty(),
      initialState: Unauthenticated(),
    );
  });

  Future<void> pumpPage(WidgetTester t, {String? initialCpf}) async {
    t.view.physicalSize = const Size(800, 1600);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.resetPhysicalSize);
    addTearDown(t.view.resetDevicePixelRatio);
    await t.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: BlocProvider<AuthBloc>.value(
          value: bloc,
          child: LoginPage(initialCpf: initialCpf),
        ),
      ),
    );
  }

  Future<void> tapSubmit(WidgetTester t) async {
    final submit = find.byKey(const Key('submit_button'));
    await t.ensureVisible(submit);
    await t.tap(submit);
    await t.pump();
  }

  testWidgets('exibe os elementos exigidos na tela de login', (t) async {
    await pumpPage(t);
    expect(find.text('Entrar'), findsOneWidget);
    expect(find.text('Cadastrar'), findsOneWidget);
    expect(find.text('CPF'), findsOneWidget);
    expect(find.text('Senha'), findsOneWidget);
    expect(find.text('Lembrar sempre'), findsOneWidget);
    expect(find.text('Esqueceu a senha?'), findsOneWidget);
  });

  testWidgets('campos vazios mostram erros e não disparam evento', (t) async {
    await pumpPage(t);
    await tapSubmit(t);
    expect(find.text('Informe o CPF'), findsOneWidget);
    expect(find.text('Informe a senha'), findsOneWidget);
    verifyNever(() => bloc.add(any()));
  });

  testWidgets('CPF inválido mostra erro', (t) async {
    await pumpPage(t);
    await t.enterText(find.byKey(const Key('cpf_field')), '11111111111');
    await t.enterText(find.byKey(const Key('password_field')), '123456');
    await tapSubmit(t);
    expect(find.text('CPF inválido'), findsOneWidget);
    verifyNever(() => bloc.add(any()));
  });

  testWidgets('dados válidos disparam AuthLoginRequested', (t) async {
    await pumpPage(t);
    await t.enterText(find.byKey(const Key('cpf_field')), '52998224725');
    await t.enterText(find.byKey(const Key('password_field')), '123456');
    await tapSubmit(t);
    verify(
      () => bloc.add(
        const AuthLoginRequested('52998224725', '123456', remember: true),
      ),
    ).called(1);
  });

  testWidgets('aba Cadastrar exibe o campo de nome', (t) async {
    await pumpPage(t);
    expect(find.byKey(const Key('name_field')), findsNothing);
    await t.tap(find.byKey(const Key('tab_register')));
    await t.pump();
    expect(find.byKey(const Key('name_field')), findsOneWidget);
    expect(find.byKey(const Key('confirm_field')), findsOneWidget);
  });

  testWidgets('pré-preenche o CPF lembrado, com máscara', (t) async {
    await pumpPage(t, initialCpf: '52998224725');
    expect(find.text('529.982.247-25'), findsOneWidget);
  });
}
