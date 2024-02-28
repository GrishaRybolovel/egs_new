import 'package:egs/model/user.dart';
import 'package:intl/intl.dart';

class Task {
  int? id;
  String name;
  int authorId;
  DateTime? created;
  DateTime? completion;
  DateTime? done;
  int? projectId;
  List<User> taskToUserIds;

  Task({
    this.id,
    required this.name,
    required this.authorId,
    this.created,
    this.completion,
    this.done,
    this.projectId,
    required this.taskToUserIds,
  });

  factory Task.fromJson(Map<String, dynamic> json) {

    DateTime? done;
    DateTime? completion;

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
      authorId: json['author'],
      created: DateTime.parse(json['created']),
      completion: completion,
      done: done,
      projectId: json['project'],
      taskToUserIds: (json['task_to_user'] as List<dynamic>?)
          ?.map((id) => User.fromJson(id))
          .toList() ?? [],
    );
    return myNewTask;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = {
      'id': id,
      'name': name,
      'author': authorId,
      'created': created?.toIso8601String(),
      'completion': completion?.toIso8601String(),
      'done': done?.toIso8601String(),
      'project': projectId,
      'task_to_user': taskToUserIds,
    };

    jsonMap.removeWhere((key, value) =>
    (value == null || value.toString().isEmpty));
    return jsonMap;
  }
}