import 'package:egs/screens/header.dart';
import 'package:egs/screens/side_menu.dart';
import 'package:flutter/material.dart';
import 'components/tasks.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      drawer: SideMenu(),
      appBar: Header(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MyTasks(),
          ],
        ),
      ),
    );
  }
}
