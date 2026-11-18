import 'package:seguros_app/core/utils/cpf_validator.dart';

class Validators {
  const Validators._();

  static String? cpf(String? v) {
    if (v == null || v.trim().isEmpty) return 'Informe o CPF';
    return CpfValidator.isValid(v) ? null : 'CPF inválido';
  }

  static String? password(String? v) {
    if (v == null || v.isEmpty) return 'Informe a senha';
    if (v.length < 6) return 'Mínimo de 6 caracteres';
    return null;
  }

  static String? name(String? v) {
    if (v == null || v.trim().length < 2) return 'Informe o nome';
    return null;
  }
}
