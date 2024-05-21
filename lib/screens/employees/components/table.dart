// import 'package:admin/models/RecentFile.dart';

import 'package:egs/api/service.dart';
import 'package:egs/controllers/menu_app_controller.dart';
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
      width: Responsive.screenWidth(context) * 0.9,
      padding: const EdgeInsets.all(defaultPadding),
      child: Column(
        children: [
          SizedBox(
            width: double.maxFinite,
            child: FutureBuilder<List<User>?>(
              future: users,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
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
                      cells: Responsive.isDesktop(context)
                          ? [
                              DataCell(ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/userForm',
                                      arguments: user);
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: defaultPadding * 1.5,
                                    vertical: defaultPadding /
                                        (Responsive.isMobile(context) ? 2 : 1),
                                  ),
                                ),
                                child: Text(user.id.toString()),
                              )),
                              DataCell(Text(
                                user.toString(),
                                maxLines: 3,
                              )),
                              DataCell(Text(user.email)),
                              DataCell(InkWell(
                                onTap: () {},
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      width: 2,
                                    ),
                                  ),
                                  child: user.status
                                      ? const Icon(
                                          Icons.check,
                                          size: 20,
                                        )
                                      : const SizedBox(),
                                ),
                              )),
                              DataCell(ElevatedButton(
                                onPressed: () async {
                                  if (user.id != null) {
                                    await deleteUser(user.id!);
                                  }
                                },
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
                            ]
                          : [
                              DataCell(ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/userForm',
                                      arguments: user);
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: defaultPadding * 1.5,
                                    vertical: defaultPadding /
                                        (Responsive.isMobile(context) ? 2 : 1),
                                  ),
                                ),
                                child: Text(user.id.toString()),
                              )),
                              DataCell(Text(
                                user.toString(),
                                maxLines: 3,
                              )),
                              DataCell(InkWell(
                                onTap: () {},
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: user.status
                                          ? Colors.blue
                                          : Colors.grey,
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
                                onPressed: () async {
                                  if (user.id != null) {
                                    await deleteUser(user.id!);
                                  }
                                },
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

                  return Responsive.isDesktop(context)
                      ? DataTable(
                          border: TableBorder.all(
                            width: 3,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
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
                              label: Text("Почта"),
                            ),
                            DataColumn(
                              label: Text("Статус"),
                            ),
                            DataColumn(
                              label: Text("Действие"),
                            ),
                          ],
                          rows: rows,
                        )
                      : DataTable(
                          border: TableBorder.all(
                            width: 3,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
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

  Future<bool> deleteUser(int userId) async {
    try {
      ApiService().deleteUser(userId);

      setState(() {
        users = apiService.getUsers();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Пользователь успешно удален'),
          duration: const Duration(seconds: 3),
        ),
      );
      return true;
    } catch (e) {
      String exception = e.toString().substring(10);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(exception),
          duration: const Duration(seconds: 3),
        ),
      );

      return false;
    }
  }
}

class PopupWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 100,
      color: Colors.blue,
      child: Center(
        child: Text('Popup Window'),
      ),
    );
  }
}

class PopupOverlay extends StatefulWidget {
  @override
  _PopupOverlayState createState() => _PopupOverlayState();
}

class _PopupOverlayState extends State<PopupOverlay> {
  OverlayEntry? _overlayEntry;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showOverlay(context);
      },
      child: Container(
        width: 100,
        height: 50,
        color: Colors.transparent,
        // This container is just a placeholder for the DataCell
      ),
    );
  }

  void _showOverlay(BuildContext context) {
    final overlay = Overlay.of(context)!;

    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return Positioned(
          top: 50, // Adjust position as needed
          left: 50, // Adjust position as needed
          child: PopupWidget(),
        );
      },
    );

    overlay.insert(_overlayEntry!);
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }
}
