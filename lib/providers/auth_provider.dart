import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/db_service.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _user;

  bool get isAuthenticated => _user != null;
  UserModel? get user => _user;

  Future<bool> login(String username, String password) async {
    final user = await DBService.getUser(username, password);
    if (user != null) {
      _user = user;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> register(String username, String password) async {
    try {
      final user = UserModel(username: username, password: password);
      await DBService.insertUser(user);
      return true;
    } catch (_) {
      return false;
    }
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
