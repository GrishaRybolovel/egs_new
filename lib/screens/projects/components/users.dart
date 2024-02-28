import 'package:flutter/material.dart';
import 'package:egs/api/project_api.dart';
import 'package:egs/api/service.dart';
import 'package:egs/model/project.dart';
import 'package:egs/model/user.dart';
import 'package:egs/ui/const.dart';

class SelectUsers extends StatefulWidget {
  final Project? initialProject;

  const SelectUsers({Key? key, this.initialProject}) : super(key: key);

  @override
  SelectUsersState createState() => SelectUsersState();
}

class SelectUsersState extends State<SelectUsers> {
  final ApiService usersApiService = ApiService();
  final ProjectsApiService papiService = ProjectsApiService();
  List<User>? selectedUsers = [];
  late List<User> allUsers = [];

  @override
  void initState() {
    super.initState();
    selectedUsers = widget.initialProject?.projectToUser;
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      final users = await usersApiService.getUsers();
      setState(() {
        allUsers = users;
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

  Future<void> saveProject() async {
    try {
      if (widget.initialProject != null) {
        List<User>? copiedUsers = List.from(selectedUsers ?? []);

        widget.initialProject?.projectToUser?.clear();
        widget.initialProject?.projectToUser?.addAll(copiedUsers);


        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Пользователи объекта успешно изменены'),
            duration: Duration(seconds: 3),
          ),
        );
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

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    } else {
                      print('1');
                    }
                  },
                ),
              );
            },
          ),
          TextButton(
            onPressed: () {
              saveProject();
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }
}
