import 'dart:math';

import 'package:english_words/english_words.dart';
import 'package:flutter/cupertino.dart';

class Message {
  final DateTime datetime;
  final String value;
  final bool sendByMe;

  Widget additionalWidget;

  Message(this.value,
      {this.sendByMe = false, DateTime datetime, this.additionalWidget})
      : datetime = datetime ?? DateTime.now();

  factory Message.random() {
    final random = Random();

    return Message(WordPair.random().join(' '), sendByMe: random.nextBool());
  }

  @override
  String toString() {
    return value;
  }
}
