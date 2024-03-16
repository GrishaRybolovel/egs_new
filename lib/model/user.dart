import 'package:intl/intl.dart';

class User {
  final int? id;
  final String email;
  final String name;
  final String surname;
  final String? lastName;
  final bool? isActive;
  final bool? isSuperuser;
  final bool? isStaff;
  final DateTime? dateJoined;
  final DateTime? lastLogin;
  final String? phone;
  final String? address;
  final DateTime? dateOfBirth;
  final DateTime? dateOfStart;
  final String? inn;
  final String? snils;
  final String? passport;
  final String? post;
  final String? infoAboutRelocate;
  final String? attestation;
  final String? qualification;
  final String? retraining;
  final bool status;
  final String? password;

  User({
    this.id,
    required this.email,
    required this.name,
    required this.surname,
    this.lastName,
    this.isActive,
    this.isSuperuser,
    this.isStaff,
    this.dateJoined,
    this.lastLogin,
    this.phone,
    this.address,
    this.dateOfBirth,
    this.dateOfStart,
    this.inn,
    this.snils,
    this.passport,
    this.post,
    this.infoAboutRelocate,
    this.attestation,
    this.qualification,
    this.retraining,
    required this.status,
    this.password
  });

  // You can add other methods or properties as needed

  @override
  String toString() {
    String toName = name ?? '';
    String toSurname = surname ?? '';
    String toLastname = lastName ?? '';
    return '$toName $toSurname $toLastname';
  }

  // Factory method to create a User instance from JSON data
  // Factory method to create a User instance from JSON data
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      surname: json['surname'] ?? '',
      lastName: json['last_name'],
      isActive: json['is_active'] ?? false,
      isSuperuser: json['is_superuser'] ?? false,
      isStaff: json['is_staff'] ?? false,
      dateJoined: DateTime.parse(json['date_joined'] ?? ''),
      lastLogin: json['last_login'] != null
          ? DateTime.parse(json['last_login'])
          : null,
      phone: json['phone'],
      address: json['address'],
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'])
          : null,
      dateOfStart: json['date_of_start'] != null
          ? DateTime.parse(json['date_of_start'])
          : null,
      inn: json['inn'],
      snils: json['snils'],
      passport: json['passport'],
      post: json['post'],
      infoAboutRelocate: json['info_about_relocate'],
      attestation: json['attestation'],
      qualification: json['qualification'],
      retraining: json['retraining'],
      status: json['status'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {

    Map<String, dynamic> jsonMap = {
      'id': id,
      'email': email,
      'name': name,
      'surname': surname,
      'last_name': lastName,
      'is_active': isActive,
      'is_superuser': isSuperuser,
      'is_staff': isStaff,
      'date_joined': dateJoined?.toIso8601String(),
      'last_login': lastLogin?.toIso8601String(),
      'phone': phone,
      'address': address,
      'date_of_birth': dateOfBirth?.toIso8601String().substring(0, 10),
      'date_of_start': dateOfStart?.toIso8601String().substring(0, 10),
      'inn': inn,
      'snils': snils,
      'passport': passport,
      'post': post,
      'info_about_relocate': infoAboutRelocate,
      'attestation': attestation,
      'qualification': qualification,
      'retraining': retraining,
      'status': status,
      'password': password,
    };
    jsonMap.removeWhere((key, value) =>
    (value == null || value.toString().isEmpty));
    return jsonMap;
  }
}
