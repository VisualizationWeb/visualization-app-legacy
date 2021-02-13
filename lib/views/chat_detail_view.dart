import 'package:flutter/material.dart';
import 'package:visualization_app/widgets/chart.dart';

class ChartView extends StatelessWidget {
  final Widget detail;

  ChartView({Key key, @required this.detail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chart view')),
      body: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Column(children: [SizedBox(height: 400, child: detail)])),
    );
  }
}
