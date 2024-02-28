import 'package:egs/api/project_api.dart';
import 'package:egs/api/service.dart';
import 'package:egs/api/task_api.dart';
import 'package:egs/screens/header.dart';
import 'package:egs/screens/side_menu.dart';
import 'package:egs/ui/const.dart';
import 'package:egs/model/project.dart';
import 'package:egs/model/task.dart';
import 'package:egs/model/user.dart';
import 'package:egs/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:egs/screens/messages/messages.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? initialTask;

  const TaskFormScreen({Key? key, this.initialTask}) : super(key: key);

  @override
  TaskFormScreenState createState() => TaskFormScreenState();
}

class TaskFormScreenState extends State<TaskFormScreen> {
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
        text: widget.initialTask?.completion?.toLocal().toString());
    doneController = TextEditingController(
        text: widget.initialTask?.done?.toLocal().toString());
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

        for (var project in projects) {
          if (project.id == widget.initialTask?.projectId) {
            selectedProject = project;
            break;
          }
        }
      });
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
    return Scaffold(
      appBar: const Header(),
      drawer: const SideMenu(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Visibility(
              visible: widget.initialTask != null,
              child: Column(
                children: [
                  Text(
                    'Чат задачи',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: defaultPadding),
                  MessagesScreen(projectId: widget.initialTask?.id ?? 0),
                  const SizedBox(height: defaultPadding * 3),
                  // Add more widgets as needed...
                ],
              ),
            ),
            Text(
              widget.initialTask == null ? 'Добавить задачу' : 'Изменить задачу',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: defaultPadding),
            Container(
              padding: const EdgeInsets.all(defaultPadding),
              decoration: const BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child:
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Название*'),
                ),
                TextFormField(
                  controller: completionController,
                  decoration:
                      const InputDecoration(labelText: 'Крайний срок выполнения'),
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
                  decoration: const InputDecoration(labelText: 'Дата выполнения'),
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
            const SizedBox(height: defaultPadding),
        
            // Projects
            Container(
              padding: const EdgeInsets.all(defaultPadding),
              decoration: const BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Проекты',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: defaultPadding),
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
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            if (user != null) {
                              deleteProject();
                            }
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: defaultPadding),
            // Users
            Container(
              padding: const EdgeInsets.all(defaultPadding),
              decoration: const BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Пользователи',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: defaultPadding),
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
                          icon: const Icon(Icons.delete),
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
            const SizedBox(height: defaultPadding),
            ElevatedButton(
              onPressed: () {
                saveTask();
              },
              child: const Text('Сохранить'),
            ),
          ],
        ),
      ),
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
        projectId: selectedProject?.id,
        taskToUserIds: selectedUsers ?? [],
      );

      if (widget.initialTask == null) {
        String name = newTask.name;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Задача $name успешно создана'),
            duration: const Duration(seconds: 3),
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardScreen(),
          ),
        );

        // Provider.of<MenuAppController>(context, listen: false)
        // .navigateTo(DashboardScreen());
      } else {
        if (widget.initialTask?.id != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Информация о задаче успешно обновлена'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
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
}
