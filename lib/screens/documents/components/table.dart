// import 'package:admin/models/RecentFile.dart';

import 'package:egs/api/document_api.dart';
import 'package:egs/controllers/menu_app_controller.dart';
import 'package:egs/model/document.dart';
import 'package:egs/model/project.dart';
import 'package:egs/model/user.dart';
import 'package:egs/responsive.dart';
import 'package:egs/screens/documents/components/document_form.dart';
import 'package:egs/ui/const.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyTable extends StatefulWidget {
  final Project? initialProject;
  final User? user;

  const MyTable({Key? key, this.initialProject, this.user}) : super(key: key);

  @override
  State<MyTable> createState() => _MyTable();
}

class _MyTable extends State<MyTable> {
  final DocumentsApi dapiService = DocumentsApi();
  late Future<List<Document>?> documents;
  String _selectedParameter = '01';
  final _selectedParameterName = [
    'Договор',
    'Регистрация объекта в государственном реестре',
    'Правоустанавливающие документы',
    'Проектные документы',
    'Экспертиза',
    'Страхование',
    'Разрешительные документы и акты ввода в эксплуатацию',
    'Исполнительно-техническая документация по строительству',
    'Эксплуатационные документы',
    'Обучение персонала',
    'Документы сезонные в эксплуатационный период',
    'Нормативно-правовые акты',
    'Иные документы'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _selectedParameter = '13';
    }

    try {
      documents = dapiService.fetchDocuments();
    } catch (e) {
      String exception = e.toString().substring(10);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(exception),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: [
          SizedBox(
            width: Responsive.screenWidth(context) * 0.5,
            child: DropdownButton<String>(
              isExpanded: true,
              borderRadius: BorderRadius.circular(12),
              value: _selectedParameter,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedParameter = newValue!;
                });
              },
              items: <String>[
                '01',
                '02',
                '03',
                '04',
                '05',
                '06',
                '07',
                '08',
                '09',
                '10',
                '11',
                '12',
                '13'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: SizedBox(
                      width: Responsive.isDesktop(context) ? 400 : 200,
                      child:
                          Text(_selectedParameterName[int.parse(value) - 1])),
                );
              }).toList(),
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            child: FutureBuilder<List<Document>?>(
              future: documents,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('Документов не найдено.');
                } else {
                  List<DataRow> rows = snapshot.data!.where((document) {
                    // Use lowercase for case-insensitive comparison
                    final documentName = document.name.toLowerCase();
                    final searchText = Provider.of<MenuAppController>(context)
                        .search
                        .toLowerCase();
                    if (document.docType == _selectedParameter) {
                      if (widget.initialProject == null &&
                          widget.user == null) {
                        return true;
                      } else if (widget.initialProject != null) {
                        return document.projects!
                            .contains(widget.initialProject?.id);
                      } else if (widget.user != null) {
                        return document.users!.contains(widget.user?.id ?? 0);
                      } else {
                        return false;
                      }
                    } else {
                      return false;
                    }

                    // Check if the project name contains the search text
                  }).map((document) {
                    return DataRow(
                      cells: [
                        DataCell(ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DocumentForm(
                                  document: document,
                                ),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: defaultPadding * 1.5,
                              vertical: defaultPadding /
                                  (Responsive.isMobile(context) ? 2 : 1),
                            ),
                          ),
                          child: Text(document.id.toString()),
                        )),
                        DataCell(Text(document.name)),
                        DataCell(Text(
                            document.duration.toString().substring(0, 10))),
                        DataCell(ElevatedButton(
                          onPressed: () async {},
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: defaultPadding * 1.5,
                              vertical: defaultPadding /
                                  (Responsive.isMobile(context) ? 2 : 1),
                            ),
                          ),
                          child: const Icon(
                            Icons.delete,
                            size: 20.0,
                          ),
                        ))
                        // Add more cells as needed
                      ],
                    );
                  }).toList();

                  return DataTable(
                    columnSpacing: defaultPadding,
                    // minWidth: 600,
                    columns: const [
                      DataColumn(
                        label: Text("Номер"),
                      ),
                      DataColumn(
                        label: Text("Название"),
                      ),
                      DataColumn(
                        label: Text("Срок действия"),
                      ),
                      DataColumn(
                        label: Text("Управление"),
                      ),
                    ],
                    rows: rows,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
