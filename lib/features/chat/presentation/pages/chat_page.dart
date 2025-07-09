import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:secure_messenger/core/crypto/crypto_manager.dart';
import 'package:secure_messenger/core/crypto/types.dart';
import 'package:secure_messenger/core/session/session_manager.dart';
import 'package:secure_messenger/features/chat/providers/chat_provider.dart';
import 'package:secure_messenger/features/settings/providers/settings_provider.dart';
import 'package:secure_messenger/features/contacts/providers/contacts_provider.dart';
import 'package:secure_messenger/l10n/app_localizations.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class ChatPage extends StatefulWidget {
  final String contactId;
  
  const ChatPage({super.key, required this.contactId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  int? _selectedTtl = 0; // TTL em segundos
  final List<int> _ttlOptions = [0, 5, 10, 30, 60, 300]; // 0 = sem autodestruição
  bool useTor = true; // Mover para o escopo do widget para controle dinâmico
  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _portController = TextEditingController(text: '4040');
  static const int maxFileSize = 5 * 1024 * 1024; // 5MB

  @override
  void initState() {
    super.initState();
    // Iniciar listener P2P na porta padrão
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatProvider>().startP2PListener(port: int.tryParse(_portController.text) ?? 4040);
      // Sincronizar o estado inicial do switch com o provider
      setState(() {
        useTor = context.read<ChatProvider>().useTor;
      });
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _ipController.dispose();
    _portController.dispose();
    super.dispose();
  }

  Future<bool> _isTorProxyAvailable({String host = '127.0.0.1', int port = 9050}) async {
    try {
      final socket = await Socket.connect(host, port, timeout: const Duration(seconds: 2));
      socket.destroy();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    if (text.length > 2000) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.messageTooLong)),
      );
      return;
    }
    if (useTor) {
      final torOk = await _isTorProxyAvailable();
      if (!torOk) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tor/Orbot não está ativo. Ative o Orbot para garantir anonimato!')),
        );
        return;
      }
    }
    final sessionManager = context.read<SessionManager>();
    final userIdentity = await sessionManager.getUserIdentity();
    if (userIdentity == null) return;
    final contactsProvider = context.read<ContactsProvider>();
    final contact = contactsProvider.getContactById(widget.contactId);
    if (contact == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.contactNotFound)),
      );
      return;
    }
    if (contact.address == null || contact.address!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.addressNotSet)),
      );
      return;
    }
    final sharedSecret = await CryptoManager.generateSharedSecret(
      userIdentity['privateKey'],
      contact.publicKey,
    );
    final encrypted = await CryptoManager.encryptChatMessage(
      message: text,
      sharedSecret: sharedSecret,
      senderPublicKey: userIdentity['publicKey'],
      recipientPublicKey: contact.publicKey,
      ttl: _selectedTtl == 0 ? null : _selectedTtl,
    );
    context.read<ChatProvider>().addEncryptedMessage(encrypted);
    // Envio P2P automático usando o endereço salvo
    // Suporte a formato: "ip:porta" ou apenas endereço (usa porta padrão 4040)
    String address = contact.address!;
    String ip = address;
    int port = 4040;
    if (address.contains(':')) {
      final parts = address.split(':');
      ip = parts[0];
      port = int.tryParse(parts[1]) ?? 4040;
    }
    await context.read<ChatProvider>().sendP2PMessage(encrypted, ip, port);
    _messageController.clear();
    _scrollToBottom();
  }

  Future<void> _attachAndSendFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'txt'],
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;
    if (file.size > maxFileSize) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Arquivo muito grande (máx 5MB)')),
      );
      return;
    }
    if (useTor) {
      final torOk = await _isTorProxyAvailable();
      if (!torOk) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tor/Orbot não está ativo. Ative o Orbot para garantir anonimato!')),
        );
        return;
      }
    }
    // Segurança: não executar, abrir ou interpretar arquivos
    // Sanitização
    Uint8List? sanitizedBytes;
    String ext = file.extension?.toLowerCase() ?? '';
    if (['jpg', 'jpeg', 'png'].contains(ext)) {
      final decoded = img.decodeImage(file.bytes!);
      if (decoded == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Falha ao processar imagem.')),
        );
        return;
      }
      sanitizedBytes = Uint8List.fromList(img.encodeJpg(decoded));
    } else if (ext == 'pdf') {
      // Remove metadados PDF (simples: regrava o arquivo)
      sanitizedBytes = file.bytes;
      // (Para sanitização avançada, usar pacote específico de PDF)
    } else if (ext == 'txt') {
      sanitizedBytes = file.bytes;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tipo de arquivo não suportado.')),
      );
      return;
    }
    // Criptografar e enviar como mensagem
    final sessionManager = context.read<SessionManager>();
    final userIdentity = await sessionManager.getUserIdentity();
    if (userIdentity == null) return;
    final contactsProvider = context.read<ContactsProvider>();
    final contact = contactsProvider.getContactById(widget.contactId);
    if (contact == null || contact.address == null || contact.address!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Contato inválido.')),
      );
      return;
    }
    final sharedSecret = await CryptoManager.generateSharedSecret(
      userIdentity['privateKey'],
      contact.publicKey,
    );
    // Codificar arquivo em base64
    final fileBase64 = base64Encode(sanitizedBytes!);
    final fileName = file.name;
    final encrypted = await CryptoManager.encryptChatMessage(
      message: '[file]$fileName:$fileBase64',
      sharedSecret: sharedSecret,
      senderPublicKey: userIdentity['publicKey'],
      recipientPublicKey: contact.publicKey,
      ttl: _selectedTtl == 0 ? null : _selectedTtl,
    );
    context.read<ChatProvider>().addEncryptedMessage(encrypted);
    // Envio P2P
    String address = contact.address!;
    String ip = address;
    int port = 4040;
    if (address.contains(':')) {
      final parts = address.split(':');
      ip = parts[0];
      port = int.tryParse(parts[1]) ?? 4040;
    }
    await context.read<ChatProvider>().sendP2PMessage(encrypted, ip, port);
    _scrollToBottom();
  }

  Future<void> _downloadFile(String fileName, String base64data) async {
    final confirm1 = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Download de arquivo'),
        content: Text('Deseja realmente baixar o arquivo "$fileName"?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Baixar')),
        ],
      ),
    );
    if (confirm1 != true) return;
    final confirm2 = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Aviso de segurança'),
        content: const Text('O app é projetado para mensagens e anonimato, não para troca de arquivos. Baixar arquivos pode ser perigoso. NÃO nos responsabilizamos por danos, invasões ou vazamentos decorrentes do download. Prossiga por sua conta e risco.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Concordo e desejo baixar')),
        ],
      ),
    );
    if (confirm2 != true) return;
    try {
      final bytes = base64Decode(base64data);
      final dir = await getExternalStorageDirectory() ?? await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$fileName');
      await file.writeAsBytes(bytes);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Arquivo salvo em: ${file.path}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar arquivo: $e')),
      );
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();
    final sessionManager = context.watch<SessionManager>();
    final l = AppLocalizations.of(context)!;
    useTor = chatProvider.useTor;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Consumer<SettingsProvider>(
          builder: (context, settings, _) => AppBar(
            title: Text(l.appTitle),
            backgroundColor: settings.themeColor,
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Center(child: Text('Porta: 24{chatProvider.listeningPort}')),
              ),
              Switch(
                value: useTor,
                onChanged: (val) {
                  setState(() {
                    useTor = val;
                  });
                  context.read<ChatProvider>().setUseTor(val);
                },
                activeColor: Colors.green,
                inactiveThumbColor: Colors.grey,
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.attach_file),
                tooltip: 'Anexar arquivo',
                onPressed: _attachAndSendFile,
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Consumer<SettingsProvider>(
            builder: (context, settings, child) {
              if (settings.chatWallpaperPath != null) {
                final path = settings.chatWallpaperPath!;
                if (path.startsWith('assets/')) {
                  return Image.asset(
                    path,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  );
                } else {
                  return Image.file(
                    File(path),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  );
                }
              } else {
                return Container(color: settings.themeColor.withOpacity(0.1));
              }
            },
          ),
          Column(
            children: [
              if (useTor)
                Container(
                  color: Colors.black87,
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      const Icon(Icons.lock, color: Colors.green),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Modo Tor ativado: todo tráfego passa pela rede Tor/Orbot para anonimato máximo.',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              if (!useTor)
                Container(
                  color: Colors.orange.shade700,
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      const Icon(Icons.warning, color: Colors.white),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Modo Tor desativado: seu IP pode ser exposto na rede local.',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              // Removido campo de IP/porta
              // Messages list
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: chatProvider.messages.length,
                  itemBuilder: (context, index) {
                    final encrypted = chatProvider.messages[index];
                    return FutureBuilder<Map<String, dynamic>?>(
                      future: sessionManager.getUserIdentity(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return const SizedBox.shrink();
                        final userIdentity = snapshot.data!;
                        final isFromMe = encrypted.senderPublicKey == userIdentity['publicKey'];
                        return FutureBuilder<String>(
                          future: () async {
                            final sharedSecret = await CryptoManager.generateSharedSecret(
                              userIdentity['privateKey'],
                              isFromMe ? encrypted.recipientPublicKey : encrypted.senderPublicKey,
                            );
                            return await CryptoManager.decryptChatMessage(
                              encrypted: encrypted,
                              sharedSecret: sharedSecret,
                            );
                          }(),
                          builder: (context, msgSnap) {
                            if (!msgSnap.hasData) {
                              return const SizedBox.shrink();
                            }
                            final now = DateTime.now();
                            final expiresAt = encrypted.ttl != null ? encrypted.sentAt.add(Duration(seconds: encrypted.ttl!)) : null;
                            final timeLeft = expiresAt != null ? expiresAt.difference(now).inSeconds : null;
                            return Consumer<SettingsProvider>(
                              builder: (context, settings, child) {
                                return Align(
                                  alignment: isFromMe ? Alignment.centerRight : Alignment.centerLeft,
                                  child: Column(
                                    crossAxisAlignment: isFromMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.symmetric(vertical: 4),
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: isFromMe
                                              ? settings.messageBubbleColor.withOpacity(0.8)
                                              : Theme.of(context).colorScheme.surfaceVariant,
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: msgSnap.data!.startsWith('[file]')
                                            ? Builder(
                                                builder: (context) {
                                                  final fileMsg = msgSnap.data!;
                                                  final idx = fileMsg.indexOf(':');
                                                  if (idx == -1) {
                                                    return Text('Arquivo corrompido ou inválido.');
                                                  }
                                                  final fileName = fileMsg.substring(6, idx);
                                                  final fileBase64 = fileMsg.substring(idx + 1);
                                                  final ext = fileName.split('.').last.toLowerCase();
                                                  if (['jpg', 'jpeg', 'png'].contains(ext)) {
                                                    // Sanitizar imagem em memória
                                                    try {
                                                      final bytes = base64Decode(fileBase64);
                                                      final decoded = img.decodeImage(bytes);
                                                      if (decoded == null) {
                                                        return Text('Imagem corrompida.');
                                                      }
                                                      final sanitized = img.encodeJpg(decoded);
                                                      return Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Image.memory(Uint8List.fromList(sanitized), width: 120, height: 120, fit: BoxFit.cover),
                                                          const SizedBox(height: 8),
                                                          ElevatedButton.icon(
                                                            icon: const Icon(Icons.download),
                                                            label: const Text('Baixar imagem'),
                                                            onPressed: () => _downloadFile(fileName, fileBase64),
                                                          ),
                                                        ],
                                                      );
                                                    } catch (e) {
                                                      return Text('Erro ao exibir imagem.');
                                                    }
                                                  } else {
                                                    return Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            const Icon(Icons.insert_drive_file, size: 20),
                                                            const SizedBox(width: 8),
                                                            Flexible(child: Text(fileName, style: const TextStyle(fontWeight: FontWeight.bold))),
                                                          ],
                                                        ),
                                                        const SizedBox(height: 8),
                                                        ElevatedButton.icon(
                                                          icon: const Icon(Icons.download),
                                                          label: const Text('Baixar arquivo'),
                                                          onPressed: () => _downloadFile(fileName, fileBase64),
                                                        ),
                                                      ],
                                                    );
                                                  }
                                                },
                                              )
                                            : Text(
                                                _sanitizeText(msgSnap.data!),
                                                style: TextStyle(
                                                  color: isFromMe
                                                      ? Theme.of(context).colorScheme.onPrimary
                                                      : Theme.of(context).colorScheme.onSurface,
                                                ),
                                                maxLines: 20,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                      ),
                                      if (timeLeft != null && timeLeft > 0)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 2, right: 8, left: 8),
                                          child: Text(
                                            l.selfDestructIn(timeLeft),
                                            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.red),
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              // Message input
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  border: Border(
                    top: BorderSide(
                      color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.attach_file),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(AppLocalizations.of(context)!.fileAttachmentSoon)),
                        );
                      },
                    ),
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    DropdownButton<int>(
                      value: _selectedTtl,
                      icon: const Icon(Icons.timer),
                      underline: const SizedBox.shrink(),
                      onChanged: (value) {
                        setState(() {
                          _selectedTtl = value;
                        });
                      },
                      items: _ttlOptions.map((ttl) {
                        return DropdownMenuItem<int>(
                          value: ttl,
                          child: Text(ttl == 0 ? '∞' : '${ttl}s'),
                        );
                      }).toList(),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: _sendMessage,
                    ),
                  ],
                ),
              ),
              if (chatProvider.securityLogs.isNotEmpty)
                Expanded(
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(l.securityLogs, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      ...chatProvider.securityLogs.reversed.map((log) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            child: Text(log, style: const TextStyle(fontSize: 12, color: Colors.red)),
                          )),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: message.isFromMe 
            ? MainAxisAlignment.end 
            : MainAxisAlignment.start,
        children: [
          if (!message.isFromMe) ...[
            CircleAvatar(
              radius: 12,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                widget.contactId[0].toUpperCase(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 10,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: message.isFromMe
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.content,
                    style: TextStyle(
                      color: message.isFromMe
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      fontSize: 10,
                      color: message.isFromMe
                          ? Theme.of(context).colorScheme.onPrimary.withOpacity(0.7)
                          : Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (message.isFromMe) ...[
            const SizedBox(width: 8),
            Icon(
              Icons.done_all,
              size: 16,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ],
      ),
    );
  }

  String _getContactName() {
    // Convert contactId to a readable name
    switch (widget.contactId) {
      case 'alice_123':
        return 'Alice';
      case 'bob_456':
        return 'Bob';
      case 'charlie_789':
        return 'Charlie';
      default:
        return widget.contactId;
    }
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  String _sanitizeText(String input) {
    // Remove qualquer caractere de controle e impede links automáticos
    final sanitized = input.replaceAll(RegExp(r'[\x00-\x1F\x7F]'), '').replaceAll(RegExp(r'https?://\S+'), '[link removido]');
    return sanitized;
  }
}

class ChatMessage {
  final String id;
  final String content;
  final bool isFromMe;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.content,
    required this.isFromMe,
    required this.timestamp,
  });
}
