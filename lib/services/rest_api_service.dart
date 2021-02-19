import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:visualization_app/models/stepcount.dart';

class StepcountResponse {
  final List<Stepcount> data;
  final List<Stepcount> compareWith;
  final String message;

  StepcountResponse({@required this.data, this.compareWith, this.message});
}

class RestApiService {
  static List<Stepcount> parse(dynamic raw) {
    return List<dynamic>.from(raw)
        .map<Stepcount>((json) => Stepcount.fromJson(json))
        .toList();
  }

  static Future<StepcountResponse> submitMessage(String message) async {
    http.Response response = await http.post(
        Uri.encodeFull('http://192.168.0.102:8000/chat_service/'),
        headers: {'Accept': 'application/json'},
        body: {'input1': message});

    if (response.statusCode != 200) throw Exception('Failed to load post');

    final parsed = Map<String, dynamic>.from(json.decode(response.body));

    return StepcountResponse(
      data: parse(parsed['data']),
      compareWith:
          parsed['compare_with'] == null ? null : parse(parsed['compare_with']),
      message: '차트가 출력되었습니다',
    );
  }

  static Future<StepcountResponse> getRange(
      DateTime begin, DateTime end) async {
    final format = DateFormat('yyyy-MM-dd');

    http.Response response = await http.get(
      Uri.encodeFull(
          'http://192.168.0.102:8000/get_stepcount/?begin=${format.format(begin)}&end=${format.format(end)}'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode != 200) throw Exception('Failed to load');

    log(response.body);

    final parsed = Map<String, dynamic>.from(json.decode(response.body));

    return StepcountResponse(
      data: parse(parsed['data']),
      message: '차트가 출력되었습니다',
    );
  }
}
