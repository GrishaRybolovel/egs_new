import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

class Message {
  int? id;
  String? message;
  int author;
  int? task;
  int? mail;
  DateTime? created;
  File? doc;
  String? docName;
  String? docBase64;

  Message({
    this.message,
    required this.author,
    this.task,
    this.mail,
    this.created,
    this.doc,
    this.docName,
    this.docBase64,
  });

  factory Message.fromJson(Map<String, dynamic> json) {

    return Message(
      message: json['message'],
      author: json['author'],
      task: json['task'],
      mail: json['mail'],
      created: DateTime.parse(json['created']),
      docName: Uri.decodeComponent(json['doc_name'].toString()),
    );
  }


  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = {
      'message': message,
      'author': author,
      'task': task,
      'mail': mail,
      'created': created?.toIso8601String(),
      'doc': docBase64,
      'doc_name': docName,
    };

    jsonMap.removeWhere((key, value) => (value == null || value.toString().isEmpty) && key != 'cost');

    return jsonMap;
  }
}