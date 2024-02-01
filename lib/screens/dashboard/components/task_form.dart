import 'package:egs/api/project_api.dart';
import 'package:egs/api/service.dart';
import 'package:egs/api/task_api.dart';
import 'package:egs/const.dart';
import 'package:egs/controllers/MenuAppController.dart';
import 'package:egs/model/project.dart';
import 'package:egs/model/task.dart';
import 'package:egs/model/user.dart';
import 'package:egs/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:egs/screens/messages/messages.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? initialTask;

  TaskFormScreen({Key? key, this.initialTask}) : super(key: key);

  @override
  _TaskFormScreenState createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  // Basic task fields1
  late TextEditingController nameController = TextEditingController();
  late TextEditingController completionController = TextEditingController();
  late TextEditingController doneController = TextEditingController();

  // Foreign keys task fields
  final ApiService usersApiService = ApiService();
  final ProjectsApiService papiService = ProjectsApiService();
  List<User>? selectedUsers = [];
  late List<User> allUsers = [];

  Project? selectedProject;
  late List<Project>? allProjects = [];

  final TaskApi tapiService = TaskApi();

  @override
  void initState() {
    super.initState();

    nameController =
        TextEditingController(text: widget.initialTask?.name ?? '');
    completionController = TextEditingController(
        text: widget.initialTask?.completion?.toLocal().toString() ?? null);
    doneController = TextEditingController(
        text: widget.initialTask?.done?.toLocal().toString() ?? null);
    selectedUsers = widget.initialTask?.taskToUserIds ?? [];

    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    try {
      final users = await usersApiService.getUsers();
      final projects = await papiService.getProjects();

      setState(() {
        allUsers = users;
        allProjects = projects;

        if (projects != null) {
          for (var project in projects) {
            if (project.id == widget.initialTask?.projectId) {
              selectedProject = project;
              break;
            }
          }
        }
      });
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: widget.initialTask != null,
          child: Column(
            children: [
              Text(
                'Чат задачи',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: defaultPadding),
              MessagesScreen(projectId: widget.initialTask?.id ?? 0),
              SizedBox(height: defaultPadding * 3),
              // Add more widgets as needed...
            ],
          ),
        ),
        Text(
          widget.initialTask == null ? 'Добавить задачу' : 'Изменить задачу',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(height: defaultPadding),
        Container(
          padding: EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Название*'),
            ),
            TextFormField(
              controller: completionController,
              decoration: InputDecoration(labelText: 'Крайний срок выполнения'),
              onTap: () async {
                DateTime? date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (date != null) {
                  completionController.text =
                      date.toLocal().toString().substring(0, 10);
                }
              },
            ),
            TextFormField(
              controller: doneController,
              decoration: InputDecoration(labelText: 'Дата выполнения'),
              onTap: () async {
                DateTime? date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (date != null) {
                  doneController.text =
                      date.toLocal().toString().substring(0, 10);
                }
              },
            ),
          ]),
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
                'Проекты',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: defaultPadding),
              DropdownButton<Project>(
                value: null,
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
              ),

              // List of selected users with delete button

              ListView.builder(
                shrinkWrap: true,
                itemCount: (selectedProject == null) ? 0 : 1,
                itemBuilder: (context, index) {
                  final user = selectedProject;
                  return ListTile(
                    title: Text(user?.name ?? ''),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        if (user != null) {
                          deleteProject();
                        } else {
                          print('1');
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
                items: allUsers.map((user) {
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
                        } else {
                          print('1');
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
            saveTask();
          },
          child: Text('Сохранить'),
        ),
      ],
    );
  }

  void saveTask() async {
    try {
      User author = await ApiService().fetchUserData();
      final Task newTask = Task(
        name: nameController.text,
        authorId: author.id,
        created: null,
        completion: null,
        done: null,
        projectId: selectedProject?.id ?? null,
        taskToUserIds: selectedUsers ?? [],
      );

      if (widget.initialTask == null) {
        String name = newTask.name;
        var createdTask = await tapiService.createTask(newTask);
        if (createdTask != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Задача $name успешно создана'),
              duration: Duration(seconds: 3),
            ),
          );
          Provider.of<MenuAppController>(context, listen: false)
              .navigateTo(DashboardScreen());
        }
      } else {
        if (widget.initialTask?.id != null) {
          int my_id = widget.initialTask?.id ?? 0;
          var updatedTask = await tapiService.updateTask(my_id, newTask);
          if (updatedTask != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Информация о задаче успешно обновлена'),
                duration: Duration(seconds: 3),
              ),
            );
          }
        }
      }
    } catch (e) {
      print('1');
      String exception = e.toString().substring(10);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(exception),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}
