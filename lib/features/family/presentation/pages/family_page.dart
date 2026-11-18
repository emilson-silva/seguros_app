import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seguros_app/core/theme/app_theme.dart';
import 'package:seguros_app/features/family/presentation/bloc/family_bloc.dart';
import 'package:seguros_app/features/family/presentation/bloc/family_event.dart';
import 'package:seguros_app/features/family/presentation/bloc/family_state.dart';
import 'package:seguros_app/features/family/presentation/widgets/add_member_dialog.dart';

class FamilyPage extends StatelessWidget {
  const FamilyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showAddMemberDialog(context),
        icon: const Icon(Icons.person_add_alt),
        label: const Text('Adicionar'),
      ),
      body: BlocBuilder<FamilyBloc, FamilyState>(
        builder: (context, state) {
          if (state.status == FamilyStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.members.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Nenhum familiar cadastrado ainda.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.members.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, i) {
                  final m = state.members[i];
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary,
                        child: Text(m.name.isEmpty ? '?' : m.name[0].toUpperCase()),
                      ),
                      title: Text(m.name),
                      subtitle: Text(m.relationship),
                      trailing: IconButton(
                        tooltip: 'Remover',
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => context
                            .read<FamilyBloc>()
                            .add(FamilyMemberRemoved(m.id)),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
