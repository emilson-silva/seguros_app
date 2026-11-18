**Demo:** https://seguro-8f5ca.web.app

# Seguros App — Desafio Técnico Flutter

App de seguros (mobile + web, mesmo código) com **Flutter**, **BLoC**, **Firebase Auth** e **Cloud Firestore**.

## Funcionalidades

| Requisito | Onde |
|---|---|
| Login com CPF + senha, "Lembrar sempre", "Esqueceu a senha?", redes sociais ilustrativas, aba **Cadastrar** | `features/auth/presentation/pages/login_page.dart` |
| Login funcional (diferencial) | Firebase Auth (`features/auth/data`) |
| Home: nome do usuário, Cotar e Contratar (Automóvel, Residência, Vida, Acidentes Pessoais), Minha Família, Contratados | `features/home` |
| Minha Família com adicionar/remover membros em tempo real | Firestore (`features/family`) |
| Drawer com nome/avatar e os 10 itens de menu | `features/shell` |
| Card **Automóvel** abre WebView | `features/webview` (mobile) / nova aba (web) |
| Responsivo | `AppScaffold`: Drawer no mobile, menu lateral fixo ≥ 900px |

## Arquitetura

Clean Architecture por feature (`data` / `domain` / `presentation`), BLoC para estado, `get_it` para DI e `go_router` para navegação (redirect reativo ao `AuthBloc`).

```
lib/
├── core/            # di, router, theme, widgets, utils (CPF), storage, responsive
└── features/
    ├── auth/        # data (Firebase) · domain (entity, repo, usecases) · presentation (bloc, page)
    ├── family/      # data (Firestore) · domain · presentation
    ├── home/
    ├── shell/       # AppScaffold + Drawer responsivo
    └── webview/
```

Fluxo: `Widget → Bloc → UseCase → Repository (interface) → RepositoryImpl → DataSource → Firebase`.
O repositório converte `FirebaseException` em `AppFailure` (mensagem em PT-BR), então o BLoC nunca conhece o Firebase.

### Decisões

- **CPF no Firebase Auth**: o Firebase não suporta CPF como identificador. Cada CPF vira um e-mail sintético (`<cpf>@app.seguros`); nome e CPF ficam em `users/{uid}`. Consequência: "Esqueceu a senha?" é ilustrativo (não há e-mail real). Em produção, o ideal é um backend que resolva CPF → conta.
- **"Lembrar sempre"**: no web usa `Persistence.LOCAL`/`SESSION`; no mobile a sessão não é restaurada se a opção estiver desmarcada. O último CPF é guardado em `shared_preferences`.
- **WebView no web**: `webview_flutter` não tem suporte confiável no web, então lá a URL abre em nova aba.
- **Segurança**: `firestore.rules` restringe leitura/escrita de `users/{uid}/**` ao próprio usuário.

## Como rodar

Pré-requisitos: Flutter (stable), Firebase CLI e `flutterfire_cli`.

```bash
# 1) gera android/ ios/ web/ e baixa dependências
./setup.sh

# 2) conecta ao SEU projeto Firebase (sobrescreve lib/firebase_options.dart)
dart pub global activate flutterfire_cli
flutterfire configure

# 3) no console Firebase: Authentication > E-mail/senha (ativar) e Firestore (criar)
firebase deploy --only firestore:rules

# 4) executar
flutter run -d chrome        # web
flutter run                  # mobile
```

Android: confirme `<uses-permission android:name="android.permission.INTERNET"/>` em `android/app/src/main/AndroidManifest.xml` (necessário para a WebView em release) e `minSdkVersion 23` ou maior.

Se usar FVM: `fvm use <versão>` e rode os comandos com `fvm flutter ...`.

## Testes

```bash
flutter test
```

- `cpf_validator_test`: validação de CPF.
- `auth_bloc_test`: estados do AuthBloc (sessão, login, cadastro, falhas, logout).
- `auth_remote_datasource_test`: cadastro grava o perfil no Firestore (fakes).
- `login_page_test`: widget test da tela de login.
- `family_bloc_test` / `family_datasource_test`: BLoC da família e persistência no Firestore (fake).

## Deploy web (Firebase Hosting)

```bash
flutter build web --release
firebase init hosting   # public dir: build/web, SPA: sim (ou use o firebase.json do repo)
firebase deploy --only hosting
```
