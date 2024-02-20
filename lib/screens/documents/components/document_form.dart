import 'dart:convert';
import 'dart:html' as html;
import 'dart:io';

import 'package:egs/api/document_api.dart';
import 'package:egs/api/project_api.dart';
import 'package:egs/api/service.dart';
import 'package:egs/const.dart';
import 'package:egs/model/document.dart';
import 'package:egs/model/project.dart';
import 'package:egs/model/user.dart';
import 'package:egs/responsive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:url_launcher/url_launcher.dart';

class DocumentForm extends StatefulWidget {
  final Document? document;

  const DocumentForm({Key? key, this.document}) : super(key: key);

  @override
  _DocumentFormState createState() => _DocumentFormState();
}

class _DocumentFormState extends State<DocumentForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _name;
  String? _status;
  String? _docType;
  late TextEditingController _duration;
  File? _doc;
  List<int>? _users;
  List<int>? _projects;

  String? doc64;
  String? docName;

  // Getting users and projects data
  final ApiService usersApiService = ApiService();
  final ProjectsApiService papiService = ProjectsApiService();

  List<User>? selectedUsers = [];
  late List<User>? allUsers = [];

  List<Project>? selectedProjects = [];
  late List<Project>? allProjects = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      _name = TextEditingController(text: widget.document?.name ?? null);
      _status = widget.document?.status;
      _duration = TextEditingController(
          text: widget.document?.duration?.toLocal().toString() ?? null);
      _docType = widget.document?.docType;
      _doc = widget.document?.doc;
      _users = widget.document?.users;
      _projects = widget.document?.projects;
    });

    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    try {
      final users = await usersApiService.getUsers();
      final projects = await papiService.getProjects();

      setState(() {
        allUsers = users;
        allProjects = projects;

        if (_users != null) {
          for (var user in users) {
            if (_users?.contains(user.id) ?? false) {
              addUser(user);
            }
          }
        }

        if (_projects != null) {
          for (var project in projects) {
            if (_projects?.contains(project.id) ?? false) {
              addProject(project);
            }
          }
        }
      });
    } catch (e) {
      String exception = e.toString().substring(10);
      showSnackBar(BuildContext context) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(exception),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void addUser(User user) {
    setState(() {
      if (selectedUsers == null) {
        selectedUsers?.add(user);
      } else if (!selectedUsers!.contains(user) ?? false) {
        selectedUsers?.add(user);
      }
    });
  }

  void deleteUser(User user) {
    setState(() {
      selectedUsers?.remove(user);
    });
  }

  void addProject(Project project) {
    setState(() {
      if (selectedProjects == null) {
        selectedProjects?.add(project);
      } else if (!selectedProjects!.contains(project) ?? false) {
        selectedProjects?.add(project);
      }
    });
  }

  void deleteProject(Project project) {
    setState(() {
      selectedProjects?.remove(project);
    });
  }

  Future<void> convertWebFileToDartFile(html.File webFile) async {
    // Convert web file to base64
    final reader = html.FileReader();
    reader.readAsDataUrl(webFile);
    await reader.onLoad.first;
    final base64String = reader.result as String;
    doc64 = base64String.split(',').last;
    docName = webFile.name;
  }

  Future<void> _pickFile() async {
    if (kIsWeb) {
      final html.InputElement input = html.InputElement(type: 'file');
      input.click();

      input.onChange.listen((e) {
        final file = input.files!.first;
        convertWebFileToDartFile(file).then((dartFile) {
          print(doc64);
          print(docName);
        }).catchError((error) {
          print('Error converting file to base64: $error');
        });
      });
    } else {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.any);

      if (result != null) {
        print('mobile');
        // On mobile or desktop, use the path property to access the file path
        // _selectedFile = File(result.files.single.path!);

        _doc = File(result.files.single.path!);
        doc64 = base64Encode(Uint8List.fromList(_doc!.readAsBytesSync()));
        docName = basename(_doc!.path);
      }
    }
  }

  String constructDownloadUrl(String filePath) {
    return '$baseUrl/document/documents/download/$filePath';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              widget.document == null
                  ? 'Добавить документ'
                  : 'Изменить документ',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: defaultPadding),
            TextFormField(
              controller: _name,
              decoration: InputDecoration(labelText: 'Название'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите название';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _name.text = value;
                });
              },
            ),
            DropdownButtonFormField<String>(
              value: _status,
              onChanged: (String? newValue) {
                setState(() {
                  _status = newValue;
                });
              },
              items: [
                DropdownMenuItem(
                  value: '1',
                  child: Text('Без статуса'),
                ),
                DropdownMenuItem(
                  value: '2',
                  child: Text('Черновик'),
                ),
                DropdownMenuItem(
                  value: '3',
                  child: Text('На согласовании'),
                ),
                DropdownMenuItem(
                  value: '4',
                  child: Text('Действующий'),
                ),
                DropdownMenuItem(
                  value: '5',
                  child: Text('Завершённый'),
                ),
                DropdownMenuItem(
                  value: '6',
                  child: Text('Расторгнутый'),
                ),
                DropdownMenuItem(
                  value: '7',
                  child: Text('Аннулированный'),
                ),
              ],
              decoration: InputDecoration(labelText: 'Статус'),
            ),
            DropdownButtonFormField<String>(
              value: _docType,
              onChanged: (String? newValue) {
                setState(() {
                  _docType = newValue;
                });
              },
              items: [
                DropdownMenuItem(
                  value: '01',
                  child: Text('Договор'),
                ),
                DropdownMenuItem(
                  value: '02',
                  child: Container(
                      width: Responsive.ScreenWidth(context) -
                          (Responsive.isDesktop(context) ? 400 : 88),
                      child: Text(
                          'Регистрация объекта в государственном реестре')),
                ),
                DropdownMenuItem(
                  value: '03',
                  child: Text('Правоустанавливающие документы'),
                ),
                DropdownMenuItem(
                  value: '04',
                  child: Text('Проектные документы'),
                ),
                DropdownMenuItem(
                  value: '05',
                  child: Text('Экспертиза'),
                ),
                DropdownMenuItem(
                  value: '06',
                  child: Text('Страхование'),
                ),
                DropdownMenuItem(
                  value: '07',
                  child: Container(
                      width: Responsive.ScreenWidth(context) -
                          (Responsive.isDesktop(context) ? 400 : 88),
                      child: Text(
                          'Разрешительные документы и акты ввода в эксплуатацию')),
                ),
                DropdownMenuItem(
                  value: '08',
                  child: Container(
                      width: Responsive.ScreenWidth(context) -
                          (Responsive.isDesktop(context) ? 400 : 88),
                      child: Text(
                          'Исполнительно-техническая документация по строительству')),
                ),
                DropdownMenuItem(
                  value: '09',
                  child: Text('Эксплуатационные документы'),
                ),
                DropdownMenuItem(
                  value: '10',
                  child: Text('Обучение персонала'),
                ),
                DropdownMenuItem(
                  value: '11',
                  child: Container(
                      width: Responsive.ScreenWidth(context) -
                          (Responsive.isDesktop(context) ? 400 : 88),
                      child:
                          Text('Документы сезонные в эксплуатационный период')),
                ),
                DropdownMenuItem(
                  value: '12',
                  child: Text('Нормативно-правовые акты'),
                ),
                DropdownMenuItem(
                  value: '13',
                  child: Text('Иные документы'),
                ),
              ],
              decoration: InputDecoration(labelText: 'Тип документа'),
            ),
            TextFormField(
              controller: _duration,
              decoration: InputDecoration(labelText: 'Срок действия'),
              onTap: () async {
                DateTime? date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (date != null) {
                  setState(() {
                    _duration.text = date.toLocal().toString().substring(0, 10);
                  });
                }
              },
            ),
            SizedBox(height: defaultPadding),
            GestureDetector(
                onTap: () {
                  if (widget.document != null) {
                    if (widget.document?.doc_name != null) {
                      final downloadUrl = constructDownloadUrl(
                          widget.document?.doc_name! ?? '');
                      launch(downloadUrl);
                    }
                  }
                },
                child: Visibility(
                    visible: widget.document?.doc_name != null,
                    child: Row(
                      children: [
                        Text('Файл: ' + (widget.document?.doc_name ?? '')),
                        Icon(Icons.download),
                      ],
                    ))),
            ElevatedButton(
              onPressed: _pickFile,
              child: Text('Документ'),
            ),
            SizedBox(height: defaultPadding),
            // Users
            Container(
              padding: EdgeInsets.all(defaultPadding),
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Пользователи',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: defaultPadding),
                  DropdownButton<User>(
                    value: null,
                    items: allUsers?.map((user) {
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
                        title: Text(user?.name ?? ''),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            if (user != null) {
                              deleteUser(user);
                            }
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: defaultPadding),

            // Projects
            Container(
              padding: EdgeInsets.all(defaultPadding),
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Объекты',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: defaultPadding),
                  DropdownButton<Project>(
                    value: null,
                    items: allProjects?.map((project) {
                      return DropdownMenuItem<Project>(
                        value: project,
                        child: Text(project.toString()),
                      );
                    }).toList(),
                    onChanged: (project) {
                      if (project != null) {
                        addProject(project);
                      }
                    },
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: selectedProjects?.length ?? 0,
                    itemBuilder: (context, index) {
                      final project = selectedProjects?[index];
                      return ListTile(
                        title: Text(project?.name ?? ''),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            if (project != null) {
                              deleteProject(project);
                            }
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: defaultPadding),

            ElevatedButton(
              onPressed: () {
                try {
                  DateTime? myDate = null;
                  if (_duration != null) {
                    myDate = DateTime.parse(_duration.text!);
                  }

                  Document document = Document(
                    name: _name.text,
                    status: _status,
                    docType: _docType,
                    duration: myDate,
                    doc: _doc,
                    docBase64: doc64,
                    doc_name: docName,
                    users: selectedUsers?.map((user) => user.id).toList(),
                    projects: selectedProjects
                        ?.map((project) => (project.id ?? 0))
                        .toList(),
                  );

                  String name = _name.text;
                  if (widget.document != null) {
                    print('Updated document: ${document.toJson()}');
                    int my_id = widget.document?.id ?? 0;
                    DocumentsApi().updateDocument(my_id, document);

                    _formKey.currentState?.reset();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Информация о документе $name успешно обновлена'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  } else {
                    print('Submitted document: ${document.toJson()}');
                    DocumentsApi().createDocument(document);

                    _formKey.currentState?.reset();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Документ $name успешно создан'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                } catch (e) {
                  String exception = e.toString().substring(10);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(exception),
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              },
              child: Text('Сохранить'),
            ),
          ]),
        ),
      ],
    );
  }
}
