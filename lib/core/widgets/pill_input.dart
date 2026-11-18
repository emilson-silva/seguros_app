import 'package:flutter/material.dart';

/// Decoração "pílula" dos campos de login, como no layout de referência.
InputDecoration pillInput(String hint, {Widget? suffix}) {
  OutlineInputBorder border(Color c) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(28),
        borderSide: BorderSide(color: c),
      );
  return InputDecoration(
    hintText: hint,
    suffixIcon: suffix,
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    enabledBorder: border(Colors.white54),
    focusedBorder: border(const Color(0xFF2FB59A)),
    errorBorder: border(Colors.redAccent),
    focusedErrorBorder: border(Colors.redAccent),
  );
}
