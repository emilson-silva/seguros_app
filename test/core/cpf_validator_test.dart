import 'package:flutter_test/flutter_test.dart';
import 'package:seguros_app/core/utils/cpf_validator.dart';

void main() {
  group('CpfValidator', () {
    test('aceita CPFs válidos (com e sem máscara)', () {
      expect(CpfValidator.isValid('529.982.247-25'), isTrue);
      expect(CpfValidator.isValid('52998224725'), isTrue);
      expect(CpfValidator.isValid('111.444.777-35'), isTrue);
    });

    test('rejeita dígitos verificadores errados', () {
      expect(CpfValidator.isValid('529.982.247-24'), isFalse);
    });

    test('rejeita sequências repetidas', () {
      expect(CpfValidator.isValid('111.111.111-11'), isFalse);
      expect(CpfValidator.isValid('00000000000'), isFalse);
    });

    test('rejeita tamanho inválido e vazio', () {
      expect(CpfValidator.isValid('123'), isFalse);
      expect(CpfValidator.isValid(''), isFalse);
    });

    test('digitsOnly remove a máscara', () {
      expect(CpfValidator.digitsOnly('529.982.247-25'), '52998224725');
    });
  });
}
