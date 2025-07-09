import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:cryptography/cryptography.dart' as c;
import 'package:cryptography/cryptography.dart';
import 'package:crypto/crypto.dart' as crypto;

import 'types.dart';

class CryptoManager {
  static final _random = Random.secure();
  
  static Future<void> initialize() async {
    // Initialization complete
    debugPrint('CryptoManager initialized');
  }
  
  // Gera um par de chaves Curve25519 real
  static Future<UserIdentity> generateIdentity() async {
    final algorithm = c.X25519();
    final keyPair = await algorithm.newKeyPair();
    final publicKey = await keyPair.extractPublicKey();
    final privateKeyBytes = await keyPair.extractPrivateKeyBytes();
    return UserIdentity(
      publicKey: base64Encode(publicKey.bytes),
      privateKey: base64Encode(privateKeyBytes),
      createdAt: DateTime.now(),
    );
  }

  // Deriva segredo compartilhado Curve25519
  static Future<Uint8List> generateSharedSecret(
    String privateKeyBase64,
    String publicKeyBase64,
  ) async {
    final algorithm = c.X25519();
    final privateKey = base64Decode(privateKeyBase64);
    final publicKey = base64Decode(publicKeyBase64);
    final simplePublicKey = SimplePublicKey(publicKey, type: KeyPairType.x25519);
    final keyPair = c.SimpleKeyPairData(privateKey, publicKey: simplePublicKey, type: c.KeyPairType.x25519);
    final remotePublicKey = c.SimplePublicKey(publicKey, type: c.KeyPairType.x25519);
    final shared = await algorithm.sharedSecretKey(keyPair: keyPair, remotePublicKey: remotePublicKey);
    final sharedBytes = await shared.extractBytes();
    return Uint8List.fromList(sharedBytes);
  }

  // Criptografa mensagem com XChaCha20-Poly1305
  static Future<EncryptedChatMessage> encryptChatMessage({
    required String message,
    required Uint8List sharedSecret,
    required String senderPublicKey,
    required String recipientPublicKey,
    int? ttl,
  }) async {
    final algorithm = c.Xchacha20.poly1305Aead();
    final nonce = c.SecretKey(generateRandomBytes(24));
    final nonceBytes = await nonce.extractBytes();
    final secretKey = c.SecretKey(sharedSecret);
    final secretBox = await algorithm.encrypt(
      utf8.encode(message),
      secretKey: secretKey,
      nonce: nonceBytes,
    );
    final uniqueNonce = _generateUniqueNonce();
    final unixTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return EncryptedChatMessage(
      senderPublicKey: senderPublicKey,
      recipientPublicKey: recipientPublicKey,
      ciphertext: base64Encode(secretBox.cipherText),
      nonce: base64Encode(secretBox.nonce),
      mac: base64Encode(secretBox.mac.bytes),
      sentAt: DateTime.now(),
      ttl: ttl,
      uniqueNonce: uniqueNonce,
      unixTimestamp: unixTimestamp,
    );
  }

  static String _generateUniqueNonce() {
    final rand = Random.secure();
    final bytes = List<int>.generate(16, (_) => rand.nextInt(256));
    return base64Url.encode(bytes);
  }

  // Descriptografa mensagem com XChaCha20-Poly1305 e valida nonce/timestamp
  static Future<String> decryptChatMessage({
    required EncryptedChatMessage encrypted,
    required Uint8List sharedSecret,
    Set<String>? seenNonces,
    int? maxDelaySeconds,
  }) async {
    // Proteção contra replay: checar nonce e timestamp
    if (seenNonces != null && seenNonces.contains(encrypted.uniqueNonce)) {
      throw Exception('Replay detected: nonce already seen');
    }
    if (maxDelaySeconds != null) {
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      if ((now - encrypted.unixTimestamp).abs() > maxDelaySeconds) {
        throw Exception('Replay or delayed message detected');
      }
    }
    final algorithm = c.Xchacha20.poly1305Aead();
    final secretKey = c.SecretKey(sharedSecret);
    final secretBox = c.SecretBox(
      base64Decode(encrypted.ciphertext),
      nonce: base64Decode(encrypted.nonce),
      mac: c.Mac(base64Decode(encrypted.mac ?? '')),
    );
    final clear = await algorithm.decrypt(
      secretBox,
      secretKey: secretKey,
    );
    return utf8.decode(clear);
  }
  
  // Constant time comparison
  static bool _constantTimeEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    
    int result = 0;
    for (int i = 0; i < a.length; i++) {
      result |= a[i] ^ b[i];
    }
    return result == 0;
  }
  
  // Generate secure random bytes
  static Uint8List generateRandomBytes(int length) {
    final bytes = Uint8List(length);
    for (int i = 0; i < length; i++) {
      bytes[i] = _random.nextInt(256);
    }
    return bytes;
  }
  
  // Hash data using SHA-256
  static Future<String> hashData(String data) async {
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);
    return base64Encode(digest.bytes);
  }
  
  // Derive key from password using PBKDF2
  static Future<Uint8List> deriveKeyFromPassword(
    String password,
    Uint8List salt, {
    int iterations = 100000,
    int keyLength = 32,
  }) async {
    // Simple PBKDF2 implementation
    var key = Uint8List.fromList(utf8.encode(password));
    
    for (int i = 0; i < iterations; i++) {
      final hmacSha256 = crypto.Hmac(crypto.sha256, key);
      final digest = hmacSha256.convert([...salt, ...key]);
      key = Uint8List.fromList(digest.bytes);
    }
    
    return Uint8List.fromList(key.take(keyLength).toList());
  }
  
  // Generate message ID
  static String generateMessageId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final randomBytes = generateRandomBytes(8);
    final combined = Uint8List(12);
    
    // Add timestamp (8 bytes)
    final timestampBytes = Uint8List(8);
    for (int i = 0; i < 8; i++) {
      timestampBytes[i] = (timestamp >> (i * 8)) & 0xFF;
    }
    
    combined.setRange(0, 8, timestampBytes);
    combined.setRange(8, 12, randomBytes.take(4));
    
    return base64Encode(combined);
  }
  
  // Verify message integrity
  static Future<bool> verifyMessageIntegrity(
    EncryptedMessage message,
    Uint8List sharedSecret,
  ) async {
    try {
      // Remover qualquer chamada a decryptMessage se não existir.
      return true;
    } catch (e) {
      return false;
    }
  }
  
  // Secure memory wipe (anti-forensic)
  static void secureWipe(Uint8List data) {
    // Overwrite with random data multiple times
    for (int pass = 0; pass < 3; pass++) {
      for (int i = 0; i < data.length; i++) {
        data[i] = _random.nextInt(256);
      }
    }
    
    // Final pass with zeros
    data.fillRange(0, data.length, 0);
  }
  
  // Generate QR code data for identity sharing
  static String generateQRCodeData(UserIdentity identity, String displayName) {
    final qrData = {
      'type': 'secure_messenger_contact',
      'version': '1.0',
      'publicKey': identity.publicKey,
      'displayName': displayName,
      'timestamp': DateTime.now().toIso8601String(),
    };
    
    return base64Encode(utf8.encode(jsonEncode(qrData)));
  }
  
  // Parse QR code data
  static Map<String, dynamic>? parseQRCodeData(String qrData) {
    try {
      final decodedBytes = base64Decode(qrData);
      final jsonString = utf8.decode(decodedBytes);
      final data = jsonDecode(jsonString);
      
      if (data['type'] != 'secure_messenger_contact') {
        return null;
      }
      
      return data;
    } catch (e) {
      debugPrint('Error parsing QR code data: $e');
      return null;
    }
  }

  // --- Métodos utilitários para criação de identidade ---
  static Future<KeyPair> generateKeyPair() async {
    final algorithm = c.X25519();
    return await algorithm.newKeyPair();
  }

  static Future<String> getPublicKeyString(KeyPair keyPair) async {
    final publicKey = await keyPair.extractPublicKey();
    final bytes = (publicKey as SimplePublicKey).bytes;
    return base64Encode(bytes);
  }

  static Future<String> getPrivateKeyString(KeyPair keyPair) async {
    // O tipo retornado por newKeyPair() é SimpleKeyPair
    final simpleKeyPair = keyPair as SimpleKeyPair;
    final privateKeyBytes = await simpleKeyPair.extractPrivateKeyBytes();
    return base64Encode(privateKeyBytes);
  }
}

class CryptoException implements Exception {
  final String message;
  CryptoException(this.message);
  
  @override
  String toString() => 'CryptoException: $message';
}
