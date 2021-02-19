import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/src/text_style.dart' as chartStyle;
import 'package:charts_flutter/src/text_element.dart' as chartText;
import 'package:flutter/material.dart';
import 'package:visualization_app/models/stepcount.dart';

class ChartSelection {
  static Stepcount datum;
}

class BarChart extends StatelessWidget {
  final List<charts.Series<Stepcount, DateTime>> seriesList;
  final List<Stepcount> data;
  final bool includeComparison;

  static const _goal = 8000;

  BarChart({this.data, List<Stepcount> compareWith})
      : seriesList = [
          charts.Series<Stepcount, DateTime>(
            id: 'Stepcount',
            colorFn: compareWith == null
                ? ((step, _) => step.value < _goal
                    ? charts.Color.fromHex(code: '#B7B7B7')
                    : charts.Color.fromHex(code: '#FAB299'))
                : ((step, _) => charts.Color.fromHex(code: '#FAB299')),
            domainFn: (Stepcount data, _) => data.datetime,
            measureFn: (Stepcount data, _) => data.value,
            data: data,
          ),
          compareWith == null
              ? null
              : charts.Series<Stepcount, DateTime>(
                  id: 'Stepcount_compare',
                  colorFn: (step, _) => charts.Color.fromHex(code: '#B7B7B7'),
                  domainFn: (_, index) => data[index].datetime,
                  measureFn: (Stepcount data, _) => data.value,
                  // compareWith data may out of range
                  data: compareWith.getRange(0, data.length).toList(),
                ),
        ].where((series) => series != null).toList(),
        includeComparison = compareWith != null;

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      seriesList,
      animate: true,
      defaultInteractions: true,
      defaultRenderer: includeComparison
          ? charts.LineRendererConfig<DateTime>(
              includePoints: true,
              strokeWidthPx: 2,
            )
          : charts.BarRendererConfig<DateTime>(),
      primaryMeasureAxis: charts.NumericAxisSpec(
        renderSpec: charts.GridlineRendererSpec(
          labelAnchor: charts.TickLabelAnchor.after,
          labelJustification: charts.TickLabelJustification.outside,
        ),
      ),
      domainAxis: charts.DateTimeAxisSpec(
        showAxisLine: false,
      ),
      behaviors: [
        charts.DomainHighlighter(),
        charts.RangeAnnotation(
          [
            charts.RangeAnnotationSegment(
              0,
              _goal,
              charts.RangeAnnotationAxisType.measure,
              color: charts.Color.fromHex(code: '#FEF1ED'),
            )
          ],
          defaultLabelPosition: charts.AnnotationLabelPosition.margin,
        ),
        charts.LinePointHighlighter(
          symbolRenderer: charts.CircleSymbolRenderer(),
          defaultRadiusPx: 0,
        ),
        charts.SelectNearest(eventTrigger: charts.SelectionTrigger.tapAndDrag),
      ],
      selectionModels: [
        charts.SelectionModelConfig(
          changedListener: (charts.SelectionModel model) {
            if (model.hasDatumSelection) {
              ChartSelection.datum = model.selectedDatum[0].datum;
            }
          },
        ),
      ],
    );
  }
}
