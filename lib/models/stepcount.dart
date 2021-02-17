class Stepcount {
  final DateTime datetime;
  final int value;

  Stepcount(this.value, {DateTime datetime})
      : datetime = datetime ?? DateTime.now();

  factory Stepcount.fromJson(Map<String, dynamic> json) {
    return Stepcount(json['stepcount'],
        datetime: DateTime.fromMillisecondsSinceEpoch(json['date']));
  }
}
