import 'package:egs/responsive.dart';
import 'package:egs/const.dart';
import 'package:egs/controllers/MenuAppController.dart';
import 'package:egs/screens/mails/components/table.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class MailsScreen extends StatefulWidget {
  const MailsScreen({super.key});

  @override
  State<MailsScreen> createState() => _MailsScreen();
}

class _MailsScreen extends State<MailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Мои письма",
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
