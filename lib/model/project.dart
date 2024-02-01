import 'user.dart';
import 'package:intl/intl.dart';

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
  final List<User>? projectToUser; // List of CustomUser objects
  // You can add more fields based on your Django model

  Project({
    this.id = null,
    this.projType = null,
    required this.name,
    this.regNum = null,
    this.contract = null,
    this.dateCreation = null,
    this.dateNotification = null,
    this.objectType = null,
    this.address = null,
    this.contact = null,
    this.phone = null,
    this.email = null,
    this.status = null,
    this.seasoning = null,
    this.cost = null,
    this.projectToUser = null,
    // Add more constructor parameters for additional fields
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] ?? null,
      projType: json['proj_type'] ?? null,
      name: json['name'] ?? '',
      regNum: json['reg_num'] ?? null,
      contract: json['contract'] ?? null,
      dateCreation: DateTime.parse(json['date_creation'] ?? null),
      dateNotification: DateTime.parse(json['date_notification'] ?? null),
      objectType: json['object_type'] ?? null,
      address: json['address'] ?? null,
      contact: json['contact'] ?? null,
      phone: json['phone'] ?? null,
      email: json['email'] ?? null,
      status: json['status'] ?? null,
      seasoning: json['seasoning'] ?? null,
      cost: json['cost'] ?? null,
      projectToUser: (json['project_to_user'] as List<dynamic>)
              .map((userData) => User.fromJson(userData))
              .toList() ??
          null,
      // Map additional fields from the JSON data
    );
  }

  Map<String, dynamic> toJson() {

    print(dateCreation);
    Map<String, dynamic> jsonMap = {
      'id': id,
      'proj_type': projType,
      'name': name,
      'reg_num': regNum,
      'contract': contract,
      'date_creation': dateCreation != null ? dateCreation?.toIso8601String() : null,
      'date_notification': dateNotification != null ? dateNotification?.toIso8601String() : null,
      'object_type': objectType,
      'address': address,
      'contact': contact,
      'phone': phone,
      'email': email,
      'status': status,
      'seasoning': seasoning,
      'cost': cost,
      'project_to_user': projectToUser?.map((user) => user.toJson()).toList(),
      // Add additional fields to the JSON representation
    };

    // Remove entries with null values
    jsonMap.removeWhere((key, value) =>
        (value == null || value.toString().isEmpty) && key != 'cost');
    return jsonMap;
  }
}
