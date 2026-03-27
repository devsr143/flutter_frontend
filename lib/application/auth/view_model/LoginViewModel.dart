import 'package:my_app/application/auth/service/service.dart';
import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    setLoading(true);
    bool success = await _authService.login(username, password);
    setLoading(false);
    return success;
  }

  Future<String?> getToken() async {
    return await _authService.getToken();
  }

  Future<void> logout() async {
    await _authService.logout();
  }
}