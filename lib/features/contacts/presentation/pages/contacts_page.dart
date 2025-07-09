import 'package:flutter/material.dart';
import 'package:secure_messenger/core/crypto/types.dart';
import 'add_contact_page.dart';
import 'package:secure_messenger/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../providers/contacts_provider.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  void _addContact(Contact contact) {
    Provider.of<ContactsProvider>(context, listen: false).addContact(contact);
  }

  void _editContact(BuildContext context, Contact contact) async {
    final updated = await showDialog<Contact?>(
      context: context,
      builder: (_) => _EditContactDialog(contact: contact),
    );
    if (updated != null) {
      Provider.of<ContactsProvider>(context, listen: false).updateContact(updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final contacts = Provider.of<ContactsProvider>(context).contacts;
    return Scaffold(
      appBar: AppBar(title: Text(l.contactAddTitle)),
      body: Column(
        children: [
          Expanded(
            child: contacts.isEmpty
                ? Center(child: Text(l.noContacts))
                : ListView.builder(
                    itemCount: contacts.length,
                    itemBuilder: (context, idx) {
                      final c = contacts[idx];
                      return ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(c.displayName),
                        subtitle: Text(c.address ?? c.id),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          tooltip: l.editContact,
                          onPressed: () => _editContact(context, c),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.person_add),
              label: Text(l.contactAddButton),
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => AddContactPage(onContactAdded: _addContact),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EditContactDialog extends StatefulWidget {
  final Contact contact;
  const _EditContactDialog({required this.contact});
  @override
  State<_EditContactDialog> createState() => _EditContactDialogState();
}

class _EditContactDialogState extends State<_EditContactDialog> {
  late TextEditingController _addressController;
  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController(text: widget.contact.address ?? '');
  }
  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l.editContact),
      content: TextField(
        controller: _addressController,
        decoration: InputDecoration(
          labelText: l.connectionAddressLabel,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l.cancel),
        ),
        ElevatedButton(
          onPressed: () {
            final updated = Contact(
              id: widget.contact.id,
              publicKey: widget.contact.publicKey,
              displayName: widget.contact.displayName,
              avatar: widget.contact.avatar,
              addedAt: widget.contact.addedAt,
              isVerified: widget.contact.isVerified,
              address: _addressController.text.trim().isNotEmpty ? _addressController.text.trim() : null,
            );
            Navigator.of(context).pop(updated);
          },
          child: Text(l.save),
        ),
      ],
    );
  }
}
