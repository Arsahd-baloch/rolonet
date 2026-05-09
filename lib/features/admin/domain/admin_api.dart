import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'admin_stats_model.dart';

class AdminApi {
  static String get baseUrl =>
      kIsWeb ? 'http://localhost:3000/api' : 'http://10.109.20.26:3000/api';

  static Map<String, String> _headers(String token) => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  // ── GET /admin/dashboard ──
  static Future<AdminStatsModel> getDashboardStats(String token) async {
    final res = await http.get(
      Uri.parse('$baseUrl/admin/dashboard'),
      headers: _headers(token),
    );
    final body = jsonDecode(res.body);
    if (res.statusCode == 200) return AdminStatsModel.fromJson(body);
    throw Exception(body['error'] ?? 'Failed to load stats');
  }

  // ── GET /admin/pending-verifications ──
  static Future<Map<String, dynamic>> getPendingVerifications(
    String token,
  ) async {
    final res = await http.get(
      Uri.parse('$baseUrl/admin/pending-verifications'),
      headers: _headers(token),
    );
    final body = jsonDecode(res.body);
    if (res.statusCode == 200) {
      return {
        'pending_donations': (body['pending_donations'] as List)
            .map((e) => PendingDonationModel.fromJson(e))
            .toList(),
        'pending_ngos': (body['pending_ngos'] as List)
            .map((e) => PendingNgoModel.fromJson(e))
            .toList(),
      };
    }
    throw Exception(body['error'] ?? 'Failed to load pending verifications');
  }

  // ── GET /admin/recent-activity ──
  static Future<List<RecentActionModel>> getRecentActivity(String token) async {
    final res = await http.get(
      Uri.parse('$baseUrl/admin/recent-activity'),
      headers: _headers(token),
    );
    final body = jsonDecode(res.body);
    if (res.statusCode == 200) {
      final List actions = body['recent_actions'] ?? [];
      return actions.map((e) => RecentActionModel.fromJson(e)).toList();
    }
    throw Exception(body['error'] ?? 'Failed to load recent activity');
  }

  // ── PATCH /donations/:id/verify ──
  static Future<bool> verifyDonation(int id, String token) async {
    final res = await http.patch(
      Uri.parse('$baseUrl/donations/$id/verify'),
      headers: _headers(token),
    );
    return res.statusCode == 200;
  }

  // ── PATCH /donations/:id/cancel ──
  static Future<bool> cancelDonation(int id, String token) async {
    final res = await http.patch(
      Uri.parse('$baseUrl/donations/$id/cancel'),
      headers: _headers(token),
    );
    return res.statusCode == 200;
  }

  // ── PATCH /campaigns/:id/activate ──
  static Future<bool> activateCampaign(int id, String token) async {
    final res = await http.patch(
      Uri.parse('$baseUrl/campaigns/$id/activate'),
      headers: _headers(token),
    );
    return res.statusCode == 200;
  }

  // ── PATCH /campaigns/:id/close ──
  static Future<bool> closeCampaign(int id, String token) async {
    final res = await http.patch(
      Uri.parse('$baseUrl/campaigns/$id/close'),
      headers: _headers(token),
    );
    return res.statusCode == 200;
  }

  // ── DELETE /campaigns/:id ──
  static Future<bool> deleteCampaign(int id, String token) async {
    final res = await http.delete(
      Uri.parse('$baseUrl/campaigns/$id'),
      headers: _headers(token),
    );
    return res.statusCode == 200;
  }
}
