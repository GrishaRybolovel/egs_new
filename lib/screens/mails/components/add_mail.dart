import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:universal_html/html.dart' as html;
import 'dart:io';
import 'package:egs/responsive.dart';

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

class AddMail extends StatefulWidget {
  const AddMail({super.key});

  @override
  State<AddMail> createState() => _AddMailState();
}

class _AddMailState extends State<AddMail> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController(); // Название
  TextEditingController descriptionController =
      TextEditingController(); // Описание
  TextEditingController completionController =
      TextEditingController(); // Срок выполнения
  TextEditingController namingController =
      TextEditingController(); // Наименование отправителя
  TextEditingController numberoutController =
      TextEditingController(); // Исходящий номер отпрвителя
  TextEditingController completionoutController =
      TextEditingController(); // Исходящая дата отпр.
  TextEditingController numberinController =
      TextEditingController(); // Входящий номер получателя
  TextEditingController completioninController =
      TextEditingController(); // Входящая дата отпр.
  TextEditingController funcController =
      TextEditingController(text: "1"); // Функциональность письма
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
          selectedProject = project;
          break;
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
        body: SingleChildScrollView(
            child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Создать письмо',
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
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          Container(
              width: Responsive.screenWidth(context) * 0.9,
              padding: const EdgeInsets.all(defaultPadding),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.grey,
              ),
              child: Form(
                  key: _formKey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: defaultPadding),
                        createTextController(nameController, 'Название',
                            'Введите название', true),
                        const SizedBox(height: defaultPadding),
                        createTextController(descriptionController, 'Описание',
                            'Введите описание', false),
                        const SizedBox(height: defaultPadding),
                        createDateController(
                            completionController,
                            'Срок выполнения',
                            'Введите срок выполнения письма',
                            true),
                        const SizedBox(height: defaultPadding),
                        createTextController(
                            namingController,
                            'Наименование отправителя',
                            'Введите наименование отправителя',
                            true),
                        const SizedBox(height: defaultPadding),
                        createTextController(
                            numberoutController,
                            'Исходящий номер отпр.',
                            'Введите исходящий номер',
                            false),
                        const SizedBox(height: defaultPadding),
                        createDateController(
                            completionoutController,
                            'Исходящая дата отпр.',
                            'Введите исходящий номер',
                            false),
                        const SizedBox(height: defaultPadding),
                        createTextController(
                            numberinController,
                            'Входящий номер получ.',
                            'Введите входящий номер',
                            false),
                        const SizedBox(height: defaultPadding),
                        createDateController(
                            completioninController,
                            'Входящая дата отпр.',
                            'Введите исходящий номер',
                            false),
                        const SizedBox(height: defaultPadding),
                        createPickController(
                            funcController,
                            'Функциональность письма',
                            'Введите исходящий номер',
                            false),
                        const SizedBox(height: defaultPadding),
                        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                          Text(
                            "Привязать письмо к объекту",
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                          const SizedBox(
                            width: defaultPadding,
                          ),
                          Container(
                              width: Responsive.screenWidth(this.context) * 0.4,
                              child:
                              DropdownButtonFormField<Project>(
                            isExpanded: true,
                            value: selectedProject,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
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
                          )
                          )
                        ]),
                        const SizedBox(height: defaultPadding),
                        GestureDetector(
                          onTap: () {
                          },
                          child: Visibility(
                            visible: docName != null,
                            child: Row(
                              children: [
                                Text('Файл: ${docName ?? ''}'),
                                const Icon(Icons.download),
                              ],
                            ),
                          ),
                        ),
                        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                          ElevatedButton(
                            onPressed: _pickFile,
                            child: const Text('Прикрепить документ'),
                          )
                        ]),
                        const SizedBox(height: defaultPadding),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              saveMail();
                            }
                          },
                          child: const Text('Сохранить'),
                        ),
                      ]))),
          const SizedBox(height: defaultPadding * 3),
        ])));
  }

  Row createTextController(TextEditingController itemController,
      String itemText, String validatorText, bool required) {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      Text(
        itemText,
        style: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w100,
        ),
      ),
      const SizedBox(
        width: defaultPadding,
      ),
      Container(
        width: Responsive.screenWidth(this.context) * 0.4,
        child: TextFormField(
          controller: itemController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (required) {
              if (value == null || value.isEmpty) {
                return validatorText;
              }
              return null;
            } else {
              return null;
            }
          },
        ),
      )
    ]);
  }

  Row createDateController(TextEditingController itemController,
      String itemText, String validatorText, bool required) {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      Text(
        itemText,
        style: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w100,
        ),
      ),
      const SizedBox(
        width: defaultPadding,
      ),
      Icon(Icons.calendar_month),
      const SizedBox(
        width: defaultPadding,
      ),
      Container(
        width: Responsive.screenWidth(this.context) * 0.4,
        child: TextFormField(
          controller: itemController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          onTap: () async {
            DateTime? date = await showDatePicker(
              context: this.context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (date != null) {
              itemController.text = date.toLocal().toString().substring(0, 10);
            }
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return null;
            }
            if (!RegExp(r'\d{4}-\d{2}-\d{2}').hasMatch(value)) {
              return 'Неверный формат даты';
            }
            return null;
          },
        ),
      )
    ]);
  }

  void saveMail() async {
    try {
      DateTime? completion;
      DateTime? completionout;
      DateTime? completionin;

      if (completionController.text != null && !completionController.text.isEmpty) {
        completion = DateTime.parse(completionController.text!);
      }
      if (completionoutController.text != null && !completionoutController.text.isEmpty) {
        completionout = DateTime.parse(completionoutController.text!);
      }
      if (completioninController.text != null && !completioninController.text.isEmpty) {
        completionin = DateTime.parse(completioninController.text!);
      }

      User author = await ApiService().fetchUserData();
      final Mail newMail = Mail(
        name: nameController.text,
        description: descriptionController.text,
        completion: completion,
        naming: namingController.text,
        numberout: numberoutController.text,
        completionout: completionout,
        numberin: numberinController.text,
        completionin: completionin,
        func: funcController.text,
        mailToProject: selectedProject?.id,
        author: author.id ?? 0,
      );

      String name = newMail.name;
      await MailsApi().createMail(newMail);

      ScaffoldMessenger.of(this.context).showSnackBar(
        SnackBar(
          content: Text('Письмо $name успешно создано'),
          duration: const Duration(seconds: 3),
        ),
      );
      Navigator.push(
        this.context,
        MaterialPageRoute(
          builder: (context) => const MailsScreen(),
        ),
      );
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

  Row createPickController(TextEditingController itemController,
      String itemText, String validatorText, bool required) {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      Text(
        itemText,
        style: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w100,
        ),
      ),
      const SizedBox(
        width: defaultPadding,
      ),
      Container(
        width: Responsive.screenWidth(this.context) * 0.4,
        child: DropdownButtonFormField<String>(
          value: itemController.text,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(
              value: '1',
              child: Text('Письмо как задача'),
            ),
            DropdownMenuItem(
              value: '2',
              child: Text('Информационное письмо'),
            ),
          ],
          onChanged: (value) {
            setState(() {
              itemController.text = value!;
            });
          },
        ),
      )
    ]);
  }
}
