import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;


Future<String> google_translate({required String text, required String languageIsoCode }) async {
  try {
    print('구글번역할 텍스트: $text');

    /// api key(trans.)
    String apiKey = '';
    // String languageIsoCode = 'ko';

    if (apiKey.isNotEmpty) {
      final url = Uri.parse(
          'https://translation.googleapis.com/language/translate/v2?key=$apiKey');
      final body = {
        'q': text,
        'target': languageIsoCode,
      };

      final response = await http.post(url, body: body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        String result = data['data']['translations'][0]['translatedText'];
        return result;
      } else {
        Get.snackbar(
          '구글번역 API 오류',
          'Status: ${response.statusCode}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(8),
        );
        throw Exception('Failed to translate text.');
      }
    } else {
      return '';
    }
  } catch (e) {
    Get.snackbar(
      '구글번역 API 오류',
      'Status: ${e.toString()}',
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(8),
    );
    return '';
  }
}
