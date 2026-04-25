import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:reliefnet/features/campaigns/domain/campaign_model.dart';

class CampaignApi {
  static const String baseUrl = "http://localhost:3000"; // change later

  static Future<Map<String, dynamic>> createCampaign(
      CampaignModel campaign) async {
    final response = await http.post(
      Uri.parse("$baseUrl/campaigns/create"),
      headers: {
        "Content-Type": "application/json",
        // "Authorization": "Bearer TOKEN" (later)
      },
      body: jsonEncode(campaign.toJson()),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception(response.body);
    }
  }
}