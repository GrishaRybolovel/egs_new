// import 'package:admin/models/RecentFile.dart';

import 'package:egs/api/project_api.dart';
import 'package:egs/controllers/MenuAppController.dart';
import 'package:egs/model/project.dart';
import 'package:egs/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../ui/const.dart';
import 'edit_project.dart';

class MyTable extends StatefulWidget {
  const MyTable({super.key});

  @override
  State<MyTable> createState() => _MyTable();
}

class _MyTable extends State<MyTable> {
  final ProjectsApiService papiService = ProjectsApiService();
  late Future<List<Project>?> projects;
  String _selectedTypeParameter = '1';
  final _selectedTypeParameterName = ['Эксплуатация', 'Техническое обслуживание', 'СМР', 'СМР'];

  final statuses = ['В работе', 'ПНР', 'Сезон откл.', 'СМР', 'Аварийное откл.'];

  @override
  void initState() {
    super.initState();

    try {
      projects = papiService.getProjects();
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
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: [
          DropdownButton<String>(
            borderRadius: BorderRadius.circular(12),
            value: _selectedTypeParameter,
            onChanged: (String? newValue) {
              setState(() {
                _selectedTypeParameter = newValue!;
              });
            },
            items: <String>['1', '2', '3', '4']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(_selectedTypeParameterName[int.parse(value) - 1]),
              );
            }).toList(),
          ),
          SizedBox(
            width: double.maxFinite,
            child: FutureBuilder<List<Project>?>(
              future: projects,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Loading indicator
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No projects available.');
                } else {
                  List<DataRow> rows = snapshot.data!.where((project) {
                    // Use lowercase for case-insensitive comparison
                    final projectName = project.name.toLowerCase();
                    final searchText = Provider.of<MenuAppController>(context)
                        .search
                        .toLowerCase();

                    // Check if the project name contains the search text
                    return projectName.contains(searchText) && project.projType == _selectedTypeParameter;
                  }).map((project) {
                    return DataRow(
                      cells: [
                        DataCell(ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddEditProjectScreen(
                                  initialProject: project,
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
                          child: Text(project.id.toString()),
                        )),
                        DataCell(Text(project.name)),
                        DataCell(Text(statuses[int.parse(project.status ?? '1') - 1])),
                        DataCell(Text(project.address ?? '')),
                        DataCell(Text(
                            project.dateCreation.toString().substring(0, 10))),
                        DataCell(ElevatedButton(
                          onPressed: () async {
                            try {
                              // Delete the project
                              papiService.deleteProject(project.id ?? 0);
                              String name = project.name;

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Объект $name успешно удален'),
                                  duration: const Duration(seconds: 3),
                                ),
                              );
                            } catch (e) {
                              String exception = e.toString().substring(10);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(exception),
                                  duration: const Duration(seconds: 3),
                                ),
                              );
                            }

                            // Update the UI by triggering a rebuild
                            setState(() {
                              projects = papiService.getProjects();
                              // Re-fetch the project list or update it in some way
                              // You can use a FutureBuilder or another method to fetch the updated project list
                            });
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
                        label: Text("Статус"),
                      ),
                      DataColumn(
                        label: Text("Адрес"),
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
