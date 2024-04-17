import 'package:egs/api/project_api.dart';
import 'package:egs/model/journal.dart';
import 'package:egs/ui/const.dart';
import 'package:flutter/material.dart';

class JournalScreen extends StatefulWidget {
  final int projectId;

  const JournalScreen({Key? key, required this.projectId}) : super(key: key);

  @override
  _JournalScreenState createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  late Future<List<Journal>> statusChanges;
  Journal journal = Journal(projectId: 1, type: '2');
  TextEditingController typeController = TextEditingController(text: '2');
  TextEditingController valueController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    journal = Journal(projectId: widget.projectId, type: '2');

    fetchData();
  }

  Future<void> fetchData() async {
    statusChanges = ProjectsApiService().getJournal(widget.projectId);
  }

  void _showNewStatusChoiceChangeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Добавить изменение цены/статуса'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              DropdownButtonFormField<String>(
                value: typeController.text,
                items: const [
                  DropdownMenuItem(
                    value: '1',
                    child: Text('Статус'),
                  ),
                  DropdownMenuItem(
                    value: '2',
                    child: Text('Цена'),
                  ),
                ],
                onChanged: (value) {
                  journal.type = value!;
                  setState(() {
                    typeController.text = value!;
                    print(typeController.text);
                  });
                },
                decoration: InputDecoration(labelText: 'Тип изменения'),
              ),
              if (typeController.text == '2')
                TextFormField(
                  controller: valueController,
                  onChanged: (value) {
                    journal.value = double.parse(value);
                  },
                  decoration: InputDecoration(labelText: 'Значение'),
                )
              else
                DropdownButtonFormField<String>(
                  value: statusController.text,
                  items: const [
                    DropdownMenuItem(
                      value: '1',
                      child: Text('В работе'),
                    ),
                    DropdownMenuItem(
                      value: '2',
                      child: Text('ПНР'),
                    ),
                    DropdownMenuItem(
                      value: '3',
                      child: Text('Сезон откл.'),
                    ),
                    DropdownMenuItem(
                      value: '4',
                      child: Text('СМР'),
                    ),
                    DropdownMenuItem(
                      value: '5',
                      child: Text('Аварийное откл.'),
                    ),
                  ],
                  onChanged: (value) {
                    journal.type = value!;
                    setState(() {
                      statusController.text = value!;
                    });
                  },
                  decoration:
                      const InputDecoration(labelText: 'Статус объекта'),
                ),
              TextFormField(
                controller: dateController,
                decoration: const InputDecoration(labelText: 'Дата'),
                onTap: () async {
                  DateTime? date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    dateController.text =
                        date.toLocal().toString().substring(0, 10);
                    journal.date = date;
                  }
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Отменить'),
            ),
            TextButton(
              onPressed: () {
                ProjectsApiService().createJournal(journal);
                setState(() {
                  statusChanges =
                      ProjectsApiService().getJournal(widget.projectId);
                });
                Navigator.of(context).pop();
              },
              child: Text('Сохранить'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(height: defaultPadding),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Журнал', style: Theme.of(context).textTheme.titleMedium),
          ElevatedButton(
            onPressed: () {
              _showNewStatusChoiceChangeDialog(context);
            },
            child: Text('Добавить изменение цены/статуса'),
          ),
        ],
      ),
      SizedBox(height: defaultPadding),
      Container(
        padding: const EdgeInsets.all(defaultPadding),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        height: 300,
        child: SingleChildScrollView(
            child: Column(children: [
          FutureBuilder<List<Journal>>(
              future: statusChanges,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final responseStatusChnages = snapshot.data ?? [];

                  List<DataRow> rows = responseStatusChnages!.map((row) {
                    return DataRow(cells: [
                      DataCell(Text(row.date.toString().substring(0, 10))),
                      DataCell(Text(row.value.toString())),
                    ]);
                  }).toList();

                  return SizedBox(
                    height: 300,
                    width: double.maxFinite,
                    child: DataTable(
                      columnSpacing: defaultPadding,
                      // minWidth: 600,
                      columns: const [
                        DataColumn(
                          label: Text("Дата"),
                        ),
                        DataColumn(
                          label: Text("Цена"),
                        ),
                      ],
                      rows: rows,
                    ),
                  );
                }
              })
        ])),
      ),
    ]);
  }
}
