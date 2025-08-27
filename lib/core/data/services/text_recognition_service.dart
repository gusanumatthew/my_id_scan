import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:myid_scan/view/home/model/business_card_model.dart';

class TextRecognitionService {
  final TextRecognizer _textRecognizer = TextRecognizer();

  Future<String> extractTextFromImage(String imagePath) async {
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final RecognizedText recognizedText =
          await _textRecognizer.processImage(inputImage);
      return recognizedText.text;
    } catch (e) {
      throw 'Failed to extract text: $e';
    }
  }

  Future<BusinessCardData> scanBusinessCard(String imagePath) async {
    try {
      final text = await extractTextFromImage(imagePath);
      return BusinessCardData.fromText(text);
    } catch (e) {
      throw 'Failed to scan business card: $e';
    }
  }

  void dispose() {
    _textRecognizer.close();
  }
}
