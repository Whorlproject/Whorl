import 'package:http/http.dart' as http;

class Tor {
  final String proxyHost;
  final int proxyPort;

  Tor({this.proxyHost = '127.0.0.1', this.proxyPort = 9050});

  /// Retorna um http.Client normal. Proxy HTTP via Tor não disponível nesta versão do pacote.
  Future<http.Client> getClient() async {
    return http.Client();
  }
} 