import 'package:flutter/material.dart';

class DrawerItem {
  const DrawerItem(this.label, this.icon, this.route);
  final String label;
  final IconData icon;
  final String route;
}

const drawerItems = [
  DrawerItem('Home / Seguros', Icons.home_outlined, '/home'),
  DrawerItem('Minhas Contratações', Icons.description_outlined, '/section/contratacoes'),
  DrawerItem('Meus Sinistros', Icons.report_problem_outlined, '/section/sinistros'),
  DrawerItem('Minha Família', Icons.family_restroom_outlined, '/family'),
  DrawerItem('Meus Bens', Icons.inventory_2_outlined, '/section/bens'),
  DrawerItem('Pagamentos', Icons.payments_outlined, '/section/pagamentos'),
  DrawerItem('Coberturas', Icons.shield_outlined, '/section/coberturas'),
  DrawerItem('Validar Boleto', Icons.receipt_long_outlined, '/section/validar-boleto'),
  DrawerItem('Telefones Importantes', Icons.phone_in_talk_outlined, '/section/telefones'),
  DrawerItem('Configurações', Icons.settings_outlined, '/section/configuracoes'),
];
