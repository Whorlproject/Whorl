import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:secure_messenger/l10n/app_localizations.dart';

import '../../../../core/session/session_manager.dart';

class PinSetupPage extends StatefulWidget {
  const PinSetupPage({super.key});

  @override
  State<PinSetupPage> createState() => _PinSetupPageState();
}

class _PinSetupPageState extends State<PinSetupPage> {
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();
  final FocusNode _pinFocus = FocusNode();
  final FocusNode _confirmPinFocus = FocusNode();
  
  bool _isLoading = false;
  String? _errorMessage;
  bool _obscurePin = true;
  bool _obscureConfirmPin = true;

  @override
  void dispose() {
    _pinController.dispose();
    _confirmPinController.dispose();
    _pinFocus.dispose();
    _confirmPinFocus.dispose();
    super.dispose();
  }

  void _setupAccount() async {
    final l = AppLocalizations.of(context)!;
    if (_pinController.text.length < 6) {
      setState(() {
        _errorMessage = l.pinMinLength;
      });
      return;
    }

    if (_pinController.text != _confirmPinController.text) {
      setState(() {
        _errorMessage = l.pinNoMatch;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final sessionManager = context.read<SessionManager>();
      final success = await sessionManager.completeSetup(
        pin: _pinController.text,
        displayName: '', // displayName não é mais usado
      );

      if (success) {
        await sessionManager.markSetupCompletedPersisted();
        if (mounted) {
          Navigator.of(context).pop(true);
        }
      } else {
        setState(() {
          _errorMessage = l.setupFailed;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = l.errorOccurred(e.toString());
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pinSetTitle),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Text(
                AppLocalizations.of(context)!.pinSetTitle,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              // PIN Field
              TextField(
                controller: _pinController,
                focusNode: _pinFocus,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.pinLabel,
                  hintText: AppLocalizations.of(context)!.enterPinHint,
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePin ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _obscurePin = !_obscurePin;
                      });
                    },
                  ),
                ),
                obscureText: _obscurePin,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                textInputAction: TextInputAction.next,
                onSubmitted: (_) => _confirmPinFocus.requestFocus(),
              ),
              const SizedBox(height: 24),
              // Confirm PIN Field
              TextField(
                controller: _confirmPinController,
                focusNode: _confirmPinFocus,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.confirmPinLabel,
                  hintText: AppLocalizations.of(context)!.reenterPinHint,
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirmPin ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPin = !_obscureConfirmPin;
                      });
                    },
                  ),
                ),
                obscureText: _obscureConfirmPin,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _setupAccount(),
              ),
              const SizedBox(height: 24),
              // Error message
              if (_errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  color: Colors.red.withOpacity(0.1),
                  child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
                ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _setupAccount,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : Text(AppLocalizations.of(context)!.createAccount),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
