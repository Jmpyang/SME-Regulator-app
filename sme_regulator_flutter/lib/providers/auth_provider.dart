import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';
import '../utils/error_handler.dart';

class AuthProvider with ChangeNotifier {
  AuthProvider(this._repository);

  final AuthRepository _repository;
  
  // Initialize GoogleSignIn with necessary scopes
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'https://www.googleapis.com/auth/userinfo.profile'],
  );

  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  void _setError(String? err) {
    _error = err;
    notifyListeners();
  }

  /// High-level method for the UI to call
  Future<bool> continueWithGoogle() async {
    _setError(null);
    _setLoading(true);

    try {
      // Sign out first to ensure the account picker always appears
      await _googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        _setLoading(false);
        return false; // User cancelled
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        _setError("Could not retrieve Google ID Token.");
        return false;
      }

      // Pass the token to your existing logic
      return await loginWithGoogle(idToken);
    } catch (e) {
      _setError("Google Sign-In failed: ${e.toString()}");
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> loginWithGoogle(String idToken) async {
    try {
      _setLoading(true);
      await _repository.loginWithGoogle(idToken);
      _user = await _repository.getCurrentUser();
      _setError(null);
      return true;
    } catch (e) {
      // If server login fails, ensure we clean up
      await logout();
      _setError(e is DioException ? getErrorMessage(e) : e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> checkAuthStatus() async {
    if (!await _repository.hasSavedToken) return false;
    try {
      _setLoading(true);
      _user = await _repository.getCurrentUser();
      _setError(null);
      return true;
    } catch (e) {
      await logout();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      _setLoading(true);
      _user = await _repository.login(email, password);
      _setError(null);
      return true;
    } catch (e) {
      _error = getErrorMessage(e);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> changePassword(String currentPassword, String newPassword) async {
    try {
      _setLoading(true);
      await _repository.changePassword(currentPassword, newPassword);
      _setError(null);
      return true;
    } catch (e) {
      _error = getErrorMessage(e);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> register(Map<String, dynamic> data) async {
    try {
      _setLoading(true);
      await _repository.register(data);
      _setError(null);
      return true;
    } catch (e) {
      _error = getErrorMessage(e);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> verifyOtp(String email, String otp) async {
    try {
      _setLoading(true);
      await _repository.verifyOtp(email, otp);
      _user = await _repository.getCurrentUser();
      _setError(null);
      return true;
    } catch (e) {
      _error = getErrorMessage(e);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    await _googleSignIn.signOut(); // Also sign out from Google
    _user = null;
    notifyListeners();
  }

  void updateUserName({required String firstName, required String lastName}) {
    if (_user != null) {
      _user = _user!.copyWith(name: '$firstName $lastName');
      notifyListeners();
    }
  }
}