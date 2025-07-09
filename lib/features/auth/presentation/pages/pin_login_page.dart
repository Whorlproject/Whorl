import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../core/session/session_manager.dart';

class PinLoginPage extends StatefulWidget {
  const PinLoginPage({super.key});

  @override
  State<PinLoginPage> createState() => _PinLoginPageState();
}

class _PinLoginPageState extends State<PinLoginPage> {
  String _pin = '';
  bool _isLoading = false;
  String? _error;

  void _onPinChanged(String value) {
    setState(() {
      _pin = value;
      _error = null;
    });
    if (value.length == 6) {
      _login();
    }
  }

  void _login() async {
    if (_pin.length < 6) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    final sessionManager = context.read<SessionManager>();
    final ok = await sessionManager.authenticateWithPin(_pin);
    setState(() => _isLoading = false);
    if (ok) {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/chats');
      }
    } else {
      setState(() {
        _error = 'PIN incorreto';
        _pin = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Digite o PIN')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PinCodeTextField(
              appContext: context,
              length: 6,
              obscureText: true,
              animationType: AnimationType.fade,
              keyboardType: TextInputType.number,
              autoFocus: true,
              onChanged: _onPinChanged,
              onCompleted: (_) {},
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(8),
                fieldHeight: 50,
                fieldWidth: 40,
                activeFillColor: Colors.white,
                selectedFillColor: Colors.white,
                inactiveFillColor: Colors.white,
                activeColor: Theme.of(context).colorScheme.primary,
                selectedColor: Theme.of(context).colorScheme.primary,
                inactiveColor: Colors.grey,
              ),
              errorAnimationController: null,
              enableActiveFill: true,
              textStyle: const TextStyle(fontSize: 20),
              beforeTextPaste: (text) => false,
              pastedTextStyle: const TextStyle(color: Colors.black),
              showCursor: true,
              cursorColor: Theme.of(context).colorScheme.primary,
              autoDisposeControllers: false,
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(_error!, style: const TextStyle(color: Colors.red)),
              ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading || _pin.length < 6 ? null : _login,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Desbloquear'),
            ),
          ],
        ),
      ),
    );
  }
}
