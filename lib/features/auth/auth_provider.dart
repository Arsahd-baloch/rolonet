// import 'dart:convert';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:http/http.dart' as http;
// import '../../core/api/api_constants.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
//   return AuthNotifier();
// });

// class AuthState {
//   final bool isLoading;
//   final String? error;
//   final String? token;
//   final Map<String, dynamic>? user;

//   AuthState({this.isLoading = false, this.error, this.token, this.user});

//   AuthState copyWith({
//     bool? isLoading,
//     String? error,
//     String? token,
//     Map<String, dynamic>? user,
//   }) {
//     return AuthState(
//       isLoading: isLoading ?? this.isLoading,
//       error: error,
//       token: token ?? this.token,
//       user: user ?? this.user,
//     );
//   }
// }

// class AuthNotifier extends Notifier<AuthState> {
//   @override
//   AuthState build() {
//     return AuthState();
//   }

//   Future<bool> register({
//     required String name,
//     required String email,
//     required String password,
//     required String role,
//   }) async {
//     state = state.copyWith(isLoading: true, error: null);
//     try {
//       final response = await http.post(
//         Uri.parse('${ApiConstants.baseUrl}${ApiConstants.register}'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'name': name,
//           'email': email,
//           'password': password,
//           'role': role,
//         }),
//       );

//       // ADD THESE 2 LINES HERE
//       print("STATUS: ${response.statusCode}");
//       print("BODY: ${response.body}");

//       final data = jsonDecode(response.body);

//       if (response.statusCode == 201 || response.statusCode == 200) {
//         final prefs = await SharedPreferences.getInstance();

//         // await prefs.setString('token', data['token']);
//         await prefs.setString('user', jsonEncode(data['user']));

//         state = state.copyWith(isLoading: false);
//         return true;
//       } else {
//         state = state.copyWith(
//           isLoading: false,
//           error: data['error'] ?? 'Registration failed',
//         );
//         return false;
//       }
//     } catch (e) {
//       print("REGISTER ERROR: $e"); // ADD THIS
//       state = state.copyWith(
//         isLoading: false,
//         error: 'Network error: ${e.toString()}',
//       );
//       return false;
//     }
//   }

//   // ================= LOGIN SECTION =================
//   Future<bool> login({required String email, required String password}) async {
//     state = state.copyWith(isLoading: true, error: null);

//     try {
//       final response = await http.post(
//         Uri.parse('${ApiConstants.baseUrl}${ApiConstants.login}'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'email': email, 'password': password}),
//       );

//       final data = jsonDecode(response.body);

//       if (response.statusCode == 200) {
//         final rawUser = Map<String, dynamic>.from(data['user']);
//         rawUser['role'] = (rawUser['role'] as String).toLowerCase();

//         final prefs = await SharedPreferences.getInstance();
//         rawUser['role'] = (rawUser['role'] as String).toLowerCase();

//         if (rawUser['role'] == 'admin') {
//           // Memory only — admin must re-login every session
//           await prefs.remove('token');
//           await prefs.remove('user');
//         } else {
//           await prefs.setString('token', data['token']);
//           await prefs.setString('user', jsonEncode(rawUser));
//         }

//         state = state.copyWith(
//           isLoading: false,
//           token: data['token'],
//           user: rawUser,
//         );
//         return true;
//       } else {
//         state = state.copyWith(
//           isLoading: false,
//           error: data['message'] ?? 'Login failed',
//         );
//         return false;
//       }
//     } catch (e) {
//       state = state.copyWith(
//         isLoading: false,
//         error: 'Network error: ${e.toString()}',
//       );
//       return false;
//     }
//   }

//   // ================= LOAD USER =================
//   Future<void> loadUserFromStorage() async {
//     final prefs = await SharedPreferences.getInstance();

//     final token = prefs.getString('token');
//     final userString = prefs.getString('user');

//     if (token != null && userString != null) {
//       final user = jsonDecode(userString) as Map<String, dynamic>;
//       final normalizedUser = {
//         ...user,
//         'role': (user['role'] as String).toLowerCase(),
//       };

//       state = state.copyWith(token: token, user: normalizedUser);
//     }
//   }

//   // ================= LOGOUT =================
//   Future<void> logout() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.clear();

//     state = AuthState();
//   }
// }


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
 
  // ── Normalizes role to lowercase so 'ADMIN', 'Admin', 'admin' all become 'admin' ──
  Map<String, dynamic> _normalizeUser(Map<String, dynamic> user) {
    return {
      ...user,
      'role': (user['role'] as String).toLowerCase(),
    };
  }
 
  // ================= REGISTER =================
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
 
      print("REGISTER STATUS: ${response.statusCode}");
      print("REGISTER BODY: ${response.body}");
 
      final data = jsonDecode(response.body);
 
      if (response.statusCode == 201 || response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
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
      print("REGISTER ERROR: $e");
      state = state.copyWith(
        isLoading: false,
        error: 'Network error: ${e.toString()}',
      );
      return false;
    }
  }
 
  // ================= LOGIN =================
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
        // ── Normalize role to lowercase before saving ──
        final normalizedUser = _normalizeUser(data['user'] as Map<String, dynamic>);
 
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        await prefs.setString('user', jsonEncode(normalizedUser));
 
        state = state.copyWith(
          isLoading: false,
          token: data['token'],
          user: normalizedUser,
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
 
  // ================= LOAD FROM STORAGE =================
  Future<void> loadUserFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
 
    final token = prefs.getString('token');
    final userString = prefs.getString('user');
 
    if (token != null && userString != null) {
      // ── Normalize role to lowercase in case old data was stored uppercase ──
      final rawUser = jsonDecode(userString) as Map<String, dynamic>;
      final normalizedUser = _normalizeUser(rawUser);
 
      // ── Re-save normalized user so old uppercase data is fixed permanently ──
      await prefs.setString('user', jsonEncode(normalizedUser));
 
      state = state.copyWith(
        token: token,
        user: normalizedUser,
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