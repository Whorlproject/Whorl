import 'package:flutter/material.dart';
import 'package:secure_messenger/l10n/app_localizations.dart';

class GroupChatPage extends StatelessWidget {
  final String groupId;
  
  const GroupChatPage({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text('${l.groupsTitle} $groupId')),
      body: Center(
        child: Text('${l.groupsTitle} - ${l.comingSoon}'),
      ),
    );
  }
}
