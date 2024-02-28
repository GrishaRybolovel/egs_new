import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:egs/model/document.dart';
import 'package:egs/ui/const.dart';

class DocumentsApi {

  Future<List<Document>> fetchDocuments() async {
    final response = await http.get(Uri.parse('$baseUrl/document/documents/'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => Document.fromJson(json)).toList();
    } else {
      throw Exception('Ошибка загрузки документов');
    }
  }

  Future<Document> createDocument(Document document) async {
    print(json.encode(document.toJson()));
    final response = await http.post(
      Uri.parse('$baseUrl/document/documents/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(document.toJson()),
    );

    if (response.statusCode == 201) {
      return Document.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create document');
    }
  }

  Future<Document> updateDocument(int id, Document document) async {
    final response = await http.put(
      Uri.parse('$baseUrl/document/documents/$id/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(document.toJson()),
    );

    if (response.statusCode == 200) {
      return Document.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update document');
    }
  }

  Future<void> deleteDocument(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/document/documents/$id/'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete document');
    }
  }
}