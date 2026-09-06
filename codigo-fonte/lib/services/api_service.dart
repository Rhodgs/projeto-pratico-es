import 'package:http/http.dart' as http;

import 'api_exception.dart';
import 'json_api_client.dart';
import 'usuario_session.dart';

// Preserva os imports existentes das telas que utilizam ApiException.
export 'api_exception.dart';

/// Facade: expõe operações do aplicativo e esconde o transporte HTTP.
class ApiService {
  ApiService({http.Client? client})
    : _api = JsonApiClient(baseUrl: baseUrl, client: client ?? http.Client());
  final JsonApiClient _api;
  static const String baseUrl = 'http://localhost:3000/api';
  static final ApiService instance = ApiService();

  Future<Map<String, dynamic>> login(String email, String password) => _api
      .object('POST', '/auth/login', body: {'email': email, 'senha': password});

  Future<Map<String, dynamic>> cadastrarUsuario({
    required String name,
    required String email,
    required String password,
    required String role,
    String? classCode,
  }) => _api.object(
    'POST',
    '/auth/register',
    body: {
      'nome': name,
      'email': email,
      'senha': password,
      'role': role,
      'codigoTurma': classCode,
    },
  );

  Future<Map<String, dynamic>> buscarPreferenciasAcessibilidade() =>
      _api.object(
        'GET',
        '/usuario/preferencias',
        query: {'id': '${UsuarioSession.id}'},
      );

  Future<Map<String, dynamic>> recuperarSenha({required String email}) =>
      _api.object('POST', '/auth/forgot-password', body: {'email': email});

  Future<Map<String, dynamic>> lancarDesafio({
    required String title,
    required String description,
    required int points,
    required DateTime deadline,
  }) => _api.object(
    'POST',
    '/desafios',
    body: {
      'titulo': title,
      'descricao': description,
      'pontuacao': points,
      'prazoLimite': deadline.toIso8601String(),
    },
  );

  // Mantém o contrato anterior; upload multipart é uma correção separada.
  Future<Map<String, dynamic>> anexarEvidencia({
    required String desafioId,
    required String arquivoNome,
  }) => _api.object(
    'POST',
    '/desafios/${Uri.encodeComponent(desafioId)}/evidencias',
    body: {'arquivoNome': arquivoNome},
  );

  Future<List<dynamic>> listarTurmas() => _api.list(
    '/turmas',
    query: UsuarioSession.id == null
        ? null
        : {'professorId': UsuarioSession.id!},
  );

  Future<Map<String, dynamic>> criarTurma({required String nome}) =>
      _api.object(
        'POST',
        '/turmas',
        body: {'nome': nome, 'professorId': UsuarioSession.id},
      );

  Future<Map<String, dynamic>> excluirTurma({required String turmaId}) =>
      _api.object('DELETE', '/turmas/${Uri.encodeComponent(turmaId)}');

  Future<Map<String, dynamic>> aprovarEvidencia(String evidenciaId) =>
      _api.object(
        'POST',
        '/evidencias/${Uri.encodeComponent(evidenciaId)}/aprovar',
      );

  Future<Map<String, dynamic>> recusarEvidencia(
    String evidenciaId,
    String justification,
  ) => _api.object(
    'POST',
    '/evidencias/${Uri.encodeComponent(evidenciaId)}/recusar',
    body: {'justificativa': justification},
  );

  Future<Map<String, dynamic>> salvarPreferenciasAcessibilidade({
    required bool modoEscuro,
    required bool modoDaltonismo,
    required double tamanhoFonte,
  }) => _api.object(
    'PUT',
    '/usuario/preferencias',
    query: {'id': '${UsuarioSession.id}'},
    body: {
      'modoEscuro': modoEscuro,
      'modoDaltonismo': modoDaltonismo,
      'tamanhoFonte': tamanhoFonte,
    },
  );

  Future<Map<String, dynamic>> iniciarQuiz({required String quizId}) =>
      _api.object('POST', '/quiz/${Uri.encodeComponent(quizId)}/iniciar');

  Future<Map<String, dynamic>> listarConteudosAprendizado() =>
      _api.object('GET', '/aprender/conteudos');

  Future<Map<String, dynamic>> buscarPerfil() async {
    final userId = UsuarioSession.id;
    if (userId == null) {
      throw ApiException(
        statusCode: 401,
        message: 'Nenhum usuário logado. Faça login novamente.',
      );
    }
    return _api.object('GET', '/usuario/perfil', query: {'id': userId});
  }

  Future<Map<String, dynamic>> buscarRanking({required String turmaId}) =>
      _api.object(
        'GET',
        '/turmas/${Uri.encodeComponent(turmaId)}/ranking',
        query: UsuarioSession.id == null
            ? null
            : {'alunoId': UsuarioSession.id!},
      );

  void close() => _api.close();
}
