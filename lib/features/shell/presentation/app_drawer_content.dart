import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:seguros_app/core/theme/app_theme.dart';
import 'package:seguros_app/features/auth/domain/user_entity.dart';
import 'package:seguros_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:seguros_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:seguros_app/features/shell/presentation/drawer_items.dart';

/// Conteúdo do menu: usado no Drawer (mobile) e fixo na lateral (desktop).
class AppDrawerContent extends StatelessWidget {
  const AppDrawerContent({super.key, required this.user, this.onItemTap});

  final UserEntity user;
  final VoidCallback? onItemTap;

  @override
  Widget build(BuildContext context) {
    final current = GoRouterState.of(context).matchedLocation;
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.primary,
                  child: Text(user.initials),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Olá!', style: TextStyle(fontSize: 12)),
                      Text(
                        user.name.toUpperCase(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                for (final item in drawerItems)
                  ListTile(
                    key: Key('drawer_${item.route}'),
                    dense: true,
                    selected: current == item.route,
                    selectedColor: AppColors.primary,
                    leading: Icon(item.icon, size: 20),
                    title: Text(item.label, style: const TextStyle(fontSize: 13)),
                    onTap: () {
                      onItemTap?.call();
                      context.go(item.route);
                    },
                  ),
                ListTile(
                  key: const Key('drawer_logout'),
                  dense: true,
                  leading: const Icon(Icons.logout, size: 20),
                  title: const Text('Sair', style: TextStyle(fontSize: 13)),
                  onTap: () =>
                      context.read<AuthBloc>().add(AuthLogoutRequested()),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(gradient: AppColors.gradient),
            child: const Column(
              children: [
                Icon(Icons.support_agent, color: Colors.white),
                SizedBox(height: 4),
                Text('Dúvidas?',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700)),
                Text(
                  'Converse agora com a nossa assistente virtual.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
