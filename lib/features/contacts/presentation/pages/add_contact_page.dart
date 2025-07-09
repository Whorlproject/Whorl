import 'package:flutter/material.dart';
import 'package:secure_messenger/core/crypto/types.dart';
import 'package:secure_messenger/l10n/app_localizations.dart';

class AddContactPage extends StatefulWidget {
  final void Function(Contact) onContactAdded;
  const AddContactPage({required this.onContactAdded, super.key});

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String? _error;
  bool _success = false;

  void _addContact() async {
    setState(() { _error = null; _success = false; });
    final l = AppLocalizations.of(context)!;
    final id = _idController.text.trim();
    final address = _addressController.text.trim();
    if (id.isEmpty || id.length < 16) {
      setState(() { _error = l.contactInvalid; _success = false; });
      return;
    }
    final isOnion = id.endsWith('.onion') && id.length > 22;
    final isPubKey = !isOnion && id.length >= 32;
    if (!isOnion && !isPubKey) {
      setState(() { _error = l.contactInvalid; _success = false; });
      return;
    }
    setState(() { _error = null; });
    final contact = Contact(
      id: id,
      publicKey: id,
      displayName: isOnion ? 'Onion' : 'Session',
      avatar: null,
      addedAt: DateTime.now(),
      isVerified: false,
      address: address.isNotEmpty ? address : null,
    );
    widget.onContactAdded(contact);
    setState(() { _success = true; });
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l.contactAddTitle)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _idController,
              decoration: InputDecoration(
                labelText: l.contactIdHint,
                errorText: _error,
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (_) => _addContact(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: l.connectionAddressLabel,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addContact,
              child: Text(l.contactAddButton),
            ),
            if (_success)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 8),
                    Text(l.contactAdded, style: const TextStyle(color: Colors.green)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
