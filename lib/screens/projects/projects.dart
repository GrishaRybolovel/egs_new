import 'package:egs/responsive.dart';
import 'package:egs/screens/header.dart';
import 'package:egs/screens/side_menu.dart';
import 'package:egs/ui/const.dart';
import 'package:egs/screens/projects/components/table.dart';
import 'package:flutter/material.dart';

import 'components/edit_project.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreen();
}

class _ProjectsScreen extends State<ProjectsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(),
      drawer: const SideMenu(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Мои объекты",
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddEditProjectScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Создать"),
                ),
              ],
            ),
            const SizedBox(height: defaultPadding),
            const MyTable(),
          ],
        ),
      ),
    );
  }
}
