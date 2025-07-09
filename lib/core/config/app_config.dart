// Security levels enum (moved outside class)
enum SecurityLevel {
  standard,
  high,
  paranoid,
}

class AppConfig {
  // App Information
  static const String appName = 'Whorl';
  static const String version = '1.0.0';
  static const String buildNumber = '1';
  
  // Security Configuration
  static const bool enableTor = true;
  static const bool enableScreenshotProtection = true;
  static const bool enableBiometricAuth = true;
  static const bool enableAntiForensics = true;
  
  // Message Configuration
  static const int defaultMessageTTL = 86400; // 24 hours in seconds
  static const int maxMessageLength = 4096; // 4KB
  static const int maxGroupMembers = 256;
  static const int maxFileSize = 10485760; // 10MB
  
  // Crypto Configuration
  static const int keyRotationInterval = 604800; // 7 days in seconds
  static const int sessionTimeout = 3600; // 1 hour in seconds
  static const int maxFailedAttempts = 5;
  
  // Network Configuration
  static const String defaultBackendUrl = 'https://secure-messenger.onion';
  static const String fallbackBackendUrl = 'https://api.secure-messenger.com';
  static const int connectionTimeout = 30000; // 30 seconds
  static const int requestTimeout = 15000; // 15 seconds
  
  // UI Configuration
  static const double defaultTextScale = 1.0;
  static const double minTextScale = 0.8;
  static const double maxTextScale = 1.4;
  
  // Storage Configuration
  static const String secureStorageKey = 'secure_messenger_storage';
  static const String hiveBoxName = 'secure_messenger_box';
  
  // Development flags
  static const bool isDebugMode = false;
  static const bool enableLogging = false;
  static const bool enableAnalytics = false;
  
  // Feature flags
  static const bool enableGroupMessaging = true;
  static const bool enableVoiceMessages = false;
  static const bool enableFileSharing = true;
  static const bool enableVideoCall = false;
  
  // Auto-destruction options (in seconds)
  static const List<int> autoDestructionOptions = [
    60,      // 1 minute
    300,     // 5 minutes
    1800,    // 30 minutes
    3600,    // 1 hour
    86400,   // 24 hours
    604800,  // 7 days
  ];
  
  // Supported languages
  static const List<String> supportedLanguages = [
    'en', // English
    'es', // Spanish
    'fr', // French
    'de', // German
    'pt', // Portuguese
    'ru', // Russian
    'zh', // Chinese
    'ja', // Japanese
    'ar', // Arabic
  ];
  
  static const SecurityLevel defaultSecurityLevel = SecurityLevel.high;
  
  static bool useTor = true;
  static String backendBaseUrl = defaultBackendUrl;
  
  // Get security settings based on level
  static Map<String, dynamic> getSecuritySettings(SecurityLevel level) {
    switch (level) {
      case SecurityLevel.standard:
        return {
          'requireBiometric': false,
          'autoLockTimeout': 300, // 5 minutes
          'enableScreenshotProtection': false,
          'enableAntiForensics': false,
          'defaultMessageTTL': 86400, // 24 hours
        };
      case SecurityLevel.high:
        return {
          'requireBiometric': true,
          'autoLockTimeout': 60, // 1 minute
          'enableScreenshotProtection': true,
          'enableAntiForensics': true,
          'defaultMessageTTL': 3600, // 1 hour
        };
      case SecurityLevel.paranoid:
        return {
          'requireBiometric': true,
          'autoLockTimeout': 30, // 30 seconds
          'enableScreenshotProtection': true,
          'enableAntiForensics': true,
          'defaultMessageTTL': 300, // 5 minutes
        };
    }
  }
}
