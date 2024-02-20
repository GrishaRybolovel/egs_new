import 'package:egs/responsive.dart';
import 'package:egs/const.dart';
import 'package:egs/controllers/MenuAppController.dart';
import 'package:egs/screens/employees/components/table.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({super.key});

  @override
  State<EmployeesScreen> createState() => _EmployeesScreen();
}

class _EmployeesScreen extends State<EmployeesScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
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
