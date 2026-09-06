import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_exception.dart';
import 'json_headers_client.dart';

/// Adapta HTTP para JSON; não altera o contrato do cliente HTTP decorado.
class JsonApiClient {
  JsonApiClient({required String baseUrl, required http.Client client})
    : _baseUrl = baseUrl,
      _client = JsonHeadersClient(client);
  final String _baseUrl;
  final http.Client _client;

  Future<T> _request<T>(
    String method,
    String endpoint,
    T empty, {
    Map<String, dynamic>? body,
    Map<String, String>? query,
  }) async {
    final uri = Uri.parse('$_baseUrl$endpoint').replace(queryParameters: query);
    final request = http.Request(method, uri);
    if (body != null) {
      request.encoding = utf8;
      request.body = jsonEncode(body);
      // O produtor do JSON substitui o text/plain definido por Request.body.
      request.headers['Content-Type'] = 'application/json; charset=utf-8';
    }
    final response = await http.Response.fromStream(
      await _client.send(request),
    );
    final success = response.statusCode >= 200 && response.statusCode < 300;
    dynamic decoded;
    try {
      if (response.body.isNotEmpty) decoded = jsonDecode(response.body);
    } on FormatException {
      throw ApiException(
        statusCode: response.statusCode,
        message: success
            ? 'Resposta inválida da API: JSON esperado.'
            : 'Erro HTTP ${response.statusCode}',
      );
    }
    if (!success) {
      String? message;
      if (decoded is Map<String, dynamic>) {
        for (final key in ['erro', 'message', 'error']) {
          if (decoded[key] is String) {
            message = decoded[key] as String;
            break;
          }
        }
      }
      throw ApiException(
        statusCode: response.statusCode,
        message: message ?? 'Erro HTTP ${response.statusCode}',
      );
    }
    if (decoded == null) return empty;
    if (decoded is T) return decoded;
    throw ApiException(
      statusCode: response.statusCode,
      message:
          'Resposta inválida da API: ${empty is List ? 'lista' : 'objeto'} esperado.',
    );
  }

  Future<Map<String, dynamic>> object(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? query,
  }) => _request<Map<String, dynamic>>(
    method,
    endpoint,
    {},
    body: body,
    query: query,
  );

  Future<List<dynamic>> list(String endpoint, {Map<String, String>? query}) =>
      _request<List<dynamic>>('GET', endpoint, [], query: query);

  void close() => _client.close();
}
