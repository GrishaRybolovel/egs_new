import 'package:egs/responsive.dart';
import 'package:egs/const.dart';
import 'package:egs/controllers/MenuAppController.dart';
import 'package:egs/screens/projects/components/table.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/edit_project.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreen();
}

class _ProjectsScreen extends State<ProjectsScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Мои объекты",
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
                Provider.of<MenuAppController>(context, listen: false)
                    .navigateTo(AddEditProjectScreen());
              },
              icon: Icon(Icons.add),
              label: Text("Создать"),
            ),
          ],
        ),
        SizedBox(height: defaultPadding),
        MyTable(),
      ],
    );
  }
}
