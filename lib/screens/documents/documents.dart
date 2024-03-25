import 'package:egs/responsive.dart';
import 'package:egs/screens/header.dart';
import 'package:egs/screens/side_menu.dart';
import 'package:egs/ui/const.dart';
import 'package:egs/screens/documents/components/table.dart';
import 'package:egs/screens/documents/components/document_form.dart';
import 'package:flutter/material.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreen();
}

class _DocumentsScreen extends State<DocumentsScreen> {
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
                "Мои документы",
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
                      builder: (context) => const DocumentForm(),
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
    );
  }
}
