import 'package:flutter/material.dart';
import 'package:secure_messenger/l10n/app_localizations.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.helpTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l.helpIntro, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Text(l.helpOrbotTitle, style: Theme.of(context).textTheme.titleMedium),
          Text(l.helpOrbotStep1),
          Text(l.helpOrbotStep2),
          Text(l.helpOrbotStep3),
          Text(l.helpOrbotStep4),
          Text(l.helpOrbotStep5),
          const SizedBox(height: 16),
          Text(l.helpContactAdd, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 8),
          Text(l.helpPin, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 8),
          Text(l.helpSecurity, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 8),
          Text(l.helpPermissions, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 8),
          Text(l.helpQr, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 8),
          Text(l.helpLang, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 8),
          Text(l.helpSupport, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
} 