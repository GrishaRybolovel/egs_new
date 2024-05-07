import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

class Mail {
  int? id;
  String name;
  String? description;
  DateTime? completion;
  String? naming;
  String? numberout;
  DateTime? completionout;
  String? numberin;
  DateTime? completionin;
  String? func;
  int? mailToProject;


  DateTime? created;
  DateTime? dateReg;
  String? number;
  int author;
  DateTime? done;
  String? type;
  List<int>? mailToUser;
  List<int>? mailToMessage;
  File? doc;

  Mail({
    this.id,
    required this.name,
    this.description,
    this.completion,
    this.naming,
    this.numberout,
    this.completionout,
    this.numberin,
    this.completionin,
    this.func,
    this.mailToProject,


    this.created,
    this.dateReg,
    this.number,
    required this.author,
    this.done,
    this.type,
    this.mailToUser,
    this.mailToMessage,
    this.doc,
  });

  factory Mail.fromJson(Map<String, dynamic> json) {
    return Mail(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      completion: json['completion'] != null ? DateTime.parse(json['completion']) : null,
      naming: json['naming'],
      numberout: json['number_out'],
      completionout: json['completion_out'] != null ? DateTime.parse(json['completion_out']) : null,
      numberin: json['number_in'],
      completionin: json['completion_in'] != null ? DateTime.parse(json['completion_in']) : null,
      func: json['func'],
      mailToProject: json['projects_to_mails'],
      author: json['author'],

      created: json['created'] != null ? DateTime.parse(json['created']) : null,
      dateReg: json['date_reg'] != null ? DateTime.parse(json['date_reg']) : null,
      number: json['number'],
      done: json['done'] != null ? DateTime.parse(json['done']) : null,
      type: json['type'],
      mailToUser: json['mail_to_user'] != null ? List<int>.from(json['mail_to_user']) : null,
      mailToMessage: json['mail_to_message'] != null ? List<int>.from(json['mail_to_message']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    String? docBase64;

    if (doc != null) {
      docBase64 = base64Encode(Uint8List.fromList(doc!.readAsBytesSync()));
    }

    Map<String, dynamic> jsonMap = {
      'id': id,
      'name': name,
      'description': description,
      'completion': completion?.toIso8601String().substring(0, 10),
      'naming': naming,
      'number_out': numberout,
      'completion_out': completionout?.toIso8601String().substring(0, 10),
      'number_in': numberin,
      'completion_in': completionin?.toIso8601String().substring(0, 10),
      'func': func,
      'projects_to_mails': mailToProject,
      'author': author,

      'created': created?.toIso8601String(),
      'date_reg': dateReg?.toIso8601String(),
      'number': number,
      'done': done?.toIso8601String(),
      'type': type,
      'mail_to_user': mailToUser,
      'mail_to_message': mailToMessage,
      'doc': docBase64,
    };

    jsonMap.removeWhere((key, value) => (value == null || value.toString().isEmpty) && key != 'cost');

    return jsonMap;
  }
}