import 'package:egs/responsive.dart';
import 'package:egs/screens/header.dart';
import 'package:egs/screens/side_menu.dart';
import 'package:egs/ui/const.dart';
import 'package:egs/screens/mails/components/table.dart';
import 'package:flutter/material.dart';

class MailsScreen extends StatefulWidget {
  const MailsScreen({super.key});

  @override
  State<MailsScreen> createState() => _MailsScreen();
}

class _MailsScreen extends State<MailsScreen> {
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
                "Мои письма",
              ),
              ElevatedButton.icon(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: defaultPadding * 1.5,
                    vertical:
                        defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
                  ),
                ),
                onPressed: () {},
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
