// import 'package:admin/models/RecentFile.dart';

import 'package:egs/api/service.dart';
import 'package:egs/controllers/MenuAppController.dart';
import 'package:egs/model/user.dart';
import 'package:egs/responsive.dart';
import 'package:egs/ui/const.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyTable extends StatefulWidget {
  const MyTable({super.key});

  @override
  State<MyTable> createState() => _MyTable();
}

class _MyTable extends State<MyTable> {
  final ApiService apiService = ApiService();
  late Future<List<User>?> users;

  @override
  void initState() {
    super.initState();

    try {
      users = apiService.getUsers();
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
            child: FutureBuilder<List<User>?>(
              future: users,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Loading indicator
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('Пользователей.');
                } else {
                  List<DataRow> rows = snapshot.data!.where((user) {
                    // Use lowercase for case-insensitive comparison
                    final userName =
                        '${user.name.toLowerCase()} ${user.surname.toLowerCase()} ${user.lastName?.toLowerCase() ?? ''}';
                    final searchText = Provider.of<MenuAppController>(context)
                        .search
                        .toLowerCase();

                    // Check if the project name contains the search text
                    return userName.contains(searchText);
                  }).map((user) {
                    return DataRow(
                      cells: [
                        DataCell(ElevatedButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: defaultPadding * 1.5,
                              vertical: defaultPadding /
                                  (Responsive.isMobile(context) ? 2 : 1),
                            ),
                          ),
                          child: Text(user.id.toString()),
                        )),
                        DataCell(Text(user.toString())),
                        DataCell(InkWell(
                          onTap: () {},
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: user.status ? Colors.blue : Colors.grey,
                                width: 2,
                              ),
                            ),
                            child: user.status
                                ? const Icon(
                                    Icons.check,
                                    size: 20,
                                    color: Colors.blue,
                                  )
                                : const SizedBox(),
                          ),
                        )),
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
                        label: Text("Имя"),
                      ),
                      DataColumn(
                        label: Text("Статус"),
                      ),
                      DataColumn(
                        label: Text("Действие"),
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
