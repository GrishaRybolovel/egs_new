import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:egs/model/mail.dart';
import 'package:egs/ui/const.dart';

class MailsApi {

  Future<List<Mail>> fetchMails() async {
    final response = await http.get(Uri.parse('$baseUrl/mail/mails/'));
    if (response.statusCode == 200) {
      List<dynamic> data =json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => Mail.fromJson(json)).toList();
    } else {
      throw Exception('Ошибка загрузки писем');
    }
  }

  // Create a mail
  Future<Mail> createMail(Mail mail) async {
    final response = await http.post(
      Uri.parse('$baseUrl/mail/mails/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(mail.toJson()),
    );
    if (response.statusCode == 201) {
      return Mail.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Ошибка создания письма');
    }
  }

  // Update a mail
  Future<Mail> updateMail(Mail mail) async {
    final response = await http.put(
      Uri.parse('$baseUrl/mail/mails/${mail.id}/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(mail.toJson()),
    );
    if (response.statusCode == 200) {
      return Mail.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Ошибка обновления письма');
    }
  }

  // Delete a mail
  Future<void> deleteMail(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/mail/mails/$id/'));
    if (response.statusCode != 204) {
      throw Exception('Ошибка удаления письма');
    }
  }
}