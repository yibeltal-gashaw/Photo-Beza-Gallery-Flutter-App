import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:photo_beza_gallery/constant/constant.dart';

class AppImageProvider with ChangeNotifier {
  bool isLoading = false;
  List<ImageModel> imagesList = [];

  Future<void> fetchImagesByPhone(String phone) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('$baseUrl/images/phone/$phone'));

      if (response.statusCode == 200) {
        // Parse the response body and decode it correctly
        final List<dynamic> data = jsonDecode(response.body);
        
        // Convert the decoded data into ImageModel objects
        imagesList = data.map((item) => ImageModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load images');
      }
    } catch (error) {
      throw Exception('Error fetching images: $error');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

class ImageModel {
  final String id;
  final String imageUrl;
  final String ocassion;
  final String phone;
  final String status;
  final DateTime uploadDate;

  ImageModel({
    required this.id,
    required this.imageUrl,
    required this.ocassion,
    required this.phone,
    required this.uploadDate,
    required this.status
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['_id'],
      imageUrl: json['imageUrl'],
      ocassion: json['ocassion'] ?? json['occasion'],  // Handle possible key variations
      phone: json['phone'],
      status: json['status'],
      uploadDate: DateTime.parse(json['uploadDate']),
    );
  }

  @override
  String toString() {
    return 'ImageModel(id: $id, imageUrl: $imageUrl, ocassion: $ocassion, phone: $phone, status: $status, uploadDate: $uploadDate)';
  }
}
