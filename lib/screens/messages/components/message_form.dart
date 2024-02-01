import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';

import 'package:egs/model/message.dart';
import 'package:egs/api/message_api.dart';

class MessageForm extends StatefulWidget {
  final int userId;
  final int taskId;

  const MessageForm({
    Key? key,
    required this.userId,
    required this.taskId,
  }) : super(key: key);

  @override
  _MessageFormState createState() => _MessageFormState();
}

class _MessageFormState extends State<MessageForm> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  File? _selectedFile;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Message input field
          TextFormField(
            controller: _messageController,
            decoration: InputDecoration(labelText: 'Сообщение'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Введите сообщение';
              }
              return null;
            },
          ),
          // File picker button
          ElevatedButton(
            onPressed: () async {
              FilePickerResult? result =
              await FilePicker.platform.pickFiles(type: FileType.any);

              if (result != null) {
                setState(() {
                  _selectedFile = File(result.files.single.path!);
                });
              }
            },
            child: Text('Выбрать файл'),
          ),
          // Submit button
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                // Form is valid, submit the message
                Message message = Message(
                  message: _messageController.text,
                  author: widget.userId,
                  task: widget.taskId,
                  doc: _selectedFile,
                );


                // Handle the message submission here, e.g., send it to the backend
                print('Submitted message: ${message.toJson()}');
                MessageApi().createMessage(message);

                _formKey.currentState?.reset();
                _selectedFile = null;
              }
            },
            child: Text('Отправить'),
          ),
        ],
      ),
    );
  }
}