import 'package:flutter/material.dart';
import 'package:secure_messenger/l10n/app_localizations.dart';

class GroupsPage extends StatelessWidget {
  const GroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l.groupsTitle)),
      body: Center(
        child: Text('${l.groupsTitle} - ${l.comingSoon}'),
      ),
    );
  }
}
