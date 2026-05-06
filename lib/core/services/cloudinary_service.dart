import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';

class CloudinaryService {
  // ================= CONFIG =================
  static const String _cloudName   = 'dnesfofel';
  static const String _uploadPreset = 'reliefnet_upload';
  static const String _uploadUrl =
      'https://api.cloudinary.com/v1_1/dnesfofel/image/upload';

  // ================= UPLOAD IMAGE =================
  static Future<String?> uploadImage(File imageFile) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse(_uploadUrl));

      // ✅ Add upload preset (unsigned)
      request.fields['upload_preset'] = _uploadPreset;

      // ✅ Add image file
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          imageFile.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );

      print("Uploading to Cloudinary...");

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print("CLOUDINARY STATUS: ${response.statusCode}");
      print("CLOUDINARY BODY: $responseBody");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(responseBody);
        final imageUrl = decoded['secure_url'] as String;
        print("UPLOADED URL: $imageUrl");
        return imageUrl;
      } else {
        print("Upload failed: $responseBody");
        return null;
      }
    } catch (e) {
      print("Cloudinary error: $e");
      return null;
    }
  }

  // ================= UPLOAD FROM WEB (bytes) =================
  static Future<String?> uploadImageBytes(
    List<int> bytes,
    String fileName,
  ) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse(_uploadUrl));

      request.fields['upload_preset'] = _uploadPreset;

      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: fileName,
          contentType: MediaType('image', 'jpeg'),
        ),
      );

      print("Uploading bytes to Cloudinary...");

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print("CLOUDINARY STATUS: ${response.statusCode}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(responseBody);
        return decoded['secure_url'] as String;
      } else {
        print("Upload failed: $responseBody");
        return null;
      }
    } catch (e) {
      print("Cloudinary bytes error: $e");
      return null;
    }
  }
}