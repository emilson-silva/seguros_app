import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seguros_app/core/theme/app_theme.dart';
import 'package:seguros_app/core/widgets/empty_state_card.dart';
import 'package:seguros_app/features/family/presentation/bloc/family_bloc.dart';
import 'package:seguros_app/features/family/presentation/bloc/family_state.dart';
import 'package:seguros_app/features/family/presentation/widgets/add_member_dialog.dart';

/// Seção "Minha Família" da Home.
class FamilySection extends StatelessWidget {
  const FamilySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FamilyBloc, FamilyState>(
      listenWhen: (p, c) => c.errorMessage != null,
      listener: (context, state) => ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(state.errorMessage!))),
      builder: (context, state) {
        if (state.status == FamilyStatus.loading) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (state.members.isEmpty) {
          return EmptyStateCard(
            icon: Icons.add_circle_outline,
            message:
                'Adicione aqui membros da sua família e compartilhe os seguros com eles.',
            onTap: () => showAddMemberDialog(context),
          );
        }
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final m in state.members)
              Container(
                width: 160,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.primary,
                      child: Text(m.name.isEmpty ? '?' : m.name[0].toUpperCase()),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(m.name,
                              maxLines: 1, overflow: TextOverflow.ellipsis),
                          Text(m.relationship,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.white70)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            InkWell(
              key: const Key('add_member_card'),
              onTap: () => showAddMemberDialog(context),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 160,
                height: 64,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(Icons.add), SizedBox(width: 6), Text('Adicionar')],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
