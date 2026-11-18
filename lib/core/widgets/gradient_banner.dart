import 'package:flutter/material.dart';
import 'package:seguros_app/core/theme/app_theme.dart';

class GradientBanner extends StatelessWidget {
  const GradientBanner({super.key, required this.name, required this.initials});
  final String name;
  final String initials;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(gradient: AppColors.gradient),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.background,
            child: Text(initials),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Bem-vindo',
                  style: TextStyle(fontSize: 12, color: Colors.white70)),
              Text(name,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }
}
