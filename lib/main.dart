import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'dart:io';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'core/navigation/app_router.dart';
import 'core/session/session_manager.dart';
import 'core/storage/secure_storage.dart';
import 'core/theme/app_theme.dart';
import 'core/config/app_config.dart';
import 'core/crypto/crypto_manager.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/chat/providers/chat_provider.dart';
import 'features/contacts/providers/contacts_provider.dart';
import 'features/settings/providers/settings_provider.dart';
import 'features/auth/presentation/pages/passcode_lock_page.dart';
import 'l10n/app_localizations.dart';
import 'features/chat/presentation/pages/chat_list_page.dart';
import 'features/auth/presentation/pages/setup_page.dart';
import 'features/settings/presentation/pages/settings_page.dart';
import 'features/contacts/presentation/pages/add_contact_page.dart';
import 'features/groups/presentation/pages/groups_page.dart';
import 'features/contacts/presentation/pages/contacts_page.dart';
import 'features/chat/presentation/pages/chat_page.dart';
import 'features/auth/presentation/pages/pin_login_page.dart';
import 'features/auth/presentation/pages/passcode_lock_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
    _checkInitialRoute();
  }

  Future<void> _checkInitialRoute() async {
    await SecureStorage.initialize();
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    await settings.loadPreferences(); // garantir que está carregado
    final accountExists = await SecureStorage.read('account_exists');
    final hasPin = await SecureStorage.containsKey('pin_hash');
    if (accountExists == 'true') {
      if (settings.isPinEnabled && hasPin) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const PinLoginPage()),
        );
      } else {
        Navigator.of(context).pushReplacementNamed('/chats');
      }
    } else {
      Navigator.of(context).pushReplacementNamed('/setup');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF222B45),
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: SvgPicture.asset(
            'assets/icons/app_logo.svg',
            width: 120,
            height: 120,
          ),
        ),
      ),
    );
  }
}

class AppGatekeeper extends StatefulWidget {
  final Widget child;
  const AppGatekeeper({required this.child, super.key});

  @override
  State<AppGatekeeper> createState() => _AppGatekeeperState();
}

class _AppGatekeeperState extends State<AppGatekeeper> with WidgetsBindingObserver {
  bool _locked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkPinLock();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPinLock();
    }
  }

  Future<void> _checkPinLock() async {
    final settings = context.read<SettingsProvider>();
    final sessionManager = context.read<SessionManager>();
    await settings.loadPreferences();
    final hasPin = await SecureStorage.containsKey('pin_hash');
    if (settings.isPinEnabled && !_locked && hasPin) {
      setState(() { _locked = true; });
      final ok = await Navigator.of(context).push(
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (_) => const PasscodeLockPage(),
        ),
      );
      setState(() { _locked = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkPinLock();
    });
    return widget.child;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Proteção contra screenshots (Android)
  try {
    const platform = MethodChannel('flutter/window_manager');
    await platform.invokeMethod('addFlags', 0x00002000); // FLAG_SECURE
  } catch (_) {}

  // Anti-forense: wipe antes de qualquer inicialização
  bool isDanger = false;
  try {
    final isJailbroken = await FlutterJailbreakDetection.jailbroken;
    final isEmulator = false; // Placeholder
    final isDebug = false;
    assert(() {
      return isDebug == true;
    }());
    if (isJailbroken || isEmulator || isDebug) {
      isDanger = true;
    }
  } catch (_) {}
  if (isDanger) {
    await SecureStorage.initialize();
    await SecureStorage.secureDeleteAll();
    exit(0);
  }

  // Carregar idioma e preferências salvas antes de iniciar o app
  final settingsProvider = SettingsProvider();
  await settingsProvider.loadLocale();
  await settingsProvider.loadPreferences();

  runApp(SecureMessengerApp(settingsProvider: settingsProvider));
}

class SecureMessengerApp extends StatelessWidget {
  final SettingsProvider settingsProvider;
  const SecureMessengerApp({super.key, required this.settingsProvider});

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        // Resetar overlay de aviso de print
        PrintOverlay.hide(context);
      },
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SessionManager()),
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => ChatProvider()),
          ChangeNotifierProvider(create: (_) => ContactsProvider()),
          ChangeNotifierProvider<SettingsProvider>.value(value: settingsProvider),
        ],
        child: Consumer<SettingsProvider>(
          builder: (context, settings, child) {
            return AppGatekeeper(
              child: MaterialApp(
                title: AppConfig.appName,
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme(settings.themeColor),
                darkTheme: AppTheme.darkTheme(settings.themeColor),
                themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
                locale: settings.locale,
                supportedLocales: AppLocalizations.supportedLocales,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                home: const SplashScreen(),
                routes: {
                  '/setup': (_) => const SetupPage(),
                  '/chats': (_) => const ChatListPage(),
                  '/settings': (_) => const SettingsPage(),
                  '/add-contact': (_) => AddContactPage(onContactAdded: (_) {}),
                  '/groups': (_) => const GroupsPage(),
                  '/contacts': (_) => const ContactsPage(),
                  '/chat': (context) {
                    final contactId = ModalRoute.of(context)?.settings.arguments as String?;
                    return ChatPage(contactId: contactId ?? '');
                  },
                  '/pin-lock': (_) => const PasscodeLockPage(),
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class PrintOverlay extends StatefulWidget {
  final Widget child;
  const PrintOverlay({required this.child, super.key});

  static void show(BuildContext context) {
    final state = context.findAncestorStateOfType<_PrintOverlayState>();
    state?._showOverlay();
  }
  static void hide(BuildContext context) {
    final state = context.findAncestorStateOfType<_PrintOverlayState>();
    state?._hideOverlay();
  }

  @override
  State<PrintOverlay> createState() => _PrintOverlayState();
}

class _PrintOverlayState extends State<PrintOverlay> {
  bool _show = false;
  static const platform = MethodChannel('secure_messenger/print');

  @override
  void initState() {
    super.initState();
    _initPrintDetection();
  }

  Future<void> _initPrintDetection() async {
    platform.setMethodCallHandler((call) async {
      if (call.method == 'onScreenshot' || call.method == 'onScreenRecord') {
        setState(() => _show = true);
        await Future.delayed(const Duration(seconds: 3));
        setState(() => _show = false);
      }
    });
  }

  void _showOverlay() => setState(() => _show = true);
  void _hideOverlay() => setState(() => _show = false);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_show)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.8),
              child: const Center(
                child: Text(
                  'Printscreen/Gravação bloqueados para sua segurança.',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
