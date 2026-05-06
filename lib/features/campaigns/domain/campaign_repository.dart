import 'dart:convert';
import 'package:http/http.dart' as http;

class CampaignRepository {
  final String baseUrl = "http://localhost:3000";

  Future<List<dynamic>> getCampaigns() async {
  final response = await http.get(
    Uri.parse("$baseUrl/campaigns"),
    headers: {
      "Content-Type": "application/json",
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['data'];
  } else {
    throw Exception(response.body);
  }
}
}