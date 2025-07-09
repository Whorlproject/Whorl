import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/session/session_manager.dart'; // <-- Import corrigido aqui
import 'package:secure_messenger/core/crypto/crypto_manager.dart';
import 'package:secure_messenger/core/storage/secure_storage.dart';
import 'package:flutter/services.dart';
import 'package:secure_messenger/l10n/app_localizations.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({super.key});

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  String? _publicKey;
  String? _privateKey;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _generateIdentity();
  }

  Future<void> _generateIdentity() async {
    setState(() => _isLoading = true);
    final keyPair = await CryptoManager.generateKeyPair();
    final publicKey = await CryptoManager.getPublicKeyString(keyPair);
    final privateKey = await CryptoManager.getPrivateKeyString(keyPair);
    setState(() {
      _publicKey = publicKey;
      _privateKey = privateKey;
      _isLoading = false;
    });
    // Salvar no storage seguro (sempre sobrescreve)
    await SecureStorage.write('public_key', publicKey);
    await SecureStorage.write('private_key', privateKey);
    await SecureStorage.write('account_exists', 'true');
  }

  void _goToChats() {
    Navigator.of(context).pushReplacementNamed('/chats');
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l?.createIdentityTitle ?? ''),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: _goToChats,
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: _isLoading
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.verified_user, size: 64, color: Colors.blue),
                    const SizedBox(height: 24),
                    Text(
                      l?.identityCreatedSuccessfully ?? '',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _goToChats,
                      child: Text(l?.getStarted ?? ''),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class SetupStep {
  final String title;
  final String description;
  final IconData icon;

  SetupStep({
    required this.title,
    required this.description,
    required this.icon,
  });
}
