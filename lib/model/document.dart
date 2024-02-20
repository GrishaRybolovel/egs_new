import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:path/path.dart';
import 'dart:io' as io;
import 'dart:typed_data' show Uint8List;
import 'package:flutter/foundation.dart';

class Document {
  int? id;
  String name;
  String? status;
  String? docType;
  DateTime? duration;
  File? doc;
  List<int>? users;
  List<int>? projects;
  String? doc_name;
  String? docBase64;


  Document({
    this.id,
    required this.name,
    this.status,
    this.docType,
    this.duration,
    this.doc,
    this.users,
    this.projects,
    this.docBase64,
    this.doc_name,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    File? myDoc = null;
    if(json['doc'] != null){
      String docPath = json['doc'] as String;
      List<int> docBytes = base64Decode(docPath);
      myDoc = docBytes != null ? File.fromRawPath(Uint8List.fromList(docBytes!)) : null;
    }

    return Document(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      docType: json['doc_type'],
      duration: json['duration'] != null ? DateTime.parse(json['duration']) : null,
      doc: myDoc,
      doc_name: json['doc_name'],
      users: json['users'] != null ? List<int>.from(json['users']) : null,
      projects: json['projects'] != null ? List<int>.from(json['projects']) : null,
    );
  }

  Map<String, dynamic> toJson() {

    Map<String, dynamic> jsonMap = {
      'id': id,
      'name': name,
      'status': status,
      'doc_type': docType,
      'duration': duration?.toIso8601String().substring(0, 10),
      'doc': docBase64,
      'doc_name': doc_name,
      'users': users,
      'projects': projects,
    };

    jsonMap.removeWhere((key, value) => (value == null || value.toString().isEmpty) && key != 'cost');

    return jsonMap;
  }
}