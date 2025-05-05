import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:photo_beza_gallery/constant/constant.dart';
import 'package:http/http.dart' as http;

class ImageService {
 image(){
  
 }
  Future<List<dynamic>> fetchImages() async {
    final response = await http.get(Uri.parse('$baseUrl/images'));

    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      if (kDebugMode) {
        print("all images: $result");
      }
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load images');
    }
  }
  Future<Map<String, dynamic>> fetchImageById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/images/$id'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load image');
    }
  }

  Future<List<dynamic>> searchImages(String query) async {
  final response = await http.get(Uri.parse('$baseUrl/images/$query'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to search images');
    }
  }
  Future<void> uploadImage(Map<String, dynamic> imageData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/images'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(imageData),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to upload image');
    }
  }

  Future<void> updateImage(String id, Map<String, dynamic> imageData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/images/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(imageData),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update image');
    }
  }

  // Fetch images by phone number
  Future<List<dynamic>> fetchImagesByPhone(String phone) async {
    final response = await http.get(Uri.parse('$baseUrl/images/phone/$phone'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load images for phone: $phone');
    }
  }

  // Fetch images by status
  Future<List<dynamic>> fetchImagesByStatus(String status) async {
    final response = await http.get(Uri.parse('$baseUrl/status/$status'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load images for phone: $status');
    }
  }
}


