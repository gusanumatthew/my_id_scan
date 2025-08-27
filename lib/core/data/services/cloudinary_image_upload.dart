import 'package:dio/dio.dart';
import 'package:myid_scan/core/utils/api_keys.dart';
import 'package:myid_scan/core/utils/failure.dart';

class CloudinaryImageUploader {
  Future<String> uploadImage(String imagePath) async {
    try {
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(imagePath),
        'upload_preset': ApiKeys.uploadPreset,
        'folder': 'card_images',
      });

      final dio = Dio();
      final response = await dio.post(
        'https://api.cloudinary.com/v1_1/${ApiKeys.cloudName}/image/upload',
        data: formData,
      );

      if (response.statusCode == 200) {
        return response.data['secure_url'];
      } else {
        throw Failure('Upload failed');
      }
    } catch (e) {
      throw Failure('Failed to upload image: $e');
    }
  }
}
