import 'dart:convert';
import 'dart:developer';

import 'package:health_vis/models/health_step.dart';
import 'package:http/http.dart' as http;

class RestApiService {
  static Future<List<HealthStep>> submitMessage(String message) async {
    http.Response response = await http.post(
        Uri.encodeFull('http://192.168.0.102:8000/chat_service/'),
        headers: {'Accept': 'application/json'},
        body: {'input1': message});

    if (response.statusCode == 200) {
      log(response.body);

      final data = json.decode(response.body);

      List<int> xValues = List<int>.from(data['xValues']);
      List<int> yValues = List<int>.from(data['yValues']);

      DateTime Function(int) xValuesConstructor = (x) => DateTime(x);
      switch (data['label']) {
        case '1':
        case '4':
        case '5':
        case '12':
          xValuesConstructor =
              (x) => DateTime(DateTime.now().year, DateTime.now().month - 1, x);
          break;
      }

      return xValues
          .asMap()
          .map((index, x) => MapEntry(index,
              HealthStep(yValues[index], datetime: xValuesConstructor(x))))
          .values
          .toList();
    } else {
      throw Exception('Failed to load post');
    }
  }
}
