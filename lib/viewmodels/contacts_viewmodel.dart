import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/contacts_service.dart';

class ContactsViewModel with ChangeNotifier {
  final ContactsService _contactsService = ContactsService();
  List<User> _contacts = [];
  bool _isLoading = false;

  List<User> get contacts => _contacts;
  bool get isLoading => _isLoading;

  ContactsViewModel() {
    fetchContacts();
  }

  Future<void> fetchContacts() async {
    _isLoading = true;
    notifyListeners();
    _contacts = await _contactsService.fetchContacts();
    _isLoading = false;
    notifyListeners();
  }
}