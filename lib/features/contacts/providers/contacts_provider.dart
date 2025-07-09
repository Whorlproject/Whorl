import 'package:flutter/foundation.dart';
import 'package:secure_messenger/core/crypto/types.dart';

class ContactsProvider extends ChangeNotifier {
  List<Contact> _contacts = [];

  List<Contact> get contacts => _contacts;

  void addContact(Contact contact) {
    // Evitar duplicatas pelo id
    if (_contacts.any((c) => c.id == contact.id)) return;
    _contacts.add(contact);
    notifyListeners();
  }

  void removeContact(String id) {
    _contacts.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  Contact? getContactById(String id) {
    return _contacts.firstWhere((c) => c.id == id);
  }

  void updateContact(Contact updated) {
    final idx = _contacts.indexWhere((c) => c.id == updated.id);
    if (idx != -1) {
      _contacts[idx] = updated;
      notifyListeners();
    }
  }

  void clearContacts() {
    _contacts.clear();
    notifyListeners();
  }
}
