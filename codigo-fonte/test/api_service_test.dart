import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';
import 'package:jornada_verde/services/api_service.dart';
import 'package:jornada_verde/services/json_headers_client.dart';
import 'package:jornada_verde/services/usuario_session.dart';

import 'fixtures/api_service_antes.dart' as antes;

class _CloseClient extends http.BaseClient {
  bool closed = false;
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async =>
      http.StreamedResponse(Stream.value(utf8.encode('{}')), 200);
  @override
  void close() => closed = true;
}

void main() {
  setUp(() => UsuarioSession.id = 'u1');
  tearDown(UsuarioSession.limpar);

  final operacoes = <String, Future<dynamic> Function(dynamic)>{
    'login': (api) => api.login('ana@example.org', 'senha'),
    'cadastro': (api) => api.cadastrarUsuario(
      name: 'Ana',
      email: 'ana@example.org',
      password: 'senha',
      role: 'Aluno',
      classCode: 'ABC123',
    ),
    'buscar preferências': (api) => api.buscarPreferenciasAcessibilidade(),
    'recuperação': (api) => api.recuperarSenha(email: 'ana@example.org'),
    'desafio': (api) => api.lancarDesafio(
      title: 'Ação',
      description: 'Descrição',
      points: 50,
      deadline: DateTime.utc(2030),
    ),
    'anexo': (api) =>
        api.anexarEvidencia(desafioId: 'd1', arquivoNome: 'foto.png'),
    'listar turmas': (api) => api.listarTurmas(),
    'criar turma': (api) => api.criarTurma(nome: 'Turma A'),
    'excluir turma': (api) => api.excluirTurma(turmaId: 't1'),
    'aprovar': (api) => api.aprovarEvidencia('e1'),
    'recusar': (api) => api.recusarEvidencia('e1', 'Foto insuficiente'),
    'salvar preferências': (api) => api.salvarPreferenciasAcessibilidade(
      modoEscuro: true,
      modoDaltonismo: false,
      tamanhoFonte: 18.0,
    ),
    'quiz': (api) => api.iniciarQuiz(quizId: 'q1'),
    'conteúdos': (api) => api.listarConteudosAprendizado(),
    'perfil': (api) => api.buscarPerfil(),
    'ranking': (api) => api.buscarRanking(turmaId: 't1'),
  };

  for (final caso in operacoes.entries) {
    test('antes/depois preserva contrato: ${caso.key}', () async {
      final requests = <http.Request>[];
      final client = MockClient((request) async {
        requests.add(request);
        return http.Response(
          caso.key == 'listar turmas' ? '[{"id":"t1"}]' : '{"ok":true}',
          200,
        );
      });
      final api = ApiService(client: client);
      addTearDown(api.close);
      final anterior = await caso.value(antes.ApiService(client: client));
      final atual = await caso.value(api);
      expect(atual, anterior);
      expect(requests, hasLength(2));
      expect(requests[1].method, requests[0].method);
      expect(requests[1].url, requests[0].url);
      expect(requests[1].bodyBytes, requests[0].bodyBytes);
      expect(requests[1].headers['accept'], 'application/json');
      expect(
        requests[1].headers['content-type'],
        startsWith('application/json'),
      );
    });
  }

  ApiService responder(String body, int status) {
    final api = ApiService(
      client: MockClient((_) async => http.Response(body, status)),
    );
    addTearDown(api.close);
    return api;
  }

  for (final key in ['erro', 'message', 'error']) {
    test('erro HTTP preserva mensagem em $key', () async {
      final api = responder(jsonEncode({key: 'Recusado'}), 422);
      await expectLater(
        api.criarTurma(nome: 'A'),
        throwsA(
          isA<ApiException>()
              .having((e) => e.statusCode, 'status', 422)
              .having((e) => e.message, 'mensagem', 'Recusado'),
        ),
      );
    });
  }
  test('listarTurmas não oculta erro HTTP como lista vazia', () async {
    await expectLater(
      responder('{"error":"Sem acesso"}', 403).listarTurmas(),
      throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 403)),
    );
  });
  test('resposta de erro não JSON mantém status HTTP', () async {
    await expectLater(
      responder('<html>falha</html>', 502).listarTurmas(),
      throwsA(
        isA<ApiException>().having(
          (e) => e.message,
          'mensagem',
          'Erro HTTP 502',
        ),
      ),
    );
  });
  test('JSON inválido em sucesso gera erro de protocolo', () async {
    await expectLater(
      responder('{', 200).login('a', 'b'),
      throwsA(isA<ApiException>()),
    );
  });
  test('objeto inesperado na listagem gera erro', () async {
    await expectLater(
      responder('{}', 200).listarTurmas(),
      throwsA(isA<ApiException>()),
    );
  });
  test(
    'lista inesperada em operação de objeto gera erro com status real',
    () async {
      await expectLater(
        responder('[]', 201).criarTurma(nome: 'A'),
        throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 201)),
      );
    },
  );
  test('201 retorna objeto criado', () async {
    expect(await responder('{"id":"t1"}', 201).criarTurma(nome: 'A'), {
      'id': 't1',
    });
  });
  test('204 sem conteúdo é sucesso na exclusão', () async {
    expect(await responder('', 204).excluirTurma(turmaId: 't1'), isEmpty);
  });
  test('falha de transporte não é convertida em sucesso', () async {
    final api = ApiService(
      client: MockClient((_) async => throw http.ClientException('offline')),
    );
    addTearDown(api.close);
    await expectLater(api.listarTurmas(), throwsA(isA<http.ClientException>()));
  });
  test('perfil sem sessão falha antes de enviar requisição', () async {
    UsuarioSession.limpar();
    var calls = 0;
    final api = ApiService(
      client: MockClient((_) async {
        calls++;
        return http.Response('{}', 200);
      }),
    );
    addTearDown(api.close);
    await expectLater(
      api.buscarPerfil(),
      throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 401)),
    );
    expect(calls, 0);
  });
  test('query com caracteres reservados não injeta parâmetros', () async {
    UsuarioSession.id = 'a&admin=true';
    final api = ApiService(
      client: MockClient((request) async {
        expect(request.url.queryParameters, {'professorId': 'a&admin=true'});
        return http.Response('[]', 200);
      }),
    );
    addTearDown(api.close);
    await api.listarTurmas();
  });
  test('listagem sem sessão não acrescenta professorId', () async {
    UsuarioSession.limpar();
    final api = ApiService(
      client: MockClient((request) async {
        expect(request.url.queryParameters, isEmpty);
        return http.Response('[]', 200);
      }),
    );
    addTearDown(api.close);
    await api.listarTurmas();
  });
  test(
    'decorator mantém headers explícitos, verbo, corpo e resposta',
    () async {
      final client = JsonHeadersClient(
        MockClient((request) async {
          expect(request.method, 'PUT');
          expect(request.body, 'texto');
          expect(request.headers['accept'], 'text/plain');
          expect(request.headers['content-type'], startsWith('text/plain'));
          expect(request.headers['authorization'], 'token-teste');
          return http.Response('resposta', 202);
        }),
      );
      addTearDown(client.close);
      final response = await client.put(
        Uri.parse('http://localhost/test'),
        headers: {'Accept': 'text/plain', 'Authorization': 'token-teste'},
        body: 'texto',
      );
      expect(response.statusCode, 202);
      expect(response.body, 'resposta');
    },
  );
  test('decorator não converte multipart em JSON', () async {
    final client = JsonHeadersClient(
      MockClient((request) async {
        expect(
          request.headers['content-type'],
          startsWith('multipart/form-data; boundary='),
        );
        expect(request.body, contains('foto.png'));
        return http.Response('{}', 201);
      }),
    );
    addTearDown(client.close);
    final request =
        http.MultipartRequest('POST', Uri.parse('http://localhost/upload'))
          ..files.add(
            http.MultipartFile.fromString(
              'foto',
              'bytes',
              filename: 'foto.png',
            ),
          );
    await client.send(request);
  });
  test('close da fachada fecha o cliente envolvido', () {
    final inner = _CloseClient();
    ApiService(client: inner).close();
    expect(inner.closed, isTrue);
  });
}
