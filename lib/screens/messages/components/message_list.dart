import 'dart:io';

import 'package:egs/api/message_api.dart';
import 'package:egs/model/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data' show Uint8List;
import 'package:flutter/foundation.dart';
import 'package:egs/responsive.dart';

import '../../../const.dart';

class MessageList extends StatefulWidget {
  final int userId;
  final int taskId;

  const MessageList({Key? key, required this.userId, required this.taskId}) : super(key: key);

  @override
  _MessageListState createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  late Future<List<Message>>? messagesFuture;

  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  File? _selectedFile;

  @override
  void initState() {
    super.initState();
    loadMessages();
  }

  Future<void> loadMessages() async {
    setState(() {
      try {
        messagesFuture = MessageApi().fetchMessages();
      } catch (error) {
        // Handle errors here
        print('Error fetching messages: $error');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Message>>(
      future: messagesFuture,
      builder: (context, snapshot) {
        if (messagesFuture == null) {
          // messagesFuture is not yet initialized
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Error while fetching data, show an error message
          return Text('Error: ${snapshot.error}');
        } else {
          // Data has been fetched, build the ListView
          List<Message> originalMessages = snapshot.data ?? [];
          List<Message> messages = List.from(originalMessages.reversed);
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Expanded(
                child: Container(
                    height: 300,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        return Column(children:[Container(
                            padding: EdgeInsets.all(defaultPadding),
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons/menu_notification.svg",
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Автор: ' +
                                              messages[index]
                                                  .author
                                                  .toString() ??
                                          'Нет текста'),
                                      Text(
                                        'Дата отправки: ' +
                                            messages[index]
                                                .created
                                                .toString()
                                                .substring(0, 11),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(color: Colors.white70),
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        if (messages[index].doc_name != null) {
                                          final downloadUrl =
                                              constructDownloadUrl(
                                                  messages[index].doc_name!);
                                          launch(downloadUrl);
                                        }
                                      },
                                      child: Visibility(
                                          visible:
                                              messages[index].doc_name != null,
                                          child: Row(
                                            children: [
                                              Text('Файл: ' +
                                                  (messages[index].doc_name ??
                                                      '')),
                                              Icon(Icons.download),
                                            ],
                                          ))),
                                  SizedBox(height: defaultPadding),
                                  Text(
                                    messages[index].message ?? 'Нет текста',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(color: Colors.white),
                                  ),
                                ])),
                          SizedBox(height: defaultPadding),
                        ]);
                      },
                    )
                )
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                      children:[
                        ElevatedButton(
                          onPressed: () async {
                            FilePickerResult? result = await FilePicker.platform
                                .pickFiles(type: FileType.any);

                            if (result != null) {
                              if (kIsWeb) {
                                print('Web');
                                // On the web, use the bytes property to access the file content
                                List<int> fileBytes = result.files.single.bytes!;
                                _selectedFile = File.fromRawPath(Uint8List.fromList(fileBytes));
                              } else{
                                print('mobile');
                                // On mobile or desktop, use the path property to access the file path
                                // _selectedFile = File(result.files.single.path!);

                                _selectedFile = File(result.files.single.path!);
                                print(_selectedFile);
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero, // Set padding to zero to make the button smaller

                            primary: secondaryColor, // Set the background color to transparent
                          ),
                          child: Icon(Icons.file_present,
                          size: 24.0,),
                        ),
                        Container(width: Responsive.ScreenWidth(context) - 192,
                        child: TextFormField(
                          controller: _messageController,
                          decoration: InputDecoration(labelText: 'Сообщение'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Введите сообщение';
                            }
                            return null;
                          },
                        ),
                          ),
                    ElevatedButton(
                      onPressed: () async{
                        if (_formKey.currentState?.validate() ?? false) {
                          // Form is valid, submit the message
                          Message message = Message(
                            message: _messageController.text,
                            author: widget.userId,
                            task: widget.taskId,
                            doc: _selectedFile,
                          );

                          try {
                            // Await the completion of the createMessage method
                            await MessageApi().createMessage(message);

                            // After successful submission, load messages
                            _formKey.currentState?.reset();
                            _selectedFile = null;
                            await loadMessages();
                          } catch (error) {
                            // Handle errors during message submission
                            print('Error submitting message: $error');
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero, // Set padding to zero to make the button smaller

                        primary: secondaryColor, // Set the background color to transparent
                      ),
                      child: Icon(Icons.send),
                    ),
                  ]),
                ],
              ),
            ),
          ]);
        }
      },
    );
  }

  String constructDownloadUrl(String filePath) {
    return '$baseUrl/message/messages/download/$filePath';
  }
}
