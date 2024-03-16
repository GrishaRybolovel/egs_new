// ignore_for_file: unnecessary_null_comparison

import 'package:egs/api/project_api.dart';
import 'package:egs/ui/const.dart';
import 'package:egs/screens/documents/components/table.dart';
import 'package:egs/screens/documents/components/document_form.dart';
import 'package:egs/model/project.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:egs/responsive.dart';
import 'package:egs/screens/header.dart';
import 'package:egs/screens/side_menu.dart';

import '../projects.dart';
import 'users.dart';

class AddEditProjectScreen extends StatefulWidget {
  final Project? initialProject;

  const AddEditProjectScreen({Key? key, this.initialProject}) : super(key: key);

  @override
  AddEditProjectScreenState createState() => AddEditProjectScreenState();
}

class AddEditProjectScreenState extends State<AddEditProjectScreen> {
  late TextEditingController _projTypeController;
  late TextEditingController _nameController;
  late TextEditingController _regNumController;
  late TextEditingController _contractController;
  late TextEditingController _dateCreationController;
  late TextEditingController _dateNotificationController;
  late TextEditingController _objectTypeController;
  late TextEditingController _addressController;
  late TextEditingController _contactController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _statusController;
  late TextEditingController _seasoningController;
  late TextEditingController _costController;

  @override
  void initState() {
    super.initState();

    _projTypeController =
        TextEditingController(text: widget.initialProject?.projType ?? '1');
    _nameController =
        TextEditingController(text: widget.initialProject?.name ?? '');
    _regNumController =
        TextEditingController(text: widget.initialProject?.regNum);
    _contractController =
        TextEditingController(text: widget.initialProject?.contract);
    _dateCreationController = TextEditingController(
        text: widget.initialProject?.dateCreation?.toLocal().toString());
    _dateNotificationController = TextEditingController(
        text: widget.initialProject?.dateNotification?.toLocal().toString());
    _objectTypeController =
        TextEditingController(text: widget.initialProject?.objectType);
    _addressController =
        TextEditingController(text: widget.initialProject?.address);
    _contactController =
        TextEditingController(text: widget.initialProject?.contact);
    _phoneController =
        TextEditingController(text: widget.initialProject?.phone);
    _emailController =
        TextEditingController(text: widget.initialProject?.email);
    _statusController =
        TextEditingController(text: widget.initialProject?.status ?? '1');
    _seasoningController =
        TextEditingController(text: widget.initialProject?.seasoning ?? '1');
    _costController = TextEditingController(
        text: widget.initialProject?.cost.toString() ?? (0.0).toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const Header(),
        drawer: const SideMenu(),
        body: SingleChildScrollView(
            child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(defaultPadding),
              decoration: const BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.initialProject == null
                          ? 'Добавить объект'
                          : 'Изменить объект',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: defaultPadding),
                    DropdownButtonFormField<String>(
                      value: _projTypeController.text,
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
                        setState(() {
                          _projTypeController.text = value!;
                        });
                      },
                      decoration:
                          const InputDecoration(labelText: 'Статус объекта'),
                    ),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Название*'),
                    ),
                    TextFormField(
                      controller: _regNumController,
                      decoration:
                          const InputDecoration(labelText: 'Рег. номер*'),
                    ),
                    TextFormField(
                      controller: _contractController,
                      decoration: const InputDecoration(labelText: 'Договор'),
                    ),
                    TextFormField(
                      controller: _dateCreationController,
                      decoration:
                          const InputDecoration(labelText: 'Дата создания*'),
                      onTap: () async {
                        DateTime? date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (date != null) {
                          _dateCreationController.text =
                              date.toLocal().toString().substring(0, 10);
                        }
                      },
                    ),
                    TextFormField(
                      controller: _dateNotificationController,
                      decoration:
                          const InputDecoration(labelText: 'Дата оповещений*'),
                      onTap: () async {
                        DateTime? date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (date != null) {
                          _dateNotificationController.text =
                              date.toLocal().toString().substring(0, 10);
                        }
                      },
                    ),
                    TextFormField(
                      controller: _objectTypeController,
                      decoration:
                          const InputDecoration(labelText: 'Тип объекта'),
                    ),
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(labelText: 'Адрес'),
                    ),
                    TextFormField(
                      controller: _contactController,
                      decoration: const InputDecoration(labelText: 'Контакт'),
                    ),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(labelText: 'Телефон'),
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Почта'),
                    ),
                    DropdownButtonFormField<String>(
                      value: _statusController.text,
                      items: const [
                        DropdownMenuItem(
                          value: '1',
                          child: Text('Эксплуатация'),
                        ),
                        DropdownMenuItem(
                          value: '2',
                          child: Text('Техническое обслуживание'),
                        ),
                        DropdownMenuItem(
                          value: '3',
                          child: Text('СМР'),
                        ),
                        DropdownMenuItem(
                          value: '4',
                          child: Text('Производство'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _statusController.text = value!;
                        });
                      },
                      decoration:
                          const InputDecoration(labelText: 'Тип объекта'),
                    ),
                    DropdownButtonFormField<String>(
                      value: _seasoningController.text,
                      items: const [
                        DropdownMenuItem(
                          value: '1',
                          child: Text('Сезонная'),
                        ),
                        DropdownMenuItem(
                          value: '2',
                          child: Text('Круглогодичная'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _seasoningController.text = value!;
                        });
                      },
                      decoration:
                          const InputDecoration(labelText: 'Сезонность'),
                    ),
                    TextFormField(
                      controller: _costController,
                      decoration: const InputDecoration(
                          labelText: 'Цена обслуживания*'),
                    ),
                    const SizedBox(height: defaultPadding),
                    TextButton(
                      onPressed: () {
                        _saveOrUpdateProject();
                      },
                      child: const Text('Сохранить'),
                    ),
                  ]),
            ),
            const SizedBox(height: defaultPadding),
            SelectUsers(
              initialProject: widget.initialProject,
            ),
            const SizedBox(height: defaultPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Документы",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                ElevatedButton.icon(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: defaultPadding * 1.5,
                      vertical: defaultPadding /
                          (Responsive.isMobile(context) ? 2 : 1),
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
            MyTable(
              initialProject: widget.initialProject,
            ),
          ],
        )
        )
    );
  }

  void _saveOrUpdateProject() async {
    try {
      final String projType = _projTypeController.text;
      final String projectName = _nameController.text;
      final String regNum = _regNumController.text;
      final String contract = _contractController.text;
      final String dateCreation = _dateCreationController.text;
      final String dateNotification = _dateNotificationController.text;
      final String objectType = _objectTypeController.text;
      final String address = _addressController.text;
      final String contact = _contactController.text;
      final String phone = _phoneController.text;
      final String email = _emailController.text;
      final String status = _statusController.text;
      final String seasoning = _seasoningController.text;
      final double cost = double.parse(_costController.text);

      Project project = Project(
        projType: projType,
        name: projectName,
        regNum: regNum,
        contract: contract,
        dateCreation:
            dateCreation != null ? DateTime.parse(dateCreation) : null,
        dateNotification:
            dateNotification != null ? DateTime.parse(dateNotification) : null,
        objectType: objectType,
        address: address,
        contact: contact,
        phone: phone,
        email: email,
        status: status,
        seasoning: seasoning,
        cost: cost,
        // projectToUser: [], // Add projectToUser as needed
        // Add other properties as needed
      );

      final ProjectsApiService papiService = ProjectsApiService();

      if (widget.initialProject == null) {
        // Add logic to save the new project
        String name = project.name;
        var createdProject = await papiService.createProject(project);

        if (createdProject != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Объект $name успешно создан'),
              duration: const Duration(seconds: 3),
            ),
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProjectsScreen()),
          );
        }
      } else {
        int myId = widget.initialProject?.id ?? 0;
        var updatedProject = await papiService.updateProject(myId, project);
        if (updatedProject != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Информация об объекте успешно обновлена.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      String exception = e.toString();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(exception),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}
