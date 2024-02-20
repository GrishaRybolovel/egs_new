import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:path/path.dart';
import 'dart:io' as io;
import 'dart:typed_data' show Uint8List;
import 'package:flutter/foundation.dart';

class Mail {
  int? id;
  String name;
  String? naming;
  DateTime? created;
  DateTime? dateReg;
  String? number;
  int author;
  DateTime? completion;
  DateTime? done;
  String? type;
  List<int>? projectsToMails;
  List<int>? mailToUser;
  List<int>? mailToMessage;
  File? doc;

  Mail({
    this.id,
    required this.name,
    this.naming,
    this.created,
    this.dateReg,
    this.number,
    required this.author,
    this.completion,
    this.done,
    this.type,
    this.projectsToMails,
    this.mailToUser,
    this.mailToMessage,
    this.doc,
  });

  factory Mail.fromJson(Map<String, dynamic> json) {
    return Mail(
      id: json['id'],
      name: json['name'],
      naming: json['naming'],
      created: DateTime.parse(json['created']),
      dateReg: DateTime.parse(json['date_reg']),
      number: json['number'],
      author: json['author'],
      completion: json['completion'] != null ? DateTime.parse(json['completion']) : null,
      done: json['done'] != null ? DateTime.parse(json['done']) : null,
      type: json['type'],
      projectsToMails: json['projects_to_mails'] != null ? List<int>.from(json['projects_to_mails']) : null,
      mailToUser: json['mail_to_user'] != null ? List<int>.from(json['mail_to_user']) : null,
      mailToMessage: json['mail_to_message'] != null ? List<int>.from(json['mail_to_message']) : null,
      doc: json['doc'] != null ? File(json['doc']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    String? docBase64;
    String? docName;

    if (doc != null) {
      docBase64 = base64Encode(Uint8List.fromList(doc!.readAsBytesSync()));
      docName = kIsWeb ? doc!.uri.pathSegments.last : basename(doc!.path);
    }

    print(docBase64);
    Map<String, dynamic> jsonMap = {
      'id': id ?? null,
      'name': name,
      'naming': naming,
      'created': created?.toIso8601String(),
      'date_reg': dateReg?.toIso8601String(),
      'number': number,
      'author': author,
      'completion': completion?.toIso8601String(),
      'done': done?.toIso8601String(),
      'type': type,
      'projects_to_mails': projectsToMails,
      'mail_to_user': mailToUser,
      'mail_to_message': mailToMessage,
      'doc': docBase64,
    };

    jsonMap.removeWhere((key, value) => (value == null || value.toString().isEmpty) && key != 'cost');

    return jsonMap;
  }
}