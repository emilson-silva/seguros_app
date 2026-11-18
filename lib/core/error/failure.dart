/// Erro de domínio com mensagem já pronta para o usuário.
class AppFailure implements Exception {
  const AppFailure(this.message);
  final String message;

  @override
  String toString() => message;
}
