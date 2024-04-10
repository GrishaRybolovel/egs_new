import 'dart:convert';

import 'package:egs/ui/const.dart';
import 'package:egs/model/project.dart'; // Import the Project class
import 'package:egs/model/journal.dart';
import 'package:http/http.dart' as http;

class ProjectsApiService {
  Future<List<Project>> getProjects() async {
    final response = await http.get(Uri.parse('$baseUrl/project/projects/'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonProjects =
          json.decode(utf8.decode(response.bodyBytes));
      return jsonProjects.map((json) => Project.fromJson(json)).toList();
    } else {
      throw Exception('Ошибка получения объектов.');
    }
  }

  Future<Project> createProject(Project project) async {
    final response = await http.post(
      Uri.parse('$baseUrl/project/projects/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(project.toJson()),
    );

    if (response.statusCode == 201) {
      return Project.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Ошибка создания объекта. Заполните все необходимые поля.');
    }
  }

  Future<Project> updateProject(int projectId, Project project) async {

    final response = await http.put(
      Uri.parse('$baseUrl/project/projects/$projectId/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(project.toJson()),
    );

    if (response.statusCode == 200) {
     
      return Project.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Ошибка обновления проекта.');
    }
  }

  Future<void> deleteProject(int projectId) async {
    final response =
        await http.delete(Uri.parse('$baseUrl/project/projects/$projectId/'));

    if (response.statusCode != 204) {
      throw Exception('Ошибка удаления проекта.');
    }
  }

  Future<List<Journal>> getJournal(int projectId) async {
    final response = await http.get(Uri.parse('$baseUrl/project/status-choice-change/$projectId'));
   
    if (response.statusCode == 200) {
      final List<dynamic> jsonJournals =
      json.decode(utf8.decode(response.bodyBytes));
      return jsonJournals.map((json) => Journal.fromJson(json)).toList();
    } else {
      throw Exception('Ошибка получения журнала.');
    }
  }

  Future<Journal> createJournal(Journal journal) async {
    final response = await http.post(
      Uri.parse('$baseUrl/project/status-choice-change/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(journal.toJson()),
    );

    if (response.statusCode == 201) {
      return Journal.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Ошибка создания объекта. Заполните все необходимые поля.');
    }
  }

  Future<void> deleteJournal(int journalId) async {
    final response =
    await http.delete(Uri.parse('$baseUrl/project/status-choice-change/$journalId/'));

    if (response.statusCode != 204) {
      throw Exception('Ошибка удаления проекта.');
    }
  }
}
