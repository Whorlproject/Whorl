# Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Cryptography
-keep class org.bouncycastle.** { *; }
-dontwarn org.bouncycastle.**

# Secure Storage
-keep class androidx.security.crypto.** { *; }

# Biometric
-keep class androidx.biometric.** { *; }

# Camera
-keep class androidx.camera.** { *; }

# QR Code
-keep class com.google.zxing.** { *; }

# General
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes InnerClasses
-keepattributes EnclosingMethod

# Remove debug logs
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
}
