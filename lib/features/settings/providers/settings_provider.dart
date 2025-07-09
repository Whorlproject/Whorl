import 'package:flutter/material.dart';
import 'package:secure_messenger/core/storage/secure_storage.dart';

class SettingsProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');
  Locale get locale => _locale;

  bool _isDarkMode = false;
  double _textScale = 1.0;
  String? _chatWallpaperPath;
  bool _isPinEnabled = false;
  Color _themeColor = Colors.blue;
  Color _messageBubbleColor = Colors.blueAccent;

  SettingsProvider() {
    loadPreferences();
  }

  bool get isDarkMode => _isDarkMode;
  double get textScale => _textScale;
  String? get chatWallpaperPath => _chatWallpaperPath;
  bool get isPinEnabled => _isPinEnabled;
  Color get themeColor => _themeColor;
  Color get messageBubbleColor => _messageBubbleColor;

  Future<void> loadLocale() async {
    final code = await SecureStorage.read('locale_code');
    if (code != null) {
      _locale = Locale(code);
      notifyListeners();
    }
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    await SecureStorage.write('locale_code', locale.languageCode);
    notifyListeners();
  }

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setTextScale(double scale) {
    _textScale = scale;
    notifyListeners();
  }

  void setChatWallpaper(String? path) {
    _chatWallpaperPath = path;
    notifyListeners();
  }

  Future<void> loadPreferences() async {
    final pinEnabled = await SecureStorage.read('is_pin_enabled');
    if (pinEnabled != null) _isPinEnabled = pinEnabled == 'true';
    final darkMode = await SecureStorage.read('is_dark_mode');
    if (darkMode != null) _isDarkMode = darkMode == 'true';
    final themeColorStr = await SecureStorage.read('theme_color');
    if (themeColorStr != null) _themeColor = Color(int.parse(themeColorStr));
    final bubbleColorStr = await SecureStorage.read('bubble_color');
    if (bubbleColorStr != null) _messageBubbleColor = Color(int.parse(bubbleColorStr));
    notifyListeners();
  }

  Future<void> setPinEnabled(bool value) async {
    _isPinEnabled = value;
    await SecureStorage.write('is_pin_enabled', value.toString());
    notifyListeners();
  }

  @override
  void setDarkMode(bool value) {
    _isDarkMode = value;
    SecureStorage.write('is_dark_mode', value.toString());
    notifyListeners();
  }

  @override
  void setThemeColor(Color color) {
    _themeColor = color;
    SecureStorage.write('theme_color', color.value.toString());
    notifyListeners();
  }

  @override
  void setMessageBubbleColor(Color color) {
    _messageBubbleColor = color;
    SecureStorage.write('bubble_color', color.value.toString());
    notifyListeners();
  }
}
