import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:egs/const.dart';
import 'package:egs/model/message.dart';

class MessageApi {

  Future<List<Message>> fetchMessages() async {
    final response = await http.get(Uri.parse('$baseUrl/message/messages/'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => Message.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load messages');
    }
  }

  Future<Message> createMessage(Message message) async {
    print(json.encode(message.toJson()));

    final response = await http.post(
      Uri.parse('$baseUrl/message/messages/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(message.toJson()),
    );

    if (response.statusCode == 201) {
      print(json.decode(response.body));
      return message;
    } else {
      throw Exception('Failed to create message');
    }
  }

  Future<Message> updateMessage(Message message) async {
    final response = await http.put(
      Uri.parse('$baseUrl/message/messages/${message.id}/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(message.toJson()),
    );

    if (response.statusCode == 200) {
      return Message.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update message');
    }
  }

  Future<void> deleteMessage(int messageId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/message/messages/$messageId/'),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete message');
    }
  }
}