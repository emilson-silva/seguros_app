import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seguros_app/core/theme/app_theme.dart';
import 'package:seguros_app/core/utils/validators.dart';
import 'package:seguros_app/features/family/presentation/bloc/family_bloc.dart';
import 'package:seguros_app/features/family/presentation/bloc/family_event.dart';

const _relationships = ['Cônjuge', 'Filho(a)', 'Pai', 'Mãe', 'Irmão(ã)', 'Outro'];

Future<void> showAddMemberDialog(BuildContext context) async {
  final bloc = context.read<FamilyBloc>();
  final result = await showDialog<({String name, String relationship})>(
    context: context,
    builder: (_) => const _AddMemberDialog(),
  );
  if (result != null) {
    bloc.add(
      FamilyMemberAdded(name: result.name, relationship: result.relationship),
    );
  }
}

class _AddMemberDialog extends StatefulWidget {
  const _AddMemberDialog();

  @override
  State<_AddMemberDialog> createState() => _AddMemberDialogState();
}

class _AddMemberDialogState extends State<_AddMemberDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  String _relationship = _relationships.first;

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.of(context).pop((
      name: _nameCtrl.text.trim(),
      relationship: _relationship,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: const Text('Adicionar familiar'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              key: const Key('member_name_field'),
              controller: _nameCtrl,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Nome'),
              validator: Validators.name,
            ),
            const SizedBox(height: 16),
            const Text('Parentesco'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                for (final r in _relationships)
                  ChoiceChip(
                    label: Text(r),
                    selected: _relationship == r,
                    onSelected: (_) => setState(() => _relationship = r),
                  ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(onPressed: _save, child: const Text('Salvar')),
      ],
    );
  }
}
