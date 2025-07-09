import 'dart:convert';

class UserIdentity {
  final String publicKey;
  final String privateKey;
  final DateTime createdAt;
  
  UserIdentity({
    required this.publicKey,
    required this.privateKey,
    required this.createdAt,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'publicKey': publicKey,
      'privateKey': privateKey,
      'createdAt': createdAt.toIso8601String(),
    };
  }
  
  factory UserIdentity.fromJson(Map<String, dynamic> json) {
    return UserIdentity(
      publicKey: json['publicKey'],
      privateKey: json['privateKey'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class EncryptedMessage {
  final String ciphertext;
  final String nonce;
  final String mac;
  final DateTime timestamp;
  
  EncryptedMessage({
    required this.ciphertext,
    required this.nonce,
    required this.mac,
    required this.timestamp,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'ciphertext': ciphertext,
      'nonce': nonce,
      'mac': mac,
      'timestamp': timestamp.toIso8601String(),
    };
  }
  
  factory EncryptedMessage.fromJson(Map<String, dynamic> json) {
    return EncryptedMessage(
      ciphertext: json['ciphertext'],
      nonce: json['nonce'],
      mac: json['mac'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

class Contact {
  final String id;
  final String publicKey;
  final String displayName;
  final String? avatar;
  final DateTime addedAt;
  final bool isVerified;
  final String? address; // Novo campo: IP ou .onion

  Contact({
    required this.id,
    required this.publicKey,
    required this.displayName,
    this.avatar,
    required this.addedAt,
    this.isVerified = false,
    this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'publicKey': publicKey,
      'displayName': displayName,
      'avatar': avatar,
      'addedAt': addedAt.toIso8601String(),
      'isVerified': isVerified,
      'address': address,
    };
  }

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'],
      publicKey: json['publicKey'],
      displayName: json['displayName'],
      avatar: json['avatar'],
      addedAt: DateTime.parse(json['addedAt']),
      isVerified: json['isVerified'] ?? false,
      address: json['address'],
    );
  }
}

class Message {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final MessageType type;
  final DateTime timestamp;
  final MessageStatus status;
  final int? ttl; // Time to live in seconds
  final bool isEncrypted;
  
  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.type,
    required this.timestamp,
    required this.status,
    this.ttl,
    this.isEncrypted = true,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'type': type.toString(),
      'timestamp': timestamp.toIso8601String(),
      'status': status.toString(),
      'ttl': ttl,
      'isEncrypted': isEncrypted,
    };
  }
  
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      content: json['content'],
      type: MessageType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => MessageType.text,
      ),
      timestamp: DateTime.parse(json['timestamp']),
      status: MessageStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
        orElse: () => MessageStatus.sent,
      ),
      ttl: json['ttl'],
      isEncrypted: json['isEncrypted'] ?? true,
    );
  }
}

enum MessageType {
  text,
  image,
  file,
  voice,
  system,
}

enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
  failed,
  expired,
}

class Group {
  final String id;
  final String name;
  final String? description;
  final String? avatar;
  final String adminId;
  final List<String> memberIds;
  final DateTime createdAt;
  final String groupKey; // Encrypted group key
  
  Group({
    required this.id,
    required this.name,
    this.description,
    this.avatar,
    required this.adminId,
    required this.memberIds,
    required this.createdAt,
    required this.groupKey,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'avatar': avatar,
      'adminId': adminId,
      'memberIds': memberIds,
      'createdAt': createdAt.toIso8601String(),
      'groupKey': groupKey,
    };
  }
  
  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      avatar: json['avatar'],
      adminId: json['adminId'],
      memberIds: List<String>.from(json['memberIds']),
      createdAt: DateTime.parse(json['createdAt']),
      groupKey: json['groupKey'],
    );
  }
}

class ChatSession {
  final String id;
  final String contactId;
  final DateTime lastActivity;
  final int unreadCount;
  final Message? lastMessage;
  
  ChatSession({
    required this.id,
    required this.contactId,
    required this.lastActivity,
    this.unreadCount = 0,
    this.lastMessage,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'contactId': contactId,
      'lastActivity': lastActivity.toIso8601String(),
      'unreadCount': unreadCount,
      'lastMessage': lastMessage?.toJson(),
    };
  }
  
  factory ChatSession.fromJson(Map<String, dynamic> json) {
    return ChatSession(
      id: json['id'],
      contactId: json['contactId'],
      lastActivity: DateTime.parse(json['lastActivity']),
      unreadCount: json['unreadCount'] ?? 0,
      lastMessage: json['lastMessage'] != null
          ? Message.fromJson(json['lastMessage'])
          : null,
    );
  }
}

class EncryptedChatMessage {
  final String senderPublicKey;
  final String recipientPublicKey;
  final String ciphertext; // base64
  final String nonce; // base64
  final String? mac; // base64 opcional
  final DateTime sentAt;
  final int? ttl; // tempo de vida em segundos
  final String uniqueNonce; // proteção contra replay
  final int unixTimestamp; // proteção contra replay

  EncryptedChatMessage({
    required this.senderPublicKey,
    required this.recipientPublicKey,
    required this.ciphertext,
    required this.nonce,
    this.mac,
    required this.sentAt,
    this.ttl,
    required this.uniqueNonce,
    required this.unixTimestamp,
  });

  Map<String, dynamic> toJson() => {
    'senderPublicKey': senderPublicKey,
    'recipientPublicKey': recipientPublicKey,
    'ciphertext': ciphertext,
    'nonce': nonce,
    'mac': mac,
    'sentAt': sentAt.toIso8601String(),
    'ttl': ttl,
    'uniqueNonce': uniqueNonce,
    'unixTimestamp': unixTimestamp,
  };

  factory EncryptedChatMessage.fromJson(Map<String, dynamic> json) => EncryptedChatMessage(
    senderPublicKey: json['senderPublicKey'],
    recipientPublicKey: json['recipientPublicKey'],
    ciphertext: json['ciphertext'],
    nonce: json['nonce'],
    mac: json['mac'],
    sentAt: DateTime.parse(json['sentAt']),
    ttl: json['ttl'],
    uniqueNonce: json['uniqueNonce'],
    unixTimestamp: json['unixTimestamp'],
  );
}
