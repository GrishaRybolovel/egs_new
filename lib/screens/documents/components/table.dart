// import 'package:admin/models/RecentFile.dart';

import 'package:egs/api/document_api.dart';
import 'package:egs/controllers/MenuAppController.dart';
import 'package:egs/model/document.dart';
import 'package:egs/screens/documents/components/document_form.dart';
import 'package:egs/model/project.dart';
import 'package:egs/responsive.dart';
import 'package:egs/ui/const.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyTable extends StatefulWidget {
  final Project? initialProject;

  const MyTable({Key? key, this.initialProject}) : super(key: key);

  @override
  State<MyTable> createState() => _MyTable();
}

class _MyTable extends State<MyTable> {
  final DocumentsApi dapiService = DocumentsApi();
  late Future<List<Document>?> documents;

  @override
  void initState() {
    super.initState();

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
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.maxFinite,
            child: FutureBuilder<List<Document>?>(
              future: documents,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Loading indicator
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
                    if (widget.initialProject == null) {
                      return documentName.contains(searchText);
                    } else {
                      return document.projects!
                          .contains(widget.initialProject?.id);
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
                        label: Text("Дата"),
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
