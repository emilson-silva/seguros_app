import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:seguros_app/core/constants/app_constants.dart';
import 'package:seguros_app/core/di/injection.dart';
import 'package:seguros_app/core/router/go_router_refresh_stream.dart';
import 'package:seguros_app/core/storage/local_storage.dart';
import 'package:seguros_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:seguros_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:seguros_app/features/auth/presentation/pages/login_page.dart';
import 'package:seguros_app/features/family/presentation/bloc/family_bloc.dart';
import 'package:seguros_app/features/family/presentation/bloc/family_event.dart';
import 'package:seguros_app/features/family/presentation/pages/family_page.dart';
import 'package:seguros_app/features/home/presentation/pages/home_page.dart';
import 'package:seguros_app/features/shell/presentation/app_scaffold.dart';
import 'package:seguros_app/features/shell/presentation/section_page.dart';
import 'package:seguros_app/features/webview/presentation/webview_page.dart';

GoRouter createRouter(AuthBloc authBloc) {
  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (context, state) {
      final auth = authBloc.state;
      final loc = state.matchedLocation;

      if (auth is AuthInitial) return loc == '/splash' ? null : '/splash';
      if (auth is! Authenticated) return loc == '/login' ? null : '/login';
      if (loc == '/login' || loc == '/splash') return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (_, __) =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
      GoRoute(
        path: '/login',
        builder: (_, __) =>
            LoginPage(initialCpf: getIt<LocalStorage>().rememberedCpf),
      ),
      GoRoute(
        path: '/webview',
        builder: (_, state) => WebViewPage(
          title: state.uri.queryParameters['title'] ?? 'Automóvel',
          url: state.uri.queryParameters['url'] ?? AppConstants.automovelUrl,
        ),
      ),
      ShellRoute(
        builder: (context, state, child) {
          final auth = context.read<AuthBloc>().state;
          if (auth is! Authenticated) return const SizedBox.shrink();
          return BlocProvider<FamilyBloc>(
            create: (_) =>
                getIt<FamilyBloc>()..add(FamilyWatchStarted(auth.user.uid)),
            child: AppScaffold(user: auth.user, child: child),
          );
        },
        routes: [
          GoRoute(path: '/home', builder: (_, __) => const HomePage()),
          GoRoute(path: '/family', builder: (_, __) => const FamilyPage()),
          GoRoute(
            path: '/section/:slug',
            builder: (_, state) =>
                SectionPage(slug: state.pathParameters['slug'] ?? ''),
          ),
        ],
      ),
    ],
  );
}
