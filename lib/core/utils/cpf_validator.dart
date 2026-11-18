class CpfValidator {
  const CpfValidator._();

  static String digitsOnly(String input) => input.replaceAll(RegExp(r'\D'), '');

  static bool isValid(String input) {
    final d = digitsOnly(input);
    if (d.length != 11) return false;
    if (RegExp(r'^(\d)\1{10}$').hasMatch(d)) return false;

    int check(int length) {
      var sum = 0;
      for (var i = 0; i < length; i++) {
        sum += int.parse(d[i]) * (length + 1 - i);
      }
      final rest = (sum * 10) % 11;
      return rest == 10 ? 0 : rest;
    }

    return check(9) == int.parse(d[9]) && check(10) == int.parse(d[10]);
  }
}
