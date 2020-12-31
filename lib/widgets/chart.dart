import 'dart:math';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:health_vis/models/health_step.dart';

class HealthStepBarChart extends StatelessWidget {
  final List<charts.Series<HealthStep, String>> seriesList;

  static const _goal = 8000;

  HealthStepBarChart(List<HealthStep> steps)
      : seriesList = [
          charts.Series<HealthStep, String>(
            id: 'Step Data',
            colorFn: (step, __) => step.value < _goal
                ? charts.Color.fromHex(code: '#B7B7B7')
                : charts.Color.fromHex(code: '#FAB299'),
            domainFn: (HealthStep data, _) => data.datetime.day.toString(),
            measureFn: (HealthStep data, _) => data.value,
            data: steps,
          )
        ];

  static List<HealthStep> _createSampleData() {
    // var random = Random();
    // final data = List<int>.generate(4, (i) => i + 1)
    //     .map((i) => StepData(
    //         DateTime.now().subtract(Duration(days: i)).toString(), random.nextInt(200)))
    //     .toList();

    final random = Random();

    return List<HealthStep>.generate(
        7,
        (index) => HealthStep(
              random.nextInt(6000) + 6000,
              datetime: DateTime.now().subtract(Duration(days: index)),
            ));
  }

  factory HealthStepBarChart.withSampleData() {
    return HealthStepBarChart(_createSampleData());
  }

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      seriesList,
      animate: false,
      defaultInteractions: true,
      behaviors: [
        charts.RangeAnnotation([
          charts.RangeAnnotationSegment(
            0,
            _goal,
            charts.RangeAnnotationAxisType.measure,
            endLabel: '목표',
            color: charts.Color.fromHex(code: '#FEF1ED'),
            labelAnchor: charts.AnnotationLabelAnchor.start,
          )
        ], defaultLabelPosition: charts.AnnotationLabelPosition.margin)
      ],
    );
  }
}
