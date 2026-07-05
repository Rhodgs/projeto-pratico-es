class UsuarioSession {
  static String? id;
  static String? nome;
  static String? email;
  static String? perfil;

  static void definir(Map<String, dynamic>? usuario) {
    if (usuario == null) return;
    id = usuario['id'] as String?;
    nome = usuario['nome'] as String?;
    email = usuario['email'] as String?;
    perfil = usuario['perfil'] as String?;
  }

  static void limpar() {
    id = null;
    nome = null;
    email = null;
    perfil = null;
  }
}
