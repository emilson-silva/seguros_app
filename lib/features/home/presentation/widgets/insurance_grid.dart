import 'package:flutter/material.dart';
import 'package:seguros_app/core/responsive/breakpoints.dart';
import 'package:seguros_app/core/theme/app_theme.dart';

class InsuranceItem {
  const InsuranceItem(this.label, this.icon, {this.id});
  final String label;
  final IconData icon;
  final String? id;
}

const insuranceItems = [
  InsuranceItem('Automóvel', Icons.directions_car_outlined, id: 'auto'),
  InsuranceItem('Residência', Icons.home_work_outlined),
  InsuranceItem('Vida', Icons.favorite_border),
  InsuranceItem('Acidentes Pessoais', Icons.personal_injury_outlined),
  // Exibidos só em telas largas (como no layout desktop de referência).
  InsuranceItem('Moto', Icons.two_wheeler_outlined),
  InsuranceItem('Empresa', Icons.business_outlined),
];

class InsuranceGrid extends StatelessWidget {
  const InsuranceGrid({super.key, required this.onTap});
  final ValueChanged<InsuranceItem> onTap;

  @override
  Widget build(BuildContext context) {
    final items =
        Breakpoints.isWide(context) ? insuranceItems : insuranceItems.take(4);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Material(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  key: Key('insurance_${item.label}'),
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => onTap(item),
                  child: SizedBox(
                    width: 92,
                    height: 84,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(item.icon, color: AppColors.primary, size: 28),
                        const SizedBox(height: 8),
                        Text(
                          item.label,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
