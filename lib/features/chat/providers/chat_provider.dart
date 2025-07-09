import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:socks5_proxy/socks_client.dart';

import '../../../core/config/app_config.dart';
import 'package:secure_messenger/core/crypto/types.dart';

class ChatProvider extends ChangeNotifier {
  bool _useTor = true;
  final List<EncryptedChatMessage> _messages = [];
  final Map<String, Timer> _timers = {};
  final Set<String> _seenNonces = {};
  final List<String> _securityLogs = [];

  Timer? _pollingTimer;
  ServerSocket? _serverSocket;
  int _listeningPort = 4040;
  int _activeConnections = 0;

  static const int maxMessageLength = 2000;
  static const int maxConnections = 5;

  List<EncryptedChatMessage> get messages => _messages;
  int get listeningPort => _listeningPort;
  List<String> get securityLogs => _securityLogs;
  bool get useTor => _useTor;
  void setUseTor(bool value) {
    _useTor = value;
    notifyListeners();
  }

  // Getters para Tor Proxy
  String get torProxyHost => '127.0.0.1';
  int get torProxyPort => 9050;

  void addEncryptedMessage(EncryptedChatMessage message) {
    if (_seenNonces.contains(message.uniqueNonce)) {
      _securityLogs.add('Mensagem rejeitada: replay detectado (nonce duplicado)');
      return;
    }
    _seenNonces.add(message.uniqueNonce);
    _messages.add(message);
    notifyListeners();

    if (message.ttl != null && message.ttl! > 0) {
      final id = _getMessageId(message);
      _timers[id]?.cancel();
      _timers[id] = Timer(Duration(seconds: message.ttl!), () {
        removeMessage(message);
      });
    }
  }

  void removeMessage(EncryptedChatMessage message) {
    _messages.remove(message);
    final id = _getMessageId(message);
    _timers[id]?.cancel();
    _timers.remove(id);
    notifyListeners();
  }

  void clearMessages() {
    for (final timer in _timers.values) {
      timer.cancel();
    }
    _timers.clear();
    _messages.clear();
    notifyListeners();
  }

  Future<http.Client> _getHttpClient() async {
    if (_useTor) {
      final client = HttpClient();
      final proxy = ProxySettings(
        InternetAddress(torProxyHost),
        torProxyPort,
      );
      SocksTCPClient.assignToHttpClient(client, [proxy]);
      return IOClient(client);
    } else {
      return http.Client();
    }
  }


  Future<void> sendMessageToBackend(EncryptedChatMessage message) async {
    final url = Uri.parse('${AppConfig.backendBaseUrl}/api/messages');
    final body = jsonEncode(message.toJson());
    final client = await _getHttpClient();

    await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    client.close();
  }

  Future<void> fetchMessagesFromBackend(String recipientPublicKey) async {
    final url = Uri.parse('${AppConfig.backendBaseUrl}/api/messages?recipientPublicKey=$recipientPublicKey');
    final client = await _getHttpClient();
    final response = await client.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      for (final msgJson in data) {
        final msg = EncryptedChatMessage.fromJson(Map<String, dynamic>.from(msgJson));
        addEncryptedMessage(msg);
      }
    }
    client.close();
  }

  void startPolling(String recipientPublicKey) {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      fetchMessagesFromBackend(recipientPublicKey);
    });
  }

  void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  Future<void> startP2PListener({int port = 4040}) async {
    _listeningPort = port;
    _serverSocket?.close();
    _serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, port);
    _serverSocket!.listen((Socket client) async {
      if (_activeConnections >= maxConnections) {
        _securityLogs.add('Conexão recusada: excesso de conexões simultâneas.');
        client.destroy();
        return;
      }

      _activeConnections++;
      client.listen((data) async {
        try {
          final jsonStr = String.fromCharCodes(data);
          if (jsonStr.length > maxMessageLength * 2) {
            _securityLogs.add('Mensagem recebida muito longa, possível ataque.');
            client.destroy();
            _activeConnections--;
            return;
          }
          final msgJson = jsonDecode(jsonStr);
          if (!(msgJson is Map && msgJson.containsKey('ciphertext') && msgJson.containsKey('senderPublicKey'))) {
            _securityLogs.add('Mensagem malformada recebida, ignorada.');
            client.destroy();
            _activeConnections--;
            return;
          }
          final msg = EncryptedChatMessage.fromJson(Map<String, dynamic>.from(msgJson));
          if (msg.ciphertext.length > maxMessageLength * 2) {
            _securityLogs.add('Ciphertext muito longo, possível ataque.');
            client.destroy();
            _activeConnections--;
            return;
          }
          addEncryptedMessage(msg);
        } catch (e) {
          _securityLogs.add('Erro ao processar mensagem recebida: $e');
        } finally {
          client.destroy();
          _activeConnections--;
        }
      });
    });
  }

  Future<void> sendP2PMessage(EncryptedChatMessage message, String ip, int port) async {
    final jsonStr = jsonEncode(message.toJson());
    Socket socket;
    if (_useTor) {
      final proxies = [ProxySettings(InternetAddress(torProxyHost), torProxyPort)];
      socket = await SocksTCPClient.connect(
        proxies,
        InternetAddress(ip),
        port,
      );
    } else {
      socket = await Socket.connect(ip, port, timeout: const Duration(seconds: 5));
    }
    socket.add(utf8.encode(jsonStr));
    await socket.flush();
    await socket.close();
  }

  String _getMessageId(EncryptedChatMessage msg) {
    return '${msg.senderPublicKey}_${msg.recipientPublicKey}_${msg.sentAt.millisecondsSinceEpoch}_${msg.ciphertext.substring(0, 8)}';
  }
}
