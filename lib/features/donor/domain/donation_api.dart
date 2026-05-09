import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'donation_model.dart';

class DonationApi {
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:3000/api';
    return 'http://10.109.20.26:3000/api';
  }

  // POST /campaigns/:id/donations
  static Future<DonationModel> createDonation({
    required int campaignId,
    required DonationModel donation,
    required String token,
  }) async {
    final url = Uri.parse('$baseUrl/campaigns/$campaignId/donations');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(donation.toJson()),
    );

    final body = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return DonationModel.fromJson(body['data']);
    }

    throw Exception(body['message'] ?? 'Failed to create donation');
  }

  // GET /donations?campaign_id=X
  static Future<List<DonationModel>> getDonationsForCampaign({
    required int campaignId,
    required String token,
  }) async {
    final url = Uri.parse('$baseUrl/donations?campaign_id=$campaignId');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    final body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final List data = body['data'];
      return data.map((e) => DonationModel.fromJson(e)).toList();
    }

    throw Exception(body['message'] ?? 'Failed to load donations');
  }
}