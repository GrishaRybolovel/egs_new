import 'dart:convert';
import 'package:egs/ui/const.dart';
import 'package:egs/model/task.dart';
import 'package:http/http.dart' as http;

class TaskApi {
  Future<List<Task>> fetchTasks() async {
    final response = await http.get(Uri.parse('$baseUrl/task/tasks/'));

    if (response.statusCode == 200) {
      Iterable data = json.decode(utf8.decode(response.bodyBytes));
      return List<Task>.from(data.map((json) => Task.fromJson(json)));
    } else {
      throw Exception('Ошибка загрузки задач.');
    }
  }

  Future<bool> createTask(Task task) async {
    final response = await http.post(
      Uri.parse('$baseUrl/task/tasks/'),
      headers: {'Content-Type': 'application/json'},
      body: utf8.encode(jsonEncode(task.toJson())),
    );

    print(json.decode(utf8.decode(response.bodyBytes)));


    if (response.statusCode == 201) {
      return true;
    } else {
      
      throw Exception('Ошибка создания задачи. Заполните все необходимые поля.');
    }
  }

  Future<Task> updateTask(int taskId, Task task) async {
    final response = await http.put(
      Uri.parse('$baseUrl/task/tasks/${taskId}/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(task.toJson()),
    );

    if (response.statusCode == 200) {
      return Task.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Ошибка обновления задачи.');
    }
  }

  Future<void> deleteTask(int taskId) async {
    final response = await http.delete(Uri.parse('$baseUrl/task/tasks/$taskId/'));

    if (response.statusCode != 204) {
      throw Exception('Ошибка удаления задачи');
    }
  }

  Future<Map<String, dynamic>?> fetchTasksByDate(int userId) async {
    final body = jsonEncode({'user_id': userId});

    final response = await http.post(
      Uri.parse('$baseUrl/task/tasks_by_date/?user_id=$userId'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Ошибка загрузки заданий');
    }
  }
}