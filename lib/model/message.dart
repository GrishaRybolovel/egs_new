import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:path/path.dart';
import 'dart:io' as io;
import 'dart:typed_data' show Uint8List;
import 'package:flutter/foundation.dart';

class Message {
  int? id;
  String? message;
  int author;
  int task;
  DateTime? created;
  File? doc;
  String? doc_name;
  String? docBase64;

  Message({
    this.message,
    required this.author,
    required this.task,
    this.created,
    this.doc,
    this.doc_name,
    this.docBase64,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    File? myDoc = null;
    if(json['doc'] != null){
      String docPath = json['doc'] as String;
      List<int> docBytes = base64Decode(docPath);
      myDoc = docBytes != null ? File.fromRawPath(Uint8List.fromList(docBytes!)) : null;
    }


    return Message(
      message: json['message'],
      author: json['author'],
      task: json['task'],
      created: DateTime.parse(json['created']),
      doc: myDoc,
      doc_name: json['doc_name'],
    );
  }

  Future<List<int>> _readFileBytes(File file) async {
    if (kIsWeb) {
      // On the web, use the bytes property to access the file content
      return await file.readAsBytes();
    } else {
      // On mobile or desktop, use the readAsBytes method
      return file.readAsBytesSync();
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = {
      'message': message,
      'author': author,
      'task': task,
      'created': created != null ? created!.toIso8601String() : null,
      'doc': docBase64,
      'doc_name': doc_name,
    };

    jsonMap.removeWhere((key, value) => (value == null || value.toString().isEmpty) && key != 'cost');

    return jsonMap;
  }
}