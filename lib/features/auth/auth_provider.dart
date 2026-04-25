import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../core/api/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});

class AuthState {
  final bool isLoading;
  final String? error;
  final String? token;
  final Map<String, dynamic>? user;

  AuthState({this.isLoading = false, this.error, this.token, this.user});

  AuthState copyWith({
    bool? isLoading,
    String? error,
    String? token,
    Map<String, dynamic>? user,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      token: token ?? this.token,
      user: user ?? this.user,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    return AuthState();
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.register}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'role': role,
        }),
      );

      // ADD THESE 2 LINES HERE
      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();

       // await prefs.setString('token', data['token']);
        await prefs.setString('user', jsonEncode(data['user']));

        state = state.copyWith(isLoading: false);
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: data['error'] ?? 'Registration failed',
        );
        return false;
      }
    } catch (e) {
       print("REGISTER ERROR: $e"); // ADD THIS
      state = state.copyWith(
        isLoading: false,
        error: 'Network error: ${e.toString()}',
      );
      return false;
    }
  }

  // ================= LOGIN SECTION =================
  Future<bool> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.login}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {

       // print("LOGIN SUCCESS - SAVING USER");
        // ✅ FIX: Save to storage (required for splash auto-login)
        final prefs = await SharedPreferences.getInstance();

        await prefs.setString('token', data['token']);
        await prefs.setString('user', jsonEncode(data['user']));

        state = state.copyWith(
          isLoading: false,
          token: data['token'],
          user: data['user'],
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: data['message'] ?? 'Login failed',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Network error: ${e.toString()}',
      );
      return false;
    }
  }

  // ================= LOAD USER =================
  Future<void> loadUserFromStorage() async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('token');
    final userString = prefs.getString('user');

    if (token != null && userString != null) {
      final user = jsonDecode(userString);

      state = state.copyWith(
        token: token,
        user: user,
      );
    }
  }

  // ================= LOGOUT =================
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    state = AuthState();
  }
}