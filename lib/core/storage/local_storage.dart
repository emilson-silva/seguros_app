import 'package:shared_preferences/shared_preferences.dart';

/// Guarda a preferência "Lembrar sempre" e o último CPF usado.
class LocalStorage {
  LocalStorage(this._prefs);
  final SharedPreferences _prefs;

  static const _rememberKey = 'remember_me';
  static const _cpfKey = 'remembered_cpf';

  bool get remember => _prefs.getBool(_rememberKey) ?? false;
  String? get rememberedCpf => _prefs.getString(_cpfKey);

  Future<void> saveRemember({required bool remember, String? cpf}) async {
    await _prefs.setBool(_rememberKey, remember);
    if (remember && cpf != null) {
      await _prefs.setString(_cpfKey, cpf);
    } else {
      await _prefs.remove(_cpfKey);
    }
  }
}
