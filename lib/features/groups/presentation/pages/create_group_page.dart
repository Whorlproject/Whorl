import 'package:flutter/material.dart';
import 'package:secure_messenger/l10n/app_localizations.dart';

class CreateGroupPage extends StatelessWidget {
  const CreateGroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l.createGroupTitle)),
      body: Center(
        child: Text('${l.createGroupTitle} - ${l.comingSoon}'),
      ),
    );
  }
}
