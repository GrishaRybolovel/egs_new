import 'package:egs/responsive.dart';
import 'package:flutter/material.dart';
import 'package:egs/ui/const.dart';
import 'package:egs/model/task.dart';
import 'package:egs/api/task_api.dart';
import 'package:egs/screens/dashboard/components/task_form.dart';
import 'task_info.dart';

class MyTasks extends StatelessWidget {
  const MyTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
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
        Responsive(
          mobile: TaskInfoGridView(
            crossAxisCount: size.width < 650 ? 2 : 4,
            childAspectRatio: size.width < 650 ? 1.3 : 1,
          ),
          tablet: const TaskInfoGridView(),
          desktop: TaskInfoGridView(
            childAspectRatio: size.width < 1400 ? 1.1 : 1.4,
          ),
        ),
      ],
    );
  }
}

class TaskInfoGridView extends StatefulWidget {
  const TaskInfoGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  TaskInfoGridViewState createState() => TaskInfoGridViewState();
}

class TaskInfoGridViewState extends State<TaskInfoGridView> {
  final TaskApi tapiService = TaskApi();
  String _selectedTypeParameter = '1';
  final _selectedTypeParameterName = [
    'Эксплуатация',
    'Техническое обслуживание',
    'СМР',
    'Производство',
    'Без типа',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(defaultPadding),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(children: [
          DropdownButton<String>(
            borderRadius: BorderRadius.circular(12),
            value: _selectedTypeParameter,
            onChanged: (String? newValue) {
              setState(() {
                _selectedTypeParameter = newValue!;
              });
            },
            items: <String>['1', '2', '3', '4', '5']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(_selectedTypeParameterName[int.parse(value) - 1]),
              );
            }).toList(),
          ),
          FutureBuilder<List<Task>>(
            future: tapiService.fetchTasks(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // While the Future is still running, show a loading indicator.
                return const CircularProgressIndicator();
              } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                // If there's no data or the data is empty, display a message.
                return const Text('Нет заданий.');
              } else if (snapshot.hasError) {
                // If there's an error, throw it to propagate it further.
                throw snapshot.error!;
              } else {
                var tasks_before = snapshot.data!;
                List<dynamic> tasks = [];
                for (var item in tasks_before){
                  if (item.type == int.parse(_selectedTypeParameter)){
                    tasks.add(item);
                  }
                }

                // If the Future is complete and there's data, build the GridView.
                return GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: tasks.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: widget.crossAxisCount,
                    crossAxisSpacing: defaultPadding,
                    mainAxisSpacing: defaultPadding,
                    childAspectRatio: widget.childAspectRatio,
                  ),
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/taskForm',
                            arguments: task);
                      },
                      child: FileInfoCard(info: task),
                    );
                  },
                );
              }
            },
          ),
        ]));
  }
}
