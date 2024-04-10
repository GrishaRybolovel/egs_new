import 'package:appflowy_board/appflowy_board.dart';
import 'package:egs/responsive.dart';
import 'package:egs/screens/dashboard/components/scrum_card.dart';
import 'package:egs/screens/dashboard/components/scrum_card_item.dart';
import 'package:flutter/material.dart';
import 'package:egs/ui/const.dart';
import 'package:egs/model/task.dart';
import 'package:egs/api/task_api.dart';
import 'package:uuid/uuid.dart';
import 'task_info.dart';

class MyTasks extends StatefulWidget {
  const MyTasks({super.key});

  @override
  MyTasksState createState() => MyTasksState();
}

class MyTasksState extends State<MyTasks> {
  List<Task> tasks = [];
  bool loading = true;
  final AppFlowyBoardController controller = AppFlowyBoardController(
    onMoveGroup: (fromGroupId, fromIndex, toGroupId, toIndex) {
      debugPrint('Move item from $fromIndex to $toIndex');
    },
    onMoveGroupItem: (groupId, fromIndex, toIndex) {
      debugPrint('Move $groupId:$fromIndex to $groupId:$toIndex');
    },
    onMoveGroupItemToGroup: (fromGroupId, fromIndex, toGroupId, toIndex) {
      debugPrint('Move $fromGroupId:$fromIndex to $toGroupId:$toIndex');
    },
  );

  final AppFlowyBoardScrollController scrollController =
      AppFlowyBoardScrollController();

  @override
  void initState() {
    super.initState();
    refreshTasks();
  }

  Future<void> refreshTasks() async {
    var newTasks = await TaskApi().fetchTasks();
    tasks = newTasks;
  }

  void getGroups() {
    List<ScrumCard> readyItems = [];
    List<ScrumCard> inProgressItems = [];
    List<ScrumCard> doneItems = [];

    for (final task in tasks) {
      if (task.completion == null && task.done == null) {
        readyItems.add(
          ScrumCard(
              title: task.name,
              content: task.description ?? '',
              index: task.id ?? 0,
              scrumColumn: ScrumColumn.todo),
        );
      } else if (task.completion != null && task.done == null) {
        inProgressItems.add(
          ScrumCard(
              title: task.name,
              content: task.description ?? '',
              index: task.id ?? 0,
              scrumColumn: ScrumColumn.doing),
        );
      } else if (task.done?.isBefore(DateTime.now()) == true) {
        doneItems.add(
          ScrumCard(
              title: task.name,
              content: task.description ?? '',
              index: task.id ?? 0,
              scrumColumn: ScrumColumn.done),
        );
      }
    }

    final readyGroup = AppFlowyGroupData(
      id: 'ready',
      name: 'ready',
      items: List<AppFlowyGroupItem>.from(readyItems),
    );

    final inProgressGroup = AppFlowyGroupData(
      id: 'inProgress',
      name: 'inProgress',
      items: List<AppFlowyGroupItem>.from(inProgressItems),
    );

    final doneGroup = AppFlowyGroupData(
      id: 'done',
      name: 'done',
      items: List<AppFlowyGroupItem>.from(doneItems),
    );

    controller.addGroup(readyGroup);
    controller.addGroup(inProgressGroup);
    controller.addGroup(doneGroup);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: refreshTasks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          getGroups();
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Мои задания",
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  ElevatedButton.icon(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: defaultPadding * 1.5,
                        vertical: defaultPadding /
                            (Responsive.isMobile(context) ? 2 : 1),
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
              SizedBox(
                width: 1000,
                height: 300,
                child: AppFlowyBoard(
                  config: const AppFlowyBoardConfig(),
                  boardScrollController: scrollController,
                  groupConstraints: const BoxConstraints.tightFor(width: 320),
                  headerBuilder: (context, groupData) {
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        groupData.headerData.groupName,
                        style: const TextStyle(fontSize: 20),
                      ),
                    );
                  },
                  controller: controller,
                  cardBuilder: (context, group, groupItem) {
                    final scrumCard = groupItem as ScrumCard;
                    return AppFlowyGroupCard(
                      key: ValueKey(scrumCard.id),
                      child: ScrumCardItem(
                          title: scrumCard.title,
                          assignedTo: "All",
                          content: scrumCard.content),
                    );
                  },
                ),
              ),
            ],
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Expanded(
              child: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error ${snapshot.error}'),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

class TextItem extends AppFlowyGroupItem {
  final String s;
  TextItem(this.s);

  @override
  String get id => s;
}
