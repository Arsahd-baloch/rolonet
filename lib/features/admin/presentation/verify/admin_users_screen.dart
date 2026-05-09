// D:\Gravity_Relifnet\lib\features\admin\presentation\verify\admin_users_screen.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// ── Simple User model for this screen ──
class _UserItem {
  final int id;
  final String name;
  final String email;
  final String role;
  final String status;

  _UserItem({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.status,
  });

  factory _UserItem.fromJson(Map<String, dynamic> json) {
    return _UserItem(
      id: int.parse(json['id'].toString()),
      name: json['name'] ?? 'Unknown',
      email: json['email'] ?? '',
      role: (json['role'] ?? 'unknown').toString().toLowerCase(),
      status: (json['status'] ?? 'ACTIVE').toString(),
    );
  }
}

// ── Provider ──
final _usersProvider = FutureProvider<List<_UserItem>>((ref) async {
  final baseUrl = kIsWeb
      ? 'http://localhost:3000/api'
      : 'http://10.109.20.26:3000/api';
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token') ?? '';

  final res = await http.get(
    Uri.parse('$baseUrl/admin/users'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (res.statusCode == 200) {
    final body = jsonDecode(res.body);
    final List list = body['data'] ?? body ?? [];
    return list.map((e) => _UserItem.fromJson(e)).toList();
  }
  throw Exception('Failed to load users: ${res.statusCode}');
});

// ── Screen ──
class AdminUsersScreen extends ConsumerWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(_usersProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text('Users'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.invalidate(_usersProvider),
          ),
        ],
      ),
      body: usersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 12),
              Text(
                e.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(_usersProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (users) => users.isEmpty
            ? const Center(
                child: Text(
                  'No users found',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              )
            : RefreshIndicator(
                onRefresh: () async => ref.invalidate(_usersProvider),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: users.length,
                  itemBuilder: (context, i) => _UserCard(user: users[i]),
                ),
              ),
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  final _UserItem user;
  const _UserCard({required this.user});

  Color _roleColor(String role) {
    switch (role) {
      case 'admin':
        return const Color(0xFFEF4444);
      case 'ngo_admin':
        return const Color(0xFF3B82F6);
      case 'donor':
        return const Color(0xFF10B981);
      case 'volunteer':
        return const Color(0xFF8B5CF6);
      case 'beneficiary':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF94A3B8);
    }
  }

  @override
  Widget build(BuildContext context) {
    final roleColor = _roleColor(user.role);
    final isActive = user.status.toUpperCase() == 'ACTIVE';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 22,
            backgroundColor: roleColor.withValues(alpha: 0.15),
            child: Text(
              user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: roleColor,
              ),
            ),
          ),
          const SizedBox(width: 14),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  user.email,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    // Role badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: roleColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        user.role.toUpperCase().replaceAll('_', ' '),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: roleColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Status dot
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isActive
                            ? const Color(0xFF10B981)
                            : const Color(0xFFEF4444),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isActive ? 'Active' : 'Inactive',
                      style: TextStyle(
                        fontSize: 11,
                        color: isActive
                            ? const Color(0xFF10B981)
                            : const Color(0xFFEF4444),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
