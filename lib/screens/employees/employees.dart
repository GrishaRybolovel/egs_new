import 'package:egs/responsive.dart';
import 'package:egs/screens/header.dart';
import 'package:egs/screens/side_menu.dart';
import 'package:egs/model/user.dart';
import 'package:egs/ui/const.dart';
import 'package:egs/screens/employees/components/table.dart';
import 'package:flutter/material.dart';

class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({super.key});

  @override
  State<EmployeesScreen> createState() => _EmployeesScreen();
}

class _EmployeesScreen extends State<EmployeesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(),
      drawer: const SideMenu(),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Сотрудники",
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
                  Navigator.pushNamed(context, '/userForm');
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
    );
  }
}
