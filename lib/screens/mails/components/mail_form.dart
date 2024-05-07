import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:universal_html/html.dart' as html;
import 'dart:io';

import 'package:egs/api/project_api.dart';
import 'package:egs/api/service.dart';
import 'package:egs/api/task_api.dart';
import 'package:egs/api/mail_api.dart';
import 'package:egs/screens/header.dart';
import 'package:egs/screens/side_menu.dart';
import 'package:egs/ui/const.dart';
import 'package:egs/model/project.dart';
import 'package:egs/model/task.dart';
import 'package:egs/model/user.dart';
import 'package:egs/model/mail.dart';
import 'package:egs/screens/dashboard/dashboard_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:egs/screens/messages/messages.dart';
import 'package:egs/screens/mails/mails.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart';

class MailFormScreen extends StatefulWidget {
  final Mail? initialMail;

  const MailFormScreen({super.key, this.initialMail});

  @override
  MailFormScreenState createState() => MailFormScreenState();
}

class MailFormScreenState extends State<MailFormScreen> {
  late TextEditingController nameController =
      TextEditingController(); // Название
  late TextEditingController descriptionController =
      TextEditingController(); // Описание
  late TextEditingController completionController =
      TextEditingController(); // Срок выполнения
  late TextEditingController namingController =
      TextEditingController(); // Наименование отправителя
  late TextEditingController numberoutController =
      TextEditingController(); // Исходящий номер отпрвителя
  late TextEditingController completionoutController =
      TextEditingController(); // Исходящая дата отпр.
  late TextEditingController numberinController =
      TextEditingController(); // Входящий номер получателя
  late TextEditingController completioninController =
      TextEditingController(); // Входящая дата отпр.
  late TextEditingController funcController =
      TextEditingController(); // Функциональность письма

  late TextEditingController doneController =
      TextEditingController(); // Функциональность письма
  // Привязать письмо к объекту
  // Пользователи

  File? _doc;
  String? doc64;
  String? docName;

  final formKey = GlobalKey<FormState>();

  final ApiService usersApiService = ApiService();
  final ProjectsApiService papiService = ProjectsApiService();

  List<int>? _users;
  List<User>? selectedUsers = [];
  late List<User> allUsers = [];

  Project? selectedProject;
  late List<Project>? allProjects = [];

  final TaskApi tapiService = TaskApi();

  @override
  void initState() {
    super.initState();

    nameController =
        TextEditingController(text: widget.initialMail?.name ?? '');
    namingController =
        TextEditingController(text: widget.initialMail?.naming ?? '');
    numberoutController =
        TextEditingController(text: widget.initialMail?.numberout ?? '');
    numberinController =
        TextEditingController(text: widget.initialMail?.numberin ?? '');
    descriptionController =
        TextEditingController(text: widget.initialMail?.description ?? '');
    completionController = TextEditingController(
        text: widget.initialMail?.completion?.toLocal().toString());
    completioninController = TextEditingController(
        text: widget.initialMail?.completion?.toLocal().toString());
    completionoutController = TextEditingController(
        text: widget.initialMail?.completion?.toLocal().toString());
    funcController =
        TextEditingController(text: widget.initialMail?.func ?? '');
    doneController = TextEditingController(
        text: widget.initialMail?.done?.toLocal().toString());
    _doc = widget.initialMail?.doc;
    docName = widget.initialMail?.docName;
    _users = widget.initialMail?.mailToUser ?? [];

    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    try {
      final users = await usersApiService.getUsers();
      final projects = await papiService.getProjects();

      setState(() {
        users.sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        allUsers = users;
        projects.sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        allProjects = projects;

        if (_users != null) {
          for (var user in allUsers) {
            if (_users?.contains(user.id) ?? false) {
              addUser(user);
            }
          }
        }

        for (var project in projects) {
          if (project.id == widget.initialMail?.mailToProject) {
            selectedProject = project;
            break;
          }
        }
      });
    } catch (e) {
      String exception = e.toString().substring(10);
      ScaffoldMessenger.of(this.context).showSnackBar(
        SnackBar(
          content: Text(exception),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void addUser(User user) {
    setState(() {
      selectedUsers?.add(user);
    });
  }

  void deleteUser(User user) {
    setState(() {
      selectedUsers?.remove(user);
    });
  }

  void addProject(Project project) {
    setState(() {
      selectedProject = project;
    });
  }

  void deleteProject() {
    setState(() {
      selectedProject = null;
    });
  }

  Future<void> convertWebFileToDartFile(html.File webFile) async {
    // Convert web file to base64
    final reader = html.FileReader();
    reader.readAsDataUrl(webFile);
    await reader.onLoad.first;
    final base64String = reader.result as String;

    setState(() {
      doc64 = base64String.split(',').last;
      docName = webFile.name;
    });
  }

  Future<void> _pickFile() async {
    if (kIsWeb) {
      final html.InputElement input = html.InputElement(type: 'file');
      input.click();

      input.onChange.listen((e) {
        final file = input.files!.first;
        convertWebFileToDartFile(file)
            .then((dartFile) {})
            .catchError((error) {});
      });
    } else {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.any);

      if (result != null) {
        // On mobile or desktop, use the path property to access the file path
        // _selectedFile = File(result.files.single.path!);

        setState(() {
          _doc = File(result.files.single.path!);
          doc64 = base64Encode(Uint8List.fromList(_doc!.readAsBytesSync()));
          docName = basename(_doc!.path);
          print(docName);
        });
      }
    }
  }

  String constructDownloadUrl(String filePath) {
    return '$baseUrl/mail/mails/download/$filePath';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const Header(),
        drawer: const SideMenu(),
        body: Row(children: [
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Visibility(
                    visible: widget.initialMail != null,
                    child: Column(
                      children: [
                        Text(
                          'Чат письма',
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        const SizedBox(height: defaultPadding),
                        MessagesScreen(mailId: widget.initialMail?.id ?? 0),
                        const SizedBox(height: defaultPadding * 3),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: defaultPadding),
          Expanded(
              flex: 1,
              child: SingleChildScrollView(
                  child: Container(
                      width: double.maxFinite,
                      padding: const EdgeInsets.all(defaultPadding),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.grey,
                      ),
                      child: Column(children: [
                Container(
                  padding: const EdgeInsets.all(defaultPadding),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  widget.initialMail == null
                                      ? 'Добавить задачу'
                                      : 'Редактировать письмо',
                                  style: Theme.of(context).textTheme.displayMedium,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              child: Icon(Icons.close),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )
                          ],
                        ),
                      const SizedBox(height: defaultPadding),
                      const SizedBox(height: defaultPadding),
                      Text(
                        'Проект',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: defaultPadding),
                      DropdownButton<Project>(
                        isExpanded: true,
                        value: null,
                        items: allProjects?.map((user) {
                          return DropdownMenuItem<Project>(
                            value: user,
                            child: Text(user.name),
                          );
                        }).toList(),
                        onChanged: (user) {
                          if (user != null) {
                            addProject(user);
                          }
                        },
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: (selectedProject == null) ? 0 : 1,
                        itemBuilder: (context, index) {
                          final user = selectedProject;
                          return ListTile(
                            title: Text(user?.name ?? ''),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                if (user != null) {
                                  deleteProject();
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: defaultPadding),
                // Users
                Container(
                  padding: const EdgeInsets.all(defaultPadding),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Пользователи',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: defaultPadding),
                      DropdownButton<User>(
                        isExpanded: true,
                        value: null,
                        items: allUsers.map((user) {
                          return DropdownMenuItem<User>(
                            value: user,
                            child: Text(user.toString()),
                          );
                        }).toList(),
                        onChanged: (user) {
                          if (user != null) {
                            addUser(user);
                          }
                        },
                      ),

                      // List of selected users with delete button

                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: selectedUsers?.length ?? 0,
                        itemBuilder: (context, index) {
                          final user = selectedUsers?[index];
                          return ListTile(
                            title: Text(user.toString()),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                if (user != null) {
                                  deleteUser(user);
                                }
                              },
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: defaultPadding * 2),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('Сохранить'),
                      ),
                    ],
                  ),
                ),
              ])))),
          const SizedBox(width: defaultPadding),
        ]));
  }
}
