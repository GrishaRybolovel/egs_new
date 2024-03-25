import 'package:appflowy_board/appflowy_board.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';


enum ScrumColumn { todo, doing, done}

class ScrumCard extends AppFlowyGroupItem implements EntityModel {
  String? _objectId;
  final String _dummyId = const Uuid().v1(); 

  // Public props
  final int index;
  final String title;
  final String content;
  final ScrumColumn scrumColumn;
  
  // Getters
  @override
  String? get objectId => _objectId;

  @override
  String get id => _objectId ?? _dummyId;

  ScrumCard({
    String? objectId,
    required this.index,
    required this.title,
    required this.content,
    required this.scrumColumn
  }) {
    _objectId = objectId;
  }

  // Methods and factories
  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
    result.addAll({'id': id});
    result.addAll({'index': index});
    result.addAll({'title': title});
    result.addAll({'content': content});
    result.addAll({'scrumColumn': scrumColumn.index});

    return result;
  }

  factory ScrumCard.fromMap(Map<String, dynamic> map) {
    return ScrumCard(
      objectId: map["id"], 
      index: map["index"] ?? "", 
      title: map["title"] ?? "", 
      content: map["content"] ?? "", 
      scrumColumn: ScrumColumn.values[map["scrumColumn"]]
    );
  }

  factory ScrumCard.fromJson(String jsonSource) =>
      ScrumCard.fromMap(json.decode(jsonSource));

  String toJson() => json.encode(toMap());
  
}

abstract class EntityModel {
  final String? objectId;

  EntityModel({this.objectId});


 }
 