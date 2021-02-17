import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:visualization_app/models/stepcount.dart';

class RestApiService {
  static Future<List<Stepcount>> submitMessage(String message) async {
    http.Response response = await http.post(
        Uri.encodeFull('http://192.168.0.102:8000/chat_service/'),
        headers: {'Accept': 'application/json'},
        body: {'input1': message});

    if (response.statusCode == 200) {
      log(response.body);

      final parsed = Map<String, dynamic>.from(json.decode(response.body));

      return List<dynamic>.from(parsed['data'])
          .map<Stepcount>((json) => Stepcount.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load post');
    }
  }
}
