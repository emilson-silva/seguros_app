import 'package:flutter/material.dart';
import 'package:seguros_app/features/shell/presentation/drawer_items.dart';

/// Placeholder das seções do menu que ainda não foram implementadas.
class SectionPage extends StatelessWidget {
  const SectionPage({super.key, required this.slug});
  final String slug;

  @override
  Widget build(BuildContext context) {
    final item = drawerItems.where((i) => i.route == '/section/$slug');
    final title = item.isEmpty ? 'Seção' : item.first.label;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(item.isEmpty ? Icons.help_outline : item.first.icon, size: 48),
          const SizedBox(height: 12),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          const Text('Em construção'),
        ],
      ),
    );
  }
}
