import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:seguros_app/core/constants/app_constants.dart';
import 'package:seguros_app/core/widgets/empty_state_card.dart';
import 'package:seguros_app/core/widgets/gradient_banner.dart';
import 'package:seguros_app/core/widgets/section_title.dart';
import 'package:seguros_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:seguros_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:seguros_app/features/family/presentation/widgets/family_section.dart';
import 'package:seguros_app/features/home/presentation/widgets/insurance_grid.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _onInsuranceTap(BuildContext context, InsuranceItem item) async {
    if (item.id != 'auto') {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('${item.label}: em breve.')));
      return;
    }
    if (kIsWeb) {
      // WebView não é suportada de forma confiável no web: abre em nova aba.
      await launchUrl(
        Uri.parse(AppConstants.automovelUrl),
        webOnlyWindowName: '_blank',
      );
    } else {
      final uri = Uri(path: '/webview', queryParameters: {
        'url': AppConstants.automovelUrl,
        'title': item.label,
      });
      context.push(uri.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthBloc>().state;
    final user = auth is Authenticated ? auth.user : null;

    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GradientBanner(
                name: user?.name ?? '',
                initials: user?.initials ?? '?',
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionTitle('Cotar e Contratar'),
                    InsuranceGrid(onTap: (i) => _onInsuranceTap(context, i)),
                    const SectionTitle('Minha Família'),
                    const FamilySection(),
                    const SectionTitle('Contratados'),
                    const EmptyStateCard(
                      icon: Icons.sentiment_dissatisfied_outlined,
                      message: 'Você ainda não possui seguros contratados.',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
