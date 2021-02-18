import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:visualization_app/widgets/chart/chart.dart';

class ButtonfulFrame extends StatefulWidget {
  @override
  _ButtonfulFrameState createState() => _ButtonfulFrameState();
}

class Range {
  final String label;
  final String query;

  const Range({this.label, this.query});
}

class _ButtonfulFrameState extends State<ButtonfulFrame> {
  static const ranges = [
    Range(label: '일주일', query: '오늘 걸음 수'),
    Range(label: '1개월', query: '일주일 걸음 수'),
    Range(label: '6개월', query: '6개월 걸음 수'),
    Range(label: '1년', query: '1년 걸음 수'),
  ];

  final _isSelected = ranges.map((range) => false).toList();
  String _query;

  void _handleSelectionChange(int index) {
    // toggle is not allowed, else select another
    if (_isSelected[index]) return;

    setState(() {
      _isSelected.fillRange(0, _isSelected.length, false);
      _isSelected[index] = true;

      _query = ranges[index].query;
    });
  }

  void _handleCustomRangeClick() async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2018),
      lastDate: DateTime(2025),
    );
    log('User selected date range=' + range.toString());

    setState(() {
      _isSelected.fillRange(0, _isSelected.length, false);
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
            isSelected: [false],
            onPressed: (_) => _handleCustomRangeClick(),
          ))
        ],
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
        child: SizedBox(
          height: 400,
          child: _query == null
              ? Chart.withSampleData()
              : Chart.loadFromQuery(_query),
        ),
      ),
    ]);
  }
}
