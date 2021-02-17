import 'package:flutter/material.dart';
import 'package:visualization_app/models/message.dart';

class ChatBox extends StatelessWidget {
  //static const _boxColorBlueGradiant = LinearGradient(
  //    colors: [const Color(0xFF007EF4), const Color(0xFF2A75BC)]);
  static const _boxColorWhite = const Color(0xFFEFEFEF);
  static const _boxColorMain = const Color(0xFF956C5E);

  final Message message;

  ChatBox(this.message);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(
            top: 8,
            bottom: 8,
            left: message.sendByMe ? 0 : 10,
            right: message.sendByMe ? 10 : 0),
        alignment:
            message.sendByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
            margin: message.sendByMe
                ? EdgeInsets.only(left: 30)
                : EdgeInsets.only(right: 30),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft:
                        message.sendByMe ? Radius.circular(23) : Radius.zero,
                    bottomRight:
                        message.sendByMe ? Radius.zero : Radius.circular(23)),
                color: message.sendByMe ? _boxColorMain : _boxColorWhite),
            child: Container(
                child: Column(
              children: [
                Text(message.value,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color:
                            message.sendByMe ? _boxColorWhite : _boxColorMain,
                        fontSize: 16,
                        fontWeight: FontWeight.w300)),
                message.additionalWidget != null
                    ? SizedBox(
                        width: 320,
                        height: 300,
                        child: ChatAdditionalWidget(
                          tag: message,
                          child: message.additionalWidget,
                        ),
                      )
                    : null
              ].where((child) => child != null).toList(),
            ))));
  }
}

class ChatAdditionalWidget extends StatelessWidget {
  final Object tag;
  final Widget child;

  ChatAdditionalWidget({this.tag, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: Colors.white,
      ),
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: child,
    );
  }
}
