import 'user.dart';

class Project {
  final int? id;
  final String? projType;
  final String name;
  final String? regNum;
  final String? contract;
  final DateTime? dateCreation;
  final DateTime? dateNotification;
  final String? objectType;
  final String? address;
  final String? contact;
  final String? phone;
  final String? email;
  final String? status;
  final String? seasoning;
  final double? cost;
  final bool? is_archived;
  final List<User>? projectToUser;

  Project({
    this.id,
    this.projType,
    required this.name,
    this.regNum,
    this.contract,
    this.dateCreation,
    this.dateNotification,
    this.objectType,
    this.address,
    this.contact,
    this.phone,
    this.email,
    this.status,
    this.seasoning,
    this.cost,
    this.is_archived,
    this.projectToUser,
  });

  @override
  String toString() {
    return name;
  }

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      projType: json['proj_type'],
      name: json['name'] ?? '',
      regNum: json['reg_num'],
      contract: json['contract'],
      dateCreation: DateTime.parse(json['date_creation']),
      dateNotification: DateTime.parse(json['date_notification']),
      objectType: json['object_type'],
      address: json['address'],
      contact: json['contact'],
      phone: json['phone'],
      email: json['email'],
      status: json['status'],
      seasoning: json['seasoning'],
      cost: json['cost'],
      is_archived: json['is_archived'],
      projectToUser: (json['project_to_user'] as List<dynamic>)
          .map((userData) => User.fromJson(userData))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = {
      'id': id,
      'proj_type': projType,
      'name': name,
      'reg_num': regNum,
      'contract': contract,
      'date_creation': dateCreation?.toIso8601String(),
      'date_notification': dateNotification?.toIso8601String(),
      'object_type': objectType,
      'address': address,
      'contact': contact,
      'phone': phone,
      'email': email,
      'status': status,
      'seasoning': seasoning,
      'cost': cost,
      'is_archived': is_archived,
      'project_to_user': projectToUser?.map((user) => user.toJson()).toList(),
    };

    jsonMap.removeWhere((key, value) =>
        (value == null || value.toString().isEmpty) && key != 'cost');
    return jsonMap;
  }
}
