import 'package:flutter/material.dart';
import 'package:egs/api/project_api.dart';
import 'package:egs/api/service.dart';
import 'package:egs/model/project.dart';
import 'package:egs/model/user.dart';
import 'package:egs/const.dart';

class SelectUsers extends StatefulWidget {
  final Project? initialProject;

  const SelectUsers({Key? key, this.initialProject}) : super(key: key);

  @override
  _SelectUsersState createState() => _SelectUsersState();
}

class _SelectUsersState extends State<SelectUsers> {
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
        int my_id = widget.initialProject?.id ?? 0;
        List<User>? copiedUsers = List.from(selectedUsers ?? []);

        widget.initialProject?.projectToUser?.clear();
        widget.initialProject?.projectToUser?.addAll(copiedUsers);

        var updatedProject = await papiService.updateProject(my_id, widget.initialProject!);

        if (updatedProject != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Пользователи объекта успешно изменены'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e){
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
                    if(user != null) {
                      deleteUser(user);
                    }
                    else{
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
            child: Text('Сохранить'),
          ),
        ],
      ),
    );
  }
}
