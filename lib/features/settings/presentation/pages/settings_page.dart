import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../../../help/presentation/help_page.dart';
import 'package:secure_messenger/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:secure_messenger/features/settings/providers/settings_provider.dart';
import 'package:secure_messenger/core/session/session_manager.dart';
import 'package:secure_messenger/core/storage/secure_storage.dart';
import 'package:flutter/services.dart';
import 'package:secure_messenger/features/auth/presentation/pages/pin_setup_page.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:restart_app/restart_app.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<List<String>> _getWallpapers() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final wallpapers = <String>[];
    final regExp = RegExp(r'assets/images/wallpapers/.*\.(jpg|png)",');
    for (final match in regExp.allMatches(manifestContent)) {
      final path = match.group(0)?.replaceAll('"', '').replaceAll(',', '');
      if (path != null) wallpapers.add(path);
    }
    return wallpapers;
  }

  Future<String?> _pickAndSanitizeImage(BuildContext context) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return null;
    final bytes = await picked.readAsBytes();
    final decoded = img.decodeImage(bytes);
    if (decoded == null) return null;
    // Remove metadados
    final sanitized = img.encodeJpg(decoded);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/custom_wallpaper.jpg');
    await file.writeAsBytes(sanitized);
    return file.path;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final settings = context.watch<SettingsProvider>();
    return Scaffold(
      appBar: AppBar(title: Text(l.settingsTitle)),
      body: ListView(
        children: [
          ListTile(
            title: Text(l.identityTitle),
            leading: const Icon(Icons.perm_identity),
            subtitle: FutureBuilder<String?>(
              future: SecureStorage.read('public_key'),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return Text(l.sessionIdCopied); // ou outro texto de erro
                }
                return SelectableText(snapshot.data!);
              },
            ),
            trailing: IconButton(
              icon: const Icon(Icons.copy),
              tooltip: l.copySessionId,
              onPressed: () async {
                final publicKey = await SecureStorage.read('public_key');
                if (publicKey != null) {
                  Clipboard.setData(ClipboardData(text: publicKey));
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.sessionIdCopied)));
                }
              },
            ),
          ),
          ListTile(
            title: Text(l.language),
            trailing: DropdownButton<Locale>(
              value: settings.locale,
              onChanged: (locale) {
                if (locale != null) settings.setLocale(locale);
              },
              items: [
                DropdownMenuItem(value: Locale('en'), child: Text(l.language + ' (English)')),
                DropdownMenuItem(value: Locale('pt'), child: Text(l.language + ' (Português)')),
                DropdownMenuItem(value: Locale('ru'), child: Text(l.language + ' (Русский)')),
                DropdownMenuItem(value: Locale('zh'), child: Text(l.language + ' (中文)')),
              ],
            ),
          ),
          ListTile(
            title: Text(l.helpTitle),
            leading: const Icon(Icons.help_outline),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const HelpPage()),
            ),
          ),
          ListTile(
            title: Text(l.chatWallpaper),
            leading: const Icon(Icons.wallpaper),
            onTap: () async {
              final wallpapers = await _getWallpapers();
              final selected = await showDialog<String?>(
                context: context,
                builder: (context) => SimpleDialog(
                  title: Text(l.chooseWallpaper),
                  children: [
                    ...wallpapers.map((path) => SimpleDialogOption(
                          onPressed: () => Navigator.of(context).pop(path),
                          child: Row(
                            children: [
                              Image.asset(path, width: 48, height: 48, fit: BoxFit.cover),
                              const SizedBox(width: 12),
                              Expanded(child: Text(l.wallpaper1)),
                            ],
                          ),
                        )),
                    SimpleDialogOption(
                      onPressed: () async {
                        final customPath = await _pickAndSanitizeImage(context);
                        Navigator.of(context).pop(customPath);
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.add_photo_alternate),
                          const SizedBox(width: 12),
                          Text('Selecionar da galeria'),
                        ],
                      ),
                    ),
                    SimpleDialogOption(
                      onPressed: () => Navigator.of(context).pop(null),
                      child: Row(
                        children: [
                          const Icon(Icons.delete),
                          const SizedBox(width: 12),
                          Text(l.remove),
                        ],
                      ),
                    ),
                  ],
                ),
              );
              if (selected != null) {
                settings.setChatWallpaper(selected);
              }
            },
            subtitle: settings.chatWallpaperPath != null
                ? Text(l.wallpaperSelected)
                : Text(l.wallpaperDefault),
          ),
          SwitchListTile(
            title: Text(l.darkMode),
            value: settings.isDarkMode,
            onChanged: (val) => settings.setDarkMode(val),
            secondary: const Icon(Icons.dark_mode),
          ),
          SwitchListTile(
            title: Text(l.pinLock),
            value: settings.isPinEnabled,
            onChanged: (val) async {
              final sessionManager = Provider.of<SessionManager>(context, listen: false);
              if (val) {
                // Ativar PIN: abrir tela de criação
                final result = await Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const PinSetupPage()),
                );
                // Só ativa se o PIN foi criado com sucesso
                if (result == true) {
                  await settings.setPinEnabled(true);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l.pinSetTitle)),
                  );
                  await Future.delayed(const Duration(milliseconds: 300));
                  Restart.restartApp();
                }
              } else {
                // Desativar PIN: remover hash
                await sessionManager.removePin();
                settings.setPinEnabled(false);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${l.pinLock} desativado')), // Internacionalizar se necessário
                );
              }
            },
            secondary: const Icon(Icons.lock),
          ),
          ListTile(
            title: Text(l.themeColor),
            leading: const Icon(Icons.color_lens),
            onTap: () async {
              Color picked = settings.themeColor;
              final result = await showDialog<Color>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(l.themeColor),
                  content: SingleChildScrollView(
                    child: ColorPicker(
                      pickerColor: picked,
                      onColorChanged: (color) => picked = color,
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: Text(l.cancel),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    TextButton(
                      child: Text(l.save),
                      onPressed: () => Navigator.of(context).pop(picked),
                    ),
                  ],
                ),
              );
              if (result != null) settings.setThemeColor(result);
            },
            subtitle: Text(l.themeColorDesc),
          ),
          ListTile(
            title: Text(l.messageBubbleColor),
            leading: const Icon(Icons.chat_bubble),
            onTap: () async {
              Color picked = settings.messageBubbleColor;
              final result = await showDialog<Color>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(l.messageBubbleColor),
                  content: SingleChildScrollView(
                    child: ColorPicker(
                      pickerColor: picked,
                      onColorChanged: (color) => picked = color,
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: Text(l.cancel),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    TextButton(
                      child: Text(l.save),
                      onPressed: () => Navigator.of(context).pop(picked),
                    ),
                  ],
                ),
              );
              if (result != null) settings.setMessageBubbleColor(result);
            },
            subtitle: Text(l.messageBubbleColorDesc),
          ),
          const Divider(),
          ListTile(
            title: Text(l.logout),
            leading: const Icon(Icons.logout, color: Colors.red),
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(l.logoutConfirmTitle),
                  content: Text(l.logoutConfirmContent),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(l.cancel),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(l.logoutConfirmButton),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                // Log antiforense
                debugPrint('LOG: Usuário fez logout e apagou todos os dados.');
                await SecureStorage.secureDeleteAll();
                await Provider.of<SessionManager>(context, listen: false).resetApp();
                Navigator.of(context).pushNamedAndRemoveUntil('/setup', (route) => false);
              }
            },
          ),
        ],
      ),
    );
  }
}
