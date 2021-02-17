import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:visualization_app/models/message.dart';
import 'package:visualization_app/widgets/chart/chart.dart';
import 'package:visualization_app/widgets/chat_box.dart';
import 'package:visualization_app/widgets/sliding_up.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ChatFrame extends StatefulWidget {
  @override
  _ChatFrameState createState() => _ChatFrameState();
}

class _ChatFrameState extends State<ChatFrame> {
  final _history = <Message>[
    Message('Tip: 궁금한 정보를 물어보세요.\n  예) 오늘 걸음 수 보여줘\n  예) 한달 간 걸음 수 보여줘',
        sendByMe: true),
    Message('Tip: 그래프는 이렇게 표시됩니다.',
        sendByMe: false, additionalWidget: Chart.withSampleData())
  ];
  final _controller = PanelController();

  void _sendChat(Message message) {
    setState(() {
      _controller.animatePanelToPosition(1.0);

      _history.add(message);
      _history.add(Message('결과입니다',
          additionalWidget: Chart.loadFromQuery(message.value)));
    });
  }

  void _onListening(String message) {
    setState(() {
      _history.removeLast();
      _history.add(Message(message, sendByMe: true));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        child: Stack(children: [
          ListView(
            padding: const EdgeInsets.only(bottom: 60),
            shrinkWrap: true,
            children: _history
                .take(_history.length - 2)
                .map((message) => ChatBox(message))
                .toList(),
          ),
          SlidingUp(
            controller: _controller,
            panel: Column(
              children: _history
                  .skip(_history.length - 2)
                  .take(2)
                  .map((message) => ChatBox(message))
                  .toList(),
            ),
          ),
        ]),
      ),
      ChatInput(
        onSend: _sendChat,
        onListening: _onListening,
      ),
    ]);
  }
}

class ChatInput extends StatefulWidget {
  final void Function(Message) onSend;
  final void Function(String) onListening;

  ChatInput({Key key, this.onSend, this.onListening}) : super(key: key);

  @override
  _ChatInputState createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final textEditingController = TextEditingController();

  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _listening = false;
  String _recognizedWords;

  void _onSpeech() async {
    final available = await _speech.initialize();

    if (!available) return;

    if (!_listening) {
      log('Listening user speech ...');

      _speech.listen(onResult: (result) {
        log('User speech: ' + result.recognizedWords);

        _recognizedWords = result.recognizedWords;

        //widget.onListening(_recognizedWords);
      });
    } else {
      log('Stopped listening');
      log('User says: ' + _recognizedWords);
      _speech.stop();

      widget.onSend(Message(_recognizedWords, sendByMe: true));

      _recognizedWords = null;
    }

    setState(() {
      _listening = !_listening;
    });
  }

  void _onSend() {
    if (textEditingController.text.isEmpty) return;

    widget.onSend(Message(textEditingController.text, sendByMe: true));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFD9D9D9)),
          color: Colors.white,
        ),
        child: Row(children: [
          SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: textEditingController,
              decoration: InputDecoration(
                  hintText: '메세지를 입력하세요',
                  hintStyle: TextStyle(color: Colors.white, fontSize: 20),
                  border: InputBorder.none),
              onSubmitted: (value) => _onSend(),
            ),
          ),
          SizedBox(width: 16),
          SizedBox(
            width: 50,
            child: Container(
              color: _listening ? Colors.red : Colors.grey,
              child: IconButton(
                color: Colors.white,
                icon: Icon(Icons.mic),
                onPressed: _onSpeech,
              ),
            ),
          ),
          SizedBox(
            width: 50,
            child: Container(
              color: Color(0xFFFAB299),
              child: IconButton(
                color: Colors.white,
                icon: Icon(Icons.send),
                onPressed: _onSend,
              ),
            ),
          ),
        ]));
  }
}
