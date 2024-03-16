import 'package:egs/responsive.dart';
import 'package:flutter/material.dart';
import 'package:egs/ui/const.dart';
import 'package:egs/model/task.dart';
import 'package:egs/api/task_api.dart';
import 'task_info.dart';

class MyTasks extends StatefulWidget {
  const MyTasks({super.key});

  @override
  MyTasksState createState() => MyTasksState();
}

class MyTasksState extends State<MyTasks> {
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    getTasks().then(
      (value) {
        tasks = value;
        setState(() {});
      },
    );
  }

  Future<List<Task>> getTasks() async {
    final newTasks = await TaskApi().fetchTasks();
    return newTasks;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Мои задания",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            ElevatedButton.icon(
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: defaultPadding * 1.5,
                  vertical:
                      defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/taskForm');
              },
              icon: const Icon(Icons.add),
              label: const Text("Создать"),
            ),
          ],
        ),
        const SizedBox(height: defaultPadding),
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  const Text("Просроченный"),
                  TaskInfoGridView(
                      tasks: tasks
                          .where((task) =>
                              task.completion?.isBefore(DateTime.now()) == true)
                          .toList()),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  const Text("В работе"),
                  TaskInfoGridView(
                      tasks: tasks
                          .where((task) =>
                              task.completion?.isBefore(DateTime.now()) ==
                              false)
                          .toList()),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  const Text("Закрытые"),
                  TaskInfoGridView(
                      tasks: tasks.where((task) => task.done != null).toList()),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}

class TaskInfoGridView extends StatefulWidget {
  const TaskInfoGridView({super.key, required this.tasks});

  final List<Task> tasks;

  @override
  TaskInfoGridViewState createState() => TaskInfoGridViewState();
}

class TaskInfoGridViewState extends State<TaskInfoGridView> {
  final TaskApi tapiService = TaskApi();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.tasks.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: Responsive.isMobile(context) ? 2 : 4,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: Responsive.isMobile(context) ? 1.3 : 1,
      ),
      itemBuilder: (context, index) {
        final task = widget.tasks[index];
        return InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/taskForm', arguments: task);
          },
          child: FileInfoCard(info: task),
        );
      },
    );
  }
}
