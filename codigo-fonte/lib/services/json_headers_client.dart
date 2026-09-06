import 'package:http/http.dart' as http;

/// Decorator: acrescenta headers sem alterar o contrato de http.Client.
class JsonHeadersClient extends http.BaseClient {
  JsonHeadersClient(this._inner);
  final http.Client _inner;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.putIfAbsent('Accept', () => 'application/json');
    // Multipart deve controlar seu próprio Content-Type e boundary.
    if (request is http.Request) {
      request.headers.putIfAbsent('Content-Type', () => 'application/json');
    }
    return _inner.send(request);
  }

  @override
  void close() => _inner.close();
}
