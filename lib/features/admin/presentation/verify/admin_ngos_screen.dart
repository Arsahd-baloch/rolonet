import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// ── Model ──
class _NgoItem {
  final int id;
  final String name;
  final String registrationNumber;
  final String address;
  final String verificationStatus;
  final int campaignCount;

  _NgoItem({
    required this.id,
    required this.name,
    required this.registrationNumber,
    required this.address,
    required this.verificationStatus,
    required this.campaignCount,
  });

  factory _NgoItem.fromJson(Map<String, dynamic> json) {
    return _NgoItem(
      id: int.parse(json['id'].toString()),
      name: json['name'] ?? 'Unknown NGO',
      registrationNumber: json['registration_number'] ?? '',
      address: json['address'] ?? '',
      verificationStatus: json['verification_status'] ?? 'PENDING',
      campaignCount:
          int.tryParse(json['campaign_count']?.toString() ?? '0') ?? 0,
    );
  }
}

// ── Provider ──
final _ngosProvider = FutureProvider.autoDispose<List<_NgoItem>>((ref) async {
  final baseUrl = kIsWeb
      ? 'http://localhost:3000/api'
      : 'http://10.109.20.26:3000/api';
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token') ?? '';

  final res = await http.get(
    Uri.parse('$baseUrl/admin/ngos'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (res.statusCode == 200) {
    final body = jsonDecode(res.body);
    final List list = body['data'] ?? [];
    return list.map((e) => _NgoItem.fromJson(e)).toList();
  }
  throw Exception('Failed to load NGOs: ${res.statusCode}');
});

// ── Screen ──
class AdminNgosScreen extends ConsumerWidget {
  const AdminNgosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ngosAsync = ref.watch(_ngosProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text('NGOs'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.invalidate(_ngosProvider),
          ),
        ],
      ),
      body: ngosAsync.when(
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
                onPressed: () => ref.invalidate(_ngosProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (ngos) => ngos.isEmpty
            ? const Center(
                child: Text(
                  'No NGOs found',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              )
            : RefreshIndicator(
                onRefresh: () async => ref.invalidate(_ngosProvider),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: ngos.length,
                  itemBuilder: (context, i) => _NgoCard(ngo: ngos[i]),
                ),
              ),
      ),
    );
  }
}

// ── Card ──
class _NgoCard extends StatelessWidget {
  final _NgoItem ngo;
  const _NgoCard({required this.ngo});

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'VERIFIED':
        return const Color(0xFF10B981);
      case 'PENDING':
        return const Color(0xFFF59E0B);
      case 'REJECTED':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF94A3B8);
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(ngo.verificationStatus);

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
          // Icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.domain_rounded,
              color: Color(0xFF8B5CF6),
              size: 22,
            ),
          ),
          const SizedBox(width: 14),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ngo.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  ngo.registrationNumber,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 12,
                      color: Color(0xFF94A3B8),
                    ),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        ngo.address,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF94A3B8),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.campaign_outlined,
                      size: 13,
                      color: Color(0xFF94A3B8),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${ngo.campaignCount} campaigns',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Verification status badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: statusColor.withValues(alpha: 0.3)),
            ),
            child: Text(
              ngo.verificationStatus,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
