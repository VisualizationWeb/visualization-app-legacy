import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:health_vis/models/message.dart';
import 'package:health_vis/services/rest_api_service.dart';
import 'package:health_vis/widgets/chart.dart';
import 'package:health_vis/widgets/chat_box.dart';
import 'package:health_vis/widgets/sliding_up.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ChatView extends StatefulWidget {
  @override
  ChatViewState createState() => ChatViewState();
}

class ChatViewState extends State<ChatView> {
  final _history = <Message>[
    Message('Tip: 궁금한 정보를 물어보세요.\n  예) 오늘 걸음 수 보여줘\n  예) 한달 간 걸음 수 보여줘',
        sendByMe: true),
    Message('Tip: 그래프는 이렇게 표시됩니다.',
        sendByMe: false, additionalWidget: HealthStepBarChart.withSampleData())
  ];
  final _controller = PanelController();

  void _sendChat(Message message) {
    setState(() {
      _controller.animatePanelToPosition(1.0);

      _history.add(message);
      _history.add(Message('잠시만요...'));
    });

    RestApiService.submitMessage(message.value).then((steps) {
      log(steps.map((step) => step.value).join(', '));

      setState(() {
        _history.removeLast();
        _history.add(Message('그래프가 출력되었습니다',
            additionalWidget: HealthStepBarChart(steps)));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Health Vis Chat')),
        body: Column(children: [
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
          ])),
          ChatInput(onSend: _sendChat)
        ]));
  }
}

class ChatInput extends StatelessWidget {
  final TextEditingController textEditingController =
      new TextEditingController();
  final void Function(Message) onSend;

  ChatInput({this.onSend});

  void _invokeSend() {
    if (textEditingController.text.isNotEmpty) {
      onSend(Message(textEditingController.text, sendByMe: true));
    }
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
                  onSubmitted: (value) {
                    _invokeSend();
                  })),
          SizedBox(width: 16),
          SizedBox(
            width: 50,
            child: Container(
                color: Color(0xFFFAB299),
                child: IconButton(
                  color: Colors.white,
                  icon: Icon(Icons.send),
                  onPressed: _invokeSend,
                )),
          )
        ]));
  }
}
