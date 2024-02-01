// import 'package:admin/models/RecentFile.dart';

import 'package:egs/api/project_api.dart';
import 'package:egs/controllers/MenuAppController.dart';
import 'package:egs/model/project.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../const.dart';
import 'edit_project.dart';

class MyTable extends StatefulWidget {
  @override
  State<MyTable> createState() => _MyTable();
}

class _MyTable extends State<MyTable> {
  final ProjectsApiService papiService = ProjectsApiService();
  late Future<List<Project>?> projects;

  @override
  void initState() {
    super.initState();

    try {
      projects = papiService.getProjects();
    } catch (e){
      String exception = e.toString().substring(10);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
          Text(exception),
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
          Text(
            "Объекты",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(
              width: double.maxFinite,
              child: FutureBuilder<List<Project>?>(
                future: projects,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // Loading indicator
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('No projects available.');
                  } else {
                    List<DataRow> rows = snapshot.data!.where((project) {
                      // Use lowercase for case-insensitive comparison
                      final projectName = project.name.toLowerCase();
                      final searchText = Provider.of<MenuAppController>(context)
                          .search
                          .toLowerCase();

                      // Check if the project name contains the search text
                      return projectName.contains(searchText);
                    }).map((project) {
                      return DataRow(
                        cells: [
                          DataCell(InkWell(
                            onTap: () {
                              Provider.of<MenuAppController>(context,
                                      listen: false)
                                  .navigateTo(AddEditProjectScreen(
                                initialProject: project,
                              ));
                            },
                            child: Container(
                              padding: EdgeInsets.all(defaultPadding * 0.75),
                              margin: EdgeInsets.symmetric(
                                  horizontal: defaultPadding / 2),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Text(project.id.toString()),
                            ),
                          )),
                          DataCell(Text(project.name)),
                          DataCell(Text(project.dateCreation
                              .toString()
                              .substring(0, 10))),
                          DataCell(InkWell(
                            onTap: () async {
                              try {
                                // Delete the project
                                papiService.deleteProject(project.id ?? 0);
                                String name = project.name;

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                    Text('Объект $name успешно удален'),
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                              }catch (e) {
                                String exception = e.toString().substring(10);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text(exception),
                                    duration: Duration(seconds: 3),
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
                            child: Container(
                              padding: EdgeInsets.all(defaultPadding * 0.25),
                              margin: EdgeInsets.symmetric(
                                  horizontal: defaultPadding / 4),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Icon(Icons.delete),
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
