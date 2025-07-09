import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:typed_data';

import '../crypto/crypto_manager.dart';
import '../storage/secure_storage.dart';
import '../config/app_config.dart';
import 'package:cryptography/cryptography.dart';
import 'package:argon2/argon2.dart';

class SessionManager extends ChangeNotifier {
  static const String _pinHashKey = 'pin_hash';
  bool _isAuthenticated = false;
  bool _hasCompletedSetup = false;

  bool get isAuthenticated => _isAuthenticated;
  bool get hasCompletedSetup => _hasCompletedSetup;

  /// Cria e armazena o hash Argon2id do PIN
  Future<void> setPin(String pin) async {
    final argon2 = Argon2BytesGenerator()
      ..init(Argon2Parameters(
        Argon2Parameters.ARGON2_id,
        Uint8List.fromList([]), // salt vazio, ideal: gerar salt aleatório e salvar junto
        version: Argon2Parameters.ARGON2_VERSION_13,
        iterations: 3,
        memory: 65536, // 64 MB
        lanes: 4,
      ));
    final pinBytes = Uint8List.fromList(pin.codeUnits);
    final hash = Uint8List(32);
    argon2.generateBytes(pinBytes, hash, 0, hash.length);
    final hashBase64 = base64Encode(hash);
    await SecureStorage.write(_pinHashKey, hashBase64);
  }

  /// Remove o hash do PIN
  Future<void> removePin() async {
    await SecureStorage.secureDelete(_pinHashKey);
  }

  /// Valida o PIN comparando o hash Argon2id
  Future<bool> authenticateWithPin(String pin) async {
    final hashBase64 = await SecureStorage.read(_pinHashKey);
    if (hashBase64 == null) {
      debugPrint('[PIN] Nenhum hash salvo.');
      return false;
    }
    final argon2 = Argon2BytesGenerator()
      ..init(Argon2Parameters(
        Argon2Parameters.ARGON2_id,
        Uint8List.fromList([]),
        version: Argon2Parameters.ARGON2_VERSION_13,
        iterations: 3,
        memory: 65536, // 64 MB
        lanes: 4,
      ));
    final pinBytes = Uint8List.fromList(pin.codeUnits);
    final hash = Uint8List(32);
    argon2.generateBytes(pinBytes, hash, 0, hash.length);
    final inputHashBase64 = base64Encode(hash);
    final ok = inputHashBase64 == hashBase64;
    debugPrint('[PIN] PIN informado: $pin, Hash calculado: $inputHashBase64, Hash salvo: $hashBase64, Resultado: $ok');
    _isAuthenticated = ok;
    notifyListeners();
    return ok;
  }

  Future<void> resetApp() async {
    _isAuthenticated = false;
    _hasCompletedSetup = false;
    await removePin();
    notifyListeners();
  }

  Future<void> markSetupCompletedPersisted() async {
    _hasCompletedSetup = true;
    notifyListeners();
  }

  /// Cria o hash do PIN ao finalizar o setup
  Future<bool> completeSetup({required String pin, required String displayName}) async {
    await setPin(pin);
    _hasCompletedSetup = true;
    notifyListeners();
    return true;
  }

  Future<Map<String, dynamic>?> getUserIdentity() async {
    final publicKey = await SecureStorage.read('public_key');
    final privateKey = await SecureStorage.read('private_key');
    if (publicKey != null && privateKey != null) {
      return {'publicKey': publicKey, 'privateKey': privateKey};
    }
    return null;
  }
}


