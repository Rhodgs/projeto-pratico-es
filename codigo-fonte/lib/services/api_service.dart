import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiException implements Exception {
  ApiException({required this.statusCode, required this.message});

  final int statusCode;
  final String message;

  @override
  String toString() => message;
}

class ApiService {
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const String baseUrl = 'http://localhost:3000/api';

  static final ApiService instance = ApiService();

  Map<String, String> get _jsonHeaders => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  Map<String, dynamic> _parseResponse(http.Response response) {
    Map<String, dynamic>? body;
    if (response.body.isNotEmpty) {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        body = decoded;
      }
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      return body ?? {};
    }

    final message = body?['message'] as String? ??
        body?['error'] as String? ??
        'Erro HTTP ${response.statusCode}';
    throw ApiException(statusCode: response.statusCode, message: message);
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: _jsonHeaders,
      body: jsonEncode({'email': email, 'password': password}),
    );
    return _parseResponse(response);
  }

  Future<Map<String, dynamic>> cadastrarUsuario({
    required String nome,
    required String email,
    required String senha,
    required String role,
    String? codigoTurma,
  }) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: _jsonHeaders,
      body: jsonEncode({
        'nome': nome,
        'email': email,
        'senha': senha,
        'role': role,
        if (codigoTurma != null && codigoTurma.isNotEmpty)
          'codigoTurma': codigoTurma,
      }),
    );
    return _parseResponse(response);
  }

  Future<Map<String, dynamic>> recuperarSenha({required String email}) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/auth/forgot-password'),
      headers: _jsonHeaders,
      body: jsonEncode({'email': email}),
    );
    return _parseResponse(response);
  }

  Future<Map<String, dynamic>> lancarDesafio({
    required String titulo,
    required String descricao,
    required String prazoLimite,
  }) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/desafios'),
      headers: _jsonHeaders,
      body: jsonEncode({
        'titulo': titulo,
        'descricao': descricao,
        'prazoLimite': prazoLimite,
      }),
    );
    return _parseResponse(response);
  }

  Future<Map<String, dynamic>> anexarEvidencia({
    required String desafioId,
    required String arquivoNome,
  }) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/desafios/$desafioId/evidencias'),
      headers: _jsonHeaders,
      body: jsonEncode({'arquivoNome': arquivoNome}),
    );
    return _parseResponse(response);
  }

  Future<List<dynamic>> listarTurmas() async {
    final response = await _client.get(
      Uri.parse('$baseUrl/turmas'),
      headers: _jsonHeaders,
    );
    final parsed = jsonDecode(response.body);
    if (parsed is List) return parsed;
    return [];
  }

  Future<Map<String, dynamic>> criarTurma({required String nome}) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/turmas'),
      headers: _jsonHeaders,
      body: jsonEncode({'nome': nome}),
    );
    return _parseResponse(response);
  }

  Future<Map<String, dynamic>> excluirTurma({required String turmaId}) async {
    final response = await _client.delete(
      Uri.parse('$baseUrl/turmas/$turmaId'),
      headers: _jsonHeaders,
    );
    return _parseResponse(response);
  }

  Future<Map<String, dynamic>> aprovarEvidencia({
    required String evidenciaId,
  }) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/evidencias/$evidenciaId/aprovar'),
      headers: _jsonHeaders,
    );
    return _parseResponse(response);
  }

  Future<Map<String, dynamic>> recusarEvidencia({
    required String evidenciaId,
  }) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/evidencias/$evidenciaId/recusar'),
      headers: _jsonHeaders,
    );
    return _parseResponse(response);
  }

  Future<Map<String, dynamic>> salvarPreferenciasAcessibilidade({
    required bool modoEscuro,
    required bool modoDaltonismo,
    required double tamanhoFonte,
  }) async {
    final response = await _client.put(
      Uri.parse('$baseUrl/usuario/preferencias'),
      headers: _jsonHeaders,
      body: jsonEncode({
        'modoEscuro': modoEscuro,
        'modoDaltonismo': modoDaltonismo,
        'tamanhoFonte': tamanhoFonte,
      }),
    );
    return _parseResponse(response);
  }

  Future<Map<String, dynamic>> iniciarQuiz({required String quizId}) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/quiz/$quizId/iniciar'),
      headers: _jsonHeaders,
    );
    return _parseResponse(response);
  }

  Future<Map<String, dynamic>> listarConteudosAprendizado() async {
    final response = await _client.get(
      Uri.parse('$baseUrl/aprender/conteudos'),
      headers: _jsonHeaders,
    );
    return _parseResponse(response);
  }

  Future<Map<String, dynamic>> buscarPerfil() async {
    final response = await _client.get(
      Uri.parse('$baseUrl/usuario/perfil'),
      headers: _jsonHeaders,
    );
    return _parseResponse(response);
  }
}
