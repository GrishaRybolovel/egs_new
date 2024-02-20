// import 'package:admin/models/RecentFile.dart';

import 'package:egs/api/mail_api.dart';
import 'package:egs/controllers/MenuAppController.dart';
import 'package:egs/model/mail.dart';
import 'package:egs/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../const.dart';


class MyTable extends StatefulWidget {
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
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: [
          SizedBox(
              width: double.maxFinite,
              child: FutureBuilder<List<Mail>?>(
                future: mails,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // Loading indicator
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('Писем не найдено.');
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
                          DataCell(ElevatedButton(
                            onPressed: () {
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: defaultPadding * 1.5,
                                vertical: defaultPadding /
                                    (Responsive.isMobile(context) ? 2 : 1),
                              ),
                            ),
                            child: Text(mail.id.toString()),
                          )),
                          DataCell(Text(mail.name)),
                          DataCell(Text(mail.created
                              .toString()
                              .substring(0, 10))),
                          DataCell(ElevatedButton(
                            onPressed: () async {
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: defaultPadding * 1.5,
                                vertical: defaultPadding /
                                    (Responsive.isMobile(context) ? 2 : 1),
                              ),
                            ),
                            child: Icon(
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
                      columns: [
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
              )),
        ],
      ),
    );
  }
}
