import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

class Message {
  int? id;
  String? message;
  int author;
  int task;
  DateTime? created;
  File? doc;
  String? docName;
  String? docBase64;

  Message({
    this.message,
    required this.author,
    required this.task,
    this.created,
    this.doc,
    this.docName,
    this.docBase64,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    File? myDoc;
    if(json['doc'] != null){
      String docPath = json['doc'] as String;
      List<int> docBytes = base64Decode(docPath);
      myDoc = docBytes.isNotEmpty ? File.fromRawPath(Uint8List.fromList(docBytes)) : null;
    }


    return Message(
      message: json['message'],
      author: json['author'],
      task: json['task'],
      created: DateTime.parse(json['created']),
      doc: myDoc,
      docName: Uri.decodeComponent(json['doc_name'].toString()),
    );
  }


  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = {
      'message': message,
      'author': author,
      'task': task,
      'created': created?.toIso8601String(),
      'doc': docBase64,
      'doc_name': docName,
    };

    jsonMap.removeWhere((key, value) => (value == null || value.toString().isEmpty) && key != 'cost');

    return jsonMap;
  }
}