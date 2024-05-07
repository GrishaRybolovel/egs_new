// import 'package:admin/models/RecentFile.dart';

import 'package:egs/screens/mails/components/mail_form.dart';
import 'package:egs/api/mail_api.dart';
import 'package:egs/controllers/menu_app_controller.dart';
import 'package:egs/model/mail.dart';
import 'package:egs/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../ui/const.dart';

class MyTable extends StatefulWidget {
  const MyTable({super.key});

  @override
  State<MyTable> createState() => _MyTable();
}

class _MyTable extends State<MyTable> {
  final MailsApi mapiService = MailsApi();
  late Future<List<Mail>?> mails;

  @override
  void initState() {
    super.initState();

    try {
      mails = mapiService.fetchMails();
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
      child: Column(
        children: [
          FutureBuilder<List<Mail>?>(
              future: mails,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('Писем не найдено.');
                } else {
                  List<DataRow> rows = snapshot.data!.where((mail) {
                    // Use lowercase for case-insensitive comparison
                    final mailName = mail.name.toLowerCase();
                    final searchText = Provider.of<MenuAppController>(context)
                        .search
                        .toLowerCase();

                    // Check if the project name contains the search text
                    return mailName.contains(searchText);
                  }).map((mail) {
                    return DataRow(
                      cells: [
                        DataCell(Expanded(
                            flex: 1,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MailFormScreen(
                                      initialMail: mail,
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
                              child: Text(mail.id.toString()),
                            ))),
                        DataCell(Expanded(flex: 2, child: Text(mail.name, maxLines: 3))),
                        DataCell(
                            Expanded(flex: 2, child: Text(mail.naming ?? ''))),
                        DataCell(
                            Expanded(flex: 2, child: Text(mail.numberout ?? ''))),
                        DataCell(
                            Expanded(flex: 2, child: Text(mail.completionout?.toString().substring(0, 10) ?? ''))),
                        DataCell(
                            Expanded(flex: 2, child: Text(mail.numberin ?? ''))),
                        DataCell(
                            Expanded(flex: 2, child: Text(mail.completionin?.toString().substring(0, 10) ?? ''))),
                        DataCell(Expanded(
                            flex: 2,
                            child: Text(
                                mail.created.toString().substring(0, 10)))),
                        DataCell(Expanded(
                            flex: 1,
                            child: ElevatedButton(
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
                            ))),
                      ],
                    );
                  }).toList();

                  return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal, child: DataTable(
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
                        label: Text(
                          "Наименование получ/отправ",
                          maxLines: 2,
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Исходящий номер",
                          maxLines: 2,
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Исходящая дата",
                          maxLines: 2,
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Входящий номер",
                          maxLines: 2,
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Входящая дата",
                          maxLines: 2,
                        ),
                      ),
                      DataColumn(
                        label: Text("Дата создания"),
                      ),
                      DataColumn(
                        label: Text("Управление"),
                      ),
                    ],
                    rows: rows,
                  )));
                }
              },
            ),
        ],
      ),
    );
  }
}
