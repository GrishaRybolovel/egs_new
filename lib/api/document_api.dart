import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class DocumentsApi {
  final String baseUrl; // Your Django backend base URL

  DocumentsApi(this.baseUrl);

  Future<List<Document>> fetchDocuments() async {
    final response = await http.get(Uri.parse('$baseUrl/document/documents/'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Document.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch documents');
    }
  }

  Future<Document> createDocument(Document document) async {
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

  Future<void> downloadDocument(int id) async {
    // Implement file download logic here (e.g., using FlutterDownloader)
    // You may need to adjust this based on your Django backend's file handling
  }
}