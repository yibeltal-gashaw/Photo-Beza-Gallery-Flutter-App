import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class Upload {
    final cloudinaryUrl = 'https://api.cloudinary.com/v1_1/dyzeb4vxu/image/upload';
final preset = 'Asset-Registry';

Future<List<String>> imagesToCloudinary(List<File> images) async {

  List<String> uploadedUrls = [];

  try {
    // Use Future.wait to upload all images concurrently
    final uploadTasks = images.map<Future<String>>((image) async {
      final request = http.MultipartRequest('POST', Uri.parse(cloudinaryUrl))
        ..fields['upload_preset'] = preset
        ..files.add(await http.MultipartFile.fromPath('file', image.path));

      final response = await request.send();
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final data = jsonDecode(responseBody);
        return data['secure_url']; // Extract the secure URL
      } else {
        throw Exception('Failed to upload image: ${response.statusCode}');
      }
    });

    // Wait for all uploads to complete
    uploadedUrls = await Future.wait(uploadTasks);
    print(uploadedUrls);
  } catch (e) {
    print('Error uploading images: $e');
  }

  return uploadedUrls; // Return the list of uploaded image URLs
}
}