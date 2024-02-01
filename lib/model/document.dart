class Document {
  int? id;
  String? name;
  String? status;
  String? docType;
  DateTime? duration;
  String? doc;
  List<int>? users;
  List<int>? projects;

  Document({
    this.id,
    this.name,
    this.status,
    this.docType,
    this.duration,
    this.doc,
    this.users,
    this.projects,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      docType: json['doc_type'],
      duration: json['duration'] != null ? DateTime.parse(json['duration']) : null,
      doc: json['doc'],
      users: json['users'] != null ? List<int>.from(json['users']) : null,
      projects: json['projects'] != null ? List<int>.from(json['projects']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'doc_type': docType,
      'duration': duration?.toIso8601String(),
      'doc': doc,
      'users': users,
      'projects': projects,
    };
  }
}