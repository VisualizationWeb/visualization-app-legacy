import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:visualization_app/widgets/chart/chart.dart';

class ButtonfulFrame extends StatefulWidget {
  @override
  _ButtonfulFrameState createState() => _ButtonfulFrameState();
}

class Range {
  final String label;
  final DateTimeRange range;

  DateTimeRange get comparison {
    return DateTimeRange(
      start: range.start
          .subtract(range.end.difference(range.start))
          .subtract(Duration(days: 1)),
      end: range.start.subtract(Duration(days: 1)),
    );
  }

  const Range({this.label, this.range});
}

class _ButtonfulFrameState extends State<ButtonfulFrame> {
  static final ranges = [
    Range(
      label: '일주일',
      range: DateTimeRange(
        start: DateTime.now().subtract(Duration(days: 6)),
        end: DateTime.now(),
      ),
    ),
    Range(
      label: '1개월',
      range: DateTimeRange(
        start: DateTime(
            DateTime.now().year, DateTime.now().month - 1, DateTime.now().day),
        end: DateTime.now(),
      ),
    ),
    Range(
      label: '6개월',
      range: DateTimeRange(
        start: DateTime(
            DateTime.now().year, DateTime.now().month - 6, DateTime.now().day),
        end: DateTime.now(),
      ),
    ),
    Range(
      label: '1년',
      range: DateTimeRange(
        start: DateTime(
            DateTime.now().year - 1, DateTime.now().month, DateTime.now().day),
        end: DateTime.now(),
      ),
    ),
  ];

  final _isSelected = ranges.map((range) => false).toList()..[0] = true;
  bool _isCustomRange = false;
  bool _enableComparison = false;
  var _range = ranges[0];

  void _handleSelectionChange(int index) {
    // toggle is not allowed, else select another
    if (_isSelected[index]) return;

    setState(() {
      _isCustomRange = false;
      _isSelected.fillRange(0, _isSelected.length, false);
      _isSelected[index] = true;

      _range = ranges[index];
    });
  }

  void _handleCustomRangeClick() async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2018),
      lastDate: DateTime(2025),
    );

    if (range == null) return;

    log('User selected date range=' + range.toString());

    setState(() {
      _isSelected.fillRange(0, _isSelected.length, false);
      _isCustomRange = true;

      _range = Range(range: range);
    });
  }

  Widget _buildToggleButton(Widget child) {
    return Container(
      alignment: Alignment.center,
      width: 70,
      child: child,
    );
  }

  Widget _wrapToggleButtons(Widget toggleButtons) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          style: BorderStyle.solid,
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      height: 45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: toggleButtons,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(height: 30),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _wrapToggleButtons(ToggleButtons(
            children: ranges
                .map((range) => _buildToggleButton(Text(range.label)))
                .toList(),
            isSelected: _isSelected,
            onPressed: _handleSelectionChange,
          )),
          SizedBox(width: 15),
          _wrapToggleButtons(ToggleButtons(
            children: [_buildToggleButton(Icon(Icons.calendar_today_outlined))],
            isSelected: [_isCustomRange],
            onPressed: (_) => _handleCustomRangeClick(),
          ))
        ],
      ),
      SizedBox(height: 10),
      CheckboxListTile(
        title: Text(
            _range.label == null ? '이전 데이터와 비교' : '지난 ${_range.label}과 비교'),
        value: _enableComparison,
        onChanged: (value) => setState(() {
          _enableComparison = value;
        }),
        controlAffinity: ListTileControlAffinity.leading,
      ),
      SizedBox(height: 10),
      SizedBox(
        height: 400,
        child: FutureChart.loadFromRange(
          range: _range.range,
          comparison: _enableComparison ? _range.comparison : null,
        ),
      ),
    ]);
  }
}
