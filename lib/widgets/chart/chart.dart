import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visualization_app/models/stepcount.dart';
import 'package:visualization_app/services/rest_api_service.dart';
import 'package:intl/intl.dart';
import 'package:visualization_app/widgets/chart/driver/chart_by_google.dart';

class Chart extends StatefulWidget {
  static List<Stepcount> _createSampleData() {
    final random = math.Random();

    return List<Stepcount>.generate(
      7,
      (index) => Stepcount(
        random.nextInt(15000) + 3000,
        datetime: DateTime.now().subtract(Duration(days: index)),
      ),
    ).reversed.toList();
  }

  factory Chart.withSampleData() {
    //return Chart(_createSampleData());

    return Chart.loadFromQuery('오늘 걸음 수');
  }

  factory Chart.loadFromQuery(query) {
    return Chart(null, query: query);
  }

  final String query;
  final List<Stepcount> data;

  Chart(this.data, {this.query});

  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  Future<List<Stepcount>> _fetch() async {
    var result = await RestApiService.submitMessage(widget.query);

    log(result.toString());

    return result;
  }

  Widget _buildChart(List<Stepcount> data) {
    final dateFormat = DateFormat('yyyy년 M월 d일');
    final caption = dateFormat.format(data.first.datetime) +
        ' ~ ' +
        dateFormat.format(data.last.datetime);

    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(
        caption,
        style: TextStyle(fontSize: 14),
      ),
      SizedBox(height: 10),
      Expanded(child: BarChart(data)),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data != null) return _buildChart(widget.data);

    return FutureBuilder(
      future: _fetch(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            child: SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(),
            ),
            alignment: Alignment.center,
          );
        } else if (snapshot.hasError) {
          return Container(child: Text('Error: ${snapshot.error}'));
        } else {
          return _buildChart(snapshot.data);
        }
      },
    );
  }
}
