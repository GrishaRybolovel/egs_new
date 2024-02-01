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
        MyTable(),
        SizedBox(
          height: defaultPadding,
        ),
        InkWell(
          onTap: () {
            Provider.of<MenuAppController>(context, listen: false)
                .navigateTo(AddEditProjectScreen());
          },
          child: Container(
            padding: EdgeInsets.all(defaultPadding * 0.75),
            margin: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Text('+Добавить объект'),
          ),
        )
      ],
    );
  }
}
