import 'package:flutter/material.dart';
import 'package:secure_messenger/features/auth/presentation/pages/pin_setup_page.dart';
import 'package:secure_messenger/l10n/app_localizations.dart';

class SecuritySettingsPage extends StatelessWidget {
  const SecuritySettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l.securitySettingsTitle)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(l.securitySettingsTitle),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.lock),
              label: Text(l.createOrChangePin),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const PinSetupPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
