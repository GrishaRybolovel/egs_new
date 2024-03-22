class Journal {
  int? id;
  int projectId;
  String type;
  double? value;
  String? status;
  DateTime? date;

  Journal({
    this.id,
    required this.projectId,
    required this.type,
    this.value,
    this.status,
    this.date,
  });

  factory Journal.fromJson(Map<String, dynamic> json) {
    return Journal(
      id: json['id'],
      projectId: json['project'],
      type: json['type'],
      value: json['value'],
      status: json['status'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap =  {
      'id': id,
      'project': projectId,
      'type': type,
      'value': value,
      'status': status,
      'date': date?.toIso8601String().substring(0, 10),
    };

    jsonMap.removeWhere((key, value) =>
    (value == null || value.toString().isEmpty) && key != 'cost');

    return jsonMap;
  }
}