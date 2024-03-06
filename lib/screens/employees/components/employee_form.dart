import 'package:egs/model/user.dart';
import 'package:flutter/material.dart';
import 'package:egs/api/service.dart';
import 'package:egs/screens/employees/employees.dart';
import 'package:egs/screens/header.dart';
import 'package:egs/screens/side_menu.dart';
import 'package:egs/ui/const.dart';

class EmployeeForm extends StatefulWidget {
  final User? user;

  const EmployeeForm({Key? key, this.user}) : super(key: key);

  @override
  _EmployeeFormState createState() => _EmployeeFormState();
}

class _EmployeeFormState extends State<EmployeeForm> {
  late TextEditingController nameController = TextEditingController();
  late TextEditingController surnameController = TextEditingController();
  late TextEditingController lastnameController = TextEditingController();
  late TextEditingController phoneController = TextEditingController();
  late TextEditingController emailController = TextEditingController();
  late TextEditingController addressController = TextEditingController();
  late TextEditingController birthController = TextEditingController();
  late TextEditingController dateofstartController = TextEditingController();
  late TextEditingController innController = TextEditingController();
  late TextEditingController snilsController = TextEditingController();
  late TextEditingController passportController = TextEditingController();
  late TextEditingController postController = TextEditingController();
  late TextEditingController infoaboutrelocateController =
      TextEditingController();
  late TextEditingController attestationController = TextEditingController();
  late TextEditingController qualificationController = TextEditingController();
  late TextEditingController retrainingController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late bool? status = true;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.user?.name ?? '');
    surnameController = TextEditingController(text: widget.user?.surname ?? '');
    lastnameController =
        TextEditingController(text: widget.user?.lastName ?? '');
    phoneController = TextEditingController(text: widget.user?.phone ?? '');
    emailController = TextEditingController(text: widget.user?.email ?? '');
    addressController = TextEditingController(text: widget.user?.address ?? '');
    birthController =
        TextEditingController(text: widget.user?.dateOfBirth?.toLocal().toString());
    dateofstartController =
        TextEditingController(text: widget.user?.dateOfStart?.toLocal().toString());
    innController = TextEditingController(text: widget.user?.inn ?? '');
    snilsController = TextEditingController(text: widget.user?.snils ?? '');
    passportController =
        TextEditingController(text: widget.user?.passport ?? '');
    postController = TextEditingController(text: widget.user?.post ?? '');
    infoaboutrelocateController =
        TextEditingController(text: widget.user?.infoAboutRelocate ?? '');
    attestationController =
        TextEditingController(text: widget.user?.attestation ?? '');
    qualificationController =
        TextEditingController(text: widget.user?.qualification ?? '');
    retrainingController =
        TextEditingController(text: widget.user?.retraining ?? '');
    status = widget.user?.status ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const Header(),
        drawer: const SideMenu(),
        body: SingleChildScrollView(
            child: Column(children: [
          Container(
              padding: const EdgeInsets.all(defaultPadding),
              decoration: const BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Имя*'),
                    ),
                    TextFormField(
                      controller: surnameController,
                      decoration: const InputDecoration(labelText: 'Фамилия*'),
                    ),
                    TextFormField(
                      controller: lastnameController,
                      decoration: const InputDecoration(labelText: 'Отчество*'),
                    ),
                    TextFormField(
                      controller: phoneController,
                      decoration: const InputDecoration(labelText: 'Телефон'),
                    ),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: 'Почта'),
                    ),
                    TextFormField(
                      controller: addressController,
                      decoration: const InputDecoration(labelText: 'Адрес'),
                    ),
                    TextFormField(
                      controller: birthController,
                      decoration: const InputDecoration(labelText: 'Дата рождения'),
                      onTap: () async {
                        DateTime? date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (date != null) {
                          birthController.text =
                              date.toLocal().toString().substring(0, 10);
                        }
                      },
                    ),
                    TextFormField(
                      controller: dateofstartController,
                      decoration: const InputDecoration(labelText: 'Принят на работу'),
                      onTap: () async {
                        DateTime? date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (date != null) {
                          dateofstartController.text =
                              date.toLocal().toString().substring(0, 10);
                        }
                      },
                    ),
                    TextFormField(
                      controller: innController,
                      decoration: const InputDecoration(labelText: 'ИНН'),
                    ),
                    TextFormField(
                      controller: snilsController,
                      decoration: const InputDecoration(labelText: 'Снилс'),
                    ),
                    TextFormField(
                      controller: passportController,
                      decoration: const InputDecoration(labelText: 'Паспорт'),
                    ),
                    TextFormField(
                      controller: postController,
                      decoration: const InputDecoration(labelText: 'Должность'),
                    ),
                    TextFormField(
                      controller: infoaboutrelocateController,
                      decoration: const InputDecoration(labelText: 'Информация о перевода'),
                    ),
                    TextFormField(
                      controller: attestationController,
                      decoration: const InputDecoration(labelText: 'Аттестация'),
                    ),
                    TextFormField(
                      controller: qualificationController,
                      decoration: const InputDecoration(labelText: 'Квалификация'),
                    ),
                    TextFormField(
                      controller: retrainingController,
                      decoration: const InputDecoration(labelText: 'Проф. переподготовка'),
                    ),
                    CheckboxListTile(
                      title: Text('Статус'), // Label for the checkbox
                      value: status, // Current value of the checkbox
                      onChanged: (bool? newValue) {
                        setState(() {
                          status = newValue ?? false; // Update the status when the checkbox value changes
                        });
                      },
                    ),
                    const SizedBox(height: defaultPadding),
                    TextFormField(
                      controller: passwordController,
                      decoration: const InputDecoration(labelText: 'Введите пароль, если хотите поменять его. Будьте аккуратны!'),
                    ),
                    const SizedBox(height: defaultPadding),
                    ElevatedButton(
                      onPressed: () {
                        saveUser();
                      },
                      child: const Text('Сохранить'),
                    ),
                  ])),
        ])));
  }

  void saveUser() async {
    try {
      DateTime? birth;
      DateTime? start;

      if (birthController.text != null && !birthController.text.isEmpty){
        birth = DateTime.parse(birthController.text!);
      }
      if (dateofstartController.text != null && !dateofstartController.text.isEmpty){
        start = DateTime.parse(dateofstartController.text!);
      }
      final User newUser = User(
        name: nameController.text,
        surname: surnameController.text,
        lastName: lastnameController.text,
        phone: phoneController.text,
        email: emailController.text,
        address: addressController.text,
        dateOfBirth: birth,
        dateOfStart: start,
        inn: innController.text,
        snils: snilsController.text,
        passport: passportController.text,
        post: postController.text,
        infoAboutRelocate: infoaboutrelocateController.text,
        attestation: attestationController.text,
        qualification: qualificationController.text,
        retraining: retrainingController.text,
        status: status ?? false,
        password: passwordController.text,
      );

      if (widget.user == null) {
        String name = newUser.name;
        User createdUser = await ApiService().createUser(newUser);

        ScaffoldMessenger.of(this.context).showSnackBar(
          SnackBar(
            content: Text('Пользователь $name успешно создан'),
            duration: const Duration(seconds: 3),
          ),
        );
        Navigator.push(
          this.context,
          MaterialPageRoute(
            builder: (context) => EmployeesScreen(),
          ),
        );
      } else {
        if (widget.user?.id != null) {
          int myId = widget.user?.id ?? 0;

          User updatedUser = await ApiService().updateUser(myId, newUser);

          ScaffoldMessenger.of(this.context).showSnackBar(
            const SnackBar(
              content: Text('Информация о пользователе успешно обновлена'),
              duration: Duration(seconds: 3),
            ),
          );

          Navigator.push(
            this.context,
            MaterialPageRoute(
              builder: (context) => EmployeesScreen(),
            ),
          );
        }
      }
    } catch (e) {
      String exception = e.toString().substring(10);
      ScaffoldMessenger.of(this.context).showSnackBar(
        SnackBar(
          content: Text(exception),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}
