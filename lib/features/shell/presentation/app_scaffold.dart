import 'package:flutter/material.dart';
import 'package:seguros_app/core/responsive/breakpoints.dart';
import 'package:seguros_app/core/theme/app_theme.dart';
import 'package:seguros_app/features/auth/domain/user_entity.dart';
import 'package:seguros_app/features/shell/presentation/app_drawer_content.dart';

/// Casca das telas autenticadas: Drawer no mobile, menu fixo no desktop/web.
class AppScaffold extends StatefulWidget {
  const AppScaffold({super.key, required this.user, required this.child});

  final UserEntity user;
  final Widget child;

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final isDesktop = Breakpoints.isDesktop(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        automaticallyImplyLeading: !isDesktop,
        centerTitle: true,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.shield_outlined, size: 22),
            SizedBox(width: 8),
            Text('SEGUROS',
                style: TextStyle(letterSpacing: 3, fontWeight: FontWeight.w700)),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.notifications_none),
                Positioned(
                  right: 0,
                  top: 14,
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: const BoxDecoration(
                      color: AppColors.pink,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: isDesktop
          ? null
          : Drawer(
              child: AppDrawerContent(
                user: widget.user,
                onItemTap: () => _scaffoldKey.currentState?.closeDrawer(),
              ),
            ),
      body: Row(
        children: [
          if (isDesktop)
            SizedBox(
              width: 260,
              child: ColoredBox(
                color: AppColors.background,
                child: AppDrawerContent(user: widget.user),
              ),
            ),
          Expanded(child: widget.child),
        ],
      ),
    );
  }
}
