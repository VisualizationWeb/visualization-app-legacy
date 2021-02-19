import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visualization_app/models/stepcount.dart';
import 'package:visualization_app/services/rest_api_service.dart';
import 'package:intl/intl.dart';
import 'package:visualization_app/widgets/chart/driver/chart_by_google.dart';

class FutureChart extends StatefulWidget {
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

  factory FutureChart.withSampleData() {
    return FutureChart.loadFromQuery('오늘 걸음 수');
  }

  factory FutureChart.loadFromQuery(query) {
    return FutureChart(future: RestApiService.submitMessage(query));
  }

  factory FutureChart.loadFromRange({
    DateTimeRange range,
    DateTimeRange comparison,
  }) {
    return FutureChart(future: () async {
      return StepcountResponse(
          data: (await RestApiService.getRange(range.start, range.end)).data,
          compareWith: comparison == null
              ? null
              : (await RestApiService.getRange(
                      comparison.start, comparison.end))
                  .data);
    }());
  }

  final Future<StepcountResponse> future;
  StepcountResponse response;

  FutureChart({this.future});

  @override
  _FutureChartState createState() => _FutureChartState();
}

class _FutureChartState extends State<FutureChart> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.future,
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
          widget.response = snapshot.data;

          return Chart(
            data: widget.response.data,
            compareWith: widget.response.compareWith,
          );
        }
      },
    );
  }
}

class Chart extends StatelessWidget {
  final List<Stepcount> data;
  final List<Stepcount> compareWith;

  Chart({this.data, this.compareWith});

  @override
  Widget build(BuildContext context) {
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
      Expanded(
        child: BarChart(
          data: data,
          compareWith: compareWith,
        ),
      ),
    ]);
  }
}
