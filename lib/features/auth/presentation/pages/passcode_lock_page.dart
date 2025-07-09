import 'package:flutter/material.dart';
import 'package:passcode_screen/passcode_screen.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import '../../../../core/session/session_manager.dart';
import 'package:secure_messenger/l10n/app_localizations.dart';
import 'dart:async';

class PasscodeLockPage extends StatefulWidget {
  const PasscodeLockPage({super.key});

  @override
  State<PasscodeLockPage> createState() => _PasscodeLockPageState();
}

class _PasscodeLockPageState extends State<PasscodeLockPage> {
  final StreamController<bool> _verificationNotifier = StreamController<bool>.broadcast();
  bool _isAuthenticated = false;
  String? _error;
  final LocalAuthentication auth = LocalAuthentication();

  @override
  void dispose() {
    _verificationNotifier.close();
    super.dispose();
  }

  Future<void> _biometricUnlock() async {
    final available = await auth.canCheckBiometrics;
    if (!available) return;
    final l = AppLocalizations.of(context)!;
    final didAuth = await auth.authenticate(
      localizedReason: l.unlockWithBiometrics,
      options: const AuthenticationOptions(biometricOnly: true),
    );
    if (didAuth) {
      setState(() => _isAuthenticated = true);
      Navigator.of(context).pop(true);
    }
  }

  Future<void> _onPasscodeEntered(String enteredPasscode) async {
    final sessionManager = context.read<SessionManager>();
    final ok = await sessionManager.authenticateWithPin(enteredPasscode);
    if (ok) {
      _verificationNotifier.add(true);
      setState(() => _isAuthenticated = true);
      Navigator.of(context).pop(true);
    } else {
      _verificationNotifier.add(false);
      setState(() => _error = AppLocalizations.of(context)!.pinError);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.1),
      body: Center(
        child: PasscodeScreen(
          title: Text(l.pinEnterTitle, style: const TextStyle(color: Colors.white)),
          passwordDigits: 6,
          isValidCallback: null,
          passwordEnteredCallback: _onPasscodeEntered,
          cancelButton: Text(l.cancel, style: const TextStyle(color: Colors.white)),
          deleteButton: Text(l.remove, style: const TextStyle(color: Colors.white)),
          shouldTriggerVerification: _verificationNotifier.stream,
          backgroundColor: Colors.black.withOpacity(0.8),
          cancelCallback: () => Navigator.of(context).pop(false),
          bottomWidget: Column(
            children: [
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(_error!, style: const TextStyle(color: Colors.red)),
                ),
              IconButton(
                icon: const Icon(Icons.fingerprint, color: Colors.white, size: 32),
                onPressed: _biometricUnlock,
              ),
              TextButton(
                onPressed: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text(l.pinForgot),
                      content: Text(l.pinForgot),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(false),
                          child: Text(l.cancel),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(true),
                          child: Text(l.reset),
                        ),
                      ],
                    ),
                  );
                  if (confirmed == true) {
                    await context.read<SessionManager>().resetApp();
                    Navigator.of(context).pop(false);
                  }
                },
                child: Text(l.pinForgot, style: const TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 