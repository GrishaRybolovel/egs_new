import 'package:egs/model/user.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'dart:typed_data' show Uint8List;
import 'package:flutter/foundation.dart';

class Task {
  int? id;
  String name;
  String? description;
  int authorId;
  DateTime? created;
  DateTime? completion;
  DateTime? done;
  int? projectId;
  List<int>? taskToUserIds;
  String? docName;
  String? docBase64;
  File? doc;

  Task({
    this.id,
    required this.name,
    this.description,
    required this.authorId,
    this.created,
    this.completion,
    this.done,
    this.doc,
    this.projectId,
    this.taskToUserIds,
    this.docBase64,
    this.docName,
  });

  factory Task.fromJson(Map<String, dynamic> json) {

    DateTime? done;
    DateTime? completion;
    File? myDoc;
    if(json['doc'] != null){
      String docPath = json['doc'] as String;
      List<int> docBytes = base64Decode(docPath);
      myDoc = docBytes.isNotEmpty ? File.fromRawPath(Uint8List.fromList(docBytes)) : null;
    }

    if (json['done'] != null) {
      try {
        done = DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['done']);
      } catch (e) {
        done = null;
      }
    }
    if (json['completion'] != null){
      try{
        completion = DateTime.parse(json['completion']);
      } catch (e) {
        completion = null;
      }
    }
    Task myNewTask = Task(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      authorId: json['author'],
      created: DateTime.parse(json['created']),
      completion: completion,
      done: done,
      doc: myDoc,
      docName: json['doc_name'],
      projectId: json['project'],
      taskToUserIds: json['task_to_user'] != null ? List<int>.from(json['task_to_user']) : null,
    );
    return myNewTask;
  }

  Map<String, dynamic> toJson() {
    print(completion);
    Map<String, dynamic> jsonMap = {
      'id': id,
      'name': name,
      'description': description,
      'author': authorId,
      'created': created?.toIso8601String(),
      'completion': completion?.toIso8601String().substring(0, 10),
      'done': done?.toIso8601String(),
      'project': projectId,
      'task_to_user': taskToUserIds,
      'doc': docBase64,
      'doc_name': docName,
    };

    jsonMap.removeWhere((key, value) =>
    (value == null || value.toString().isEmpty));
    return jsonMap;
  }
}