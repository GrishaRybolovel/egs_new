import 'dart:convert';

import 'package:egs/const.dart';
import 'package:egs/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  Future<http.Response?> register(String email, String password, String name,
      String surname, String last_name) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/register/'),
      body: {
        'email': email,
        'password': password,
        'name': name,
        'surname': surname,
        'last_name': last_name,
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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', data['token']);
      return data;
    } else {
      return null;
    }
  }

  Future<bool> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', '');
    return true;
  }

  Future<http.Response> updateProfile(
      String email, String name, String surname) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? '';

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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? '';
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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? '';
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
}
