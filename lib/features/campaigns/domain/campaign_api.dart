import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:reliefnet/features/campaigns/domain/campaign_model.dart';
import 'package:flutter/foundation.dart';

class CampaignApi {
  static const String baseUrl = kIsWeb
      ? 'http://localhost:3000/api'
      : String.fromEnvironment(
          'API_URL',
          defaultValue: 'http://10.109.20.26:3000/api',
        );

  // ================= GET ALL CAMPAIGNS =================
  static Future<List<CampaignModel>> getCampaigns() async {
    final response = await http.get(
      Uri.parse("$baseUrl/campaigns"),
      headers: {"Content-Type": "application/json"},
    );

    print("GET CAMPAIGNS STATUS: ${response.statusCode}");
    print("GET CAMPAIGNS BODY: ${response.body}");

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      List data;
      if (decoded is List) {
        data = decoded;
      } else if (decoded['data'] != null) {
        data = decoded['data'];
      } else {
        throw Exception("Invalid response format");
      }

      return data.map((json) => CampaignModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load campaigns: ${response.body}");
    }
  }

  // ================= CREATE CAMPAIGN =================
  static Future<CampaignModel> createCampaign(
    CampaignModel campaign,
    String token,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/campaigns/create"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(campaign.toCreateJson()),
    );

    print("CREATE STATUS: ${response.statusCode}");
    print("CREATE BODY: ${response.body}");

    if (response.statusCode == 201 || response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return CampaignModel.fromJson(decoded['data'] ?? decoded);
    } else {
      throw Exception("Create failed: ${response.body}");
    }
  }

  // ================= UPDATE CAMPAIGN ✅ NEW =================
  static Future<CampaignModel> updateCampaign(
    int id,
    CampaignModel campaign,
    String token,
  ) async {
    final response = await http.patch(
      Uri.parse("$baseUrl/campaigns/$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(campaign.toUpdateJson()),
    );

    print("UPDATE STATUS: ${response.statusCode}");
    print("UPDATE BODY: ${response.body}");

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return CampaignModel.fromJson(decoded['data'] ?? decoded);
    } else {
      throw Exception("Update failed: ${response.body}");
    }
  }

  // ================= DELETE CAMPAIGN ✅ NEW =================
  static Future<void> deleteCampaign(
    int id,
    String token,
  ) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/campaigns/$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    print("DELETE STATUS: ${response.statusCode}");
    print("DELETE BODY: ${response.body}");

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception("Delete failed: ${response.body}");
    }
  }

  // ================= ACTIVATE CAMPAIGN ✅ =================
  static Future<void> activateCampaign(int id, String token) async {
    final response = await http.patch(
      Uri.parse("$baseUrl/campaigns/$id/activate"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"status": "ACTIVE"}),
    );

    print("ACTIVATE STATUS: ${response.statusCode}");
    print("ACTIVATE BODY: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("Activate failed: ${response.body}");
    }
  }

  // ================= CLOSE CAMPAIGN ✅ =================
  static Future<void> closeCampaign(int id, String token) async {
    final response = await http.patch(
      Uri.parse("$baseUrl/campaigns/$id/close"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"status": "CLOSED"}),
    );

    print("CLOSE STATUS: ${response.statusCode}");
    print("CLOSE BODY: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("Close failed: ${response.body}");
    }
  }


}