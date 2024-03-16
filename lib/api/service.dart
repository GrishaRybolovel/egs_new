import 'dart:convert';

import 'package:egs/main.dart';
import 'package:egs/ui/const.dart';
import 'package:egs/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  Future<http.Response?> register(String email, String password, String name,
      String surname, String lastName) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/register/'),
      body: {
        'email': email,
        'password': password,
        'name': name,
        'surname': surname,
        'last_name': lastName,
      },
    );
    return response;
  }

  Future<Map<String, dynamic>?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/login/'),
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          json.decode(utf8.decode(response.bodyBytes));
      // Save token to SharedPreferences
      sharedPreferences.setString('token', data['token']);
      return data;
    } else {
      return null;
    }
  }

  Future<bool> logout() async {
    sharedPreferences.clear();
    return true;
  }

  Future<http.Response> updateProfile(
      String email, String name, String surname) async {
    final String token = sharedPreferences.getString('token') ?? '';

    final response = await http.put(
      Uri.parse('$baseUrl/user/profile/'),
      headers: {'Authorization': 'Token $token'},
      body: {
        'email': email,
        'name': name,
        'surname': surname,
      },
    );
    return response;
  }

  Future<User> fetchUserData() async {
    final String token = sharedPreferences.getString('token') ?? '';
    final response = await http.get(
      Uri.parse('$baseUrl/user/profile/'),
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json; charset=utf-8'
      },
    ); 

    if (response.statusCode == 200) {
      final Map<String, dynamic> userData =
          json.decode(utf8.decode(response.bodyBytes));
      return User.fromJson(userData);
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<List<User>> getUsers() async {
    final String token = sharedPreferences.getString('token') ?? '';
    final response = await http.get(
      Uri.parse('$baseUrl/user/users/'),
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json; charset=utf-8'
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> usersData =
      json.decode(utf8.decode(response.bodyBytes));
      return usersData.map((userJson) => User.fromJson(userJson)).toList();
    } else {
      throw Exception('Не удалось загрузить пользователей');
    }
  }

  Future<User> createUser(User user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/register/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );

    if (response.statusCode == 201) {
      return User.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Ошибка создания пользователя. Заполните все необходимые поля.');
    }
  }

  Future<User> updateUser(int userId, User user) async {

    final response = await http.put(
      Uri.parse('$baseUrl/user/users/${userId}/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Ошибка обновления пользователя.');
    }
  }

  Future<void> deleteUser(int userId) async {
    final response = await http.delete(Uri.parse('$baseUrl/user/users/${userId}/'));

    if (response.statusCode != 204) {
      throw Exception('Ошибка удаления пользователя');
    }
  }
  
}

