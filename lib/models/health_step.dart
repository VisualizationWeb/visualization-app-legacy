import 'dart:developer';

class HealthStep {
  final DateTime datetime;
  final int value;

  HealthStep(this.value, {DateTime datetime})
      : datetime = datetime ?? DateTime.now();
}

class HealthSteps {
  final List<HealthStep> values;

  HealthSteps(this.values);

  factory HealthSteps.fromJson(Map<String, dynamic> json) {
    List<int> xValues = List<int>.from(json['xValues']);
    List<int> yValues = List<int>.from(json['yValues']);

    final values = xValues
        .asMap()
        .map((index, x) =>
            MapEntry(index, HealthStep(yValues[index], datetime: DateTime(x))))
        .values
        .toList();

    return HealthSteps(values);
  }
}
