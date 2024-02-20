import 'package:egs/responsive.dart';
import 'package:egs/const.dart';
import 'package:egs/controllers/MenuAppController.dart';
import 'package:egs/screens/documents/components/table.dart';
import 'package:egs/screens/documents/components/document_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreen();
}

class _DocumentsScreen extends State<DocumentsScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Мои документы",
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
                    .navigateTo(DocumentForm());
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
