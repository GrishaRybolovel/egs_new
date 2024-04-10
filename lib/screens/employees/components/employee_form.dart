import 'package:egs/api/service.dart';
import 'package:egs/api/task_api.dart';
import 'package:egs/model/user.dart';
import 'package:egs/responsive.dart';
import 'package:egs/screens/documents/components/document_form.dart';
import 'package:egs/screens/documents/components/table.dart';
import 'package:egs/screens/employees/employees.dart';
import 'package:egs/screens/header.dart';
import 'package:egs/screens/side_menu.dart';
import 'package:egs/ui/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class EmployeeForm extends StatefulWidget {
  final User? user;

  const EmployeeForm({Key? key, this.user}) : super(key: key);

  @override
  _EmployeeFormState createState() => _EmployeeFormState();
}

class _EmployeeFormState extends State<EmployeeForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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

  late Future<Map<String, dynamic>?> tasksByDate;

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
    birthController = TextEditingController(
        text: widget.user?.dateOfBirth?.toLocal().toString().substring(0, 10));
    dateofstartController = TextEditingController(
        text: widget.user?.dateOfStart?.toLocal().toString().substring(0, 10));
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

    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    try {
      if (widget.user != null) {
        setState(() async {
          tasksByDate = TaskApi().fetchTasksByDate(widget.user!.id!);
        });
      }
    } catch (e) {
      String exception = e.toString().substring(10);
      // ignore: unused_element
      showSnackBar(BuildContext context) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(exception),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const Header(),
        drawer: const SideMenu(),
        body: SingleChildScrollView(
            child: Column(children: [
          SizedBox(
            height: defaultPadding,
          ),
          Responsive.isDesktop(context)
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: (Responsive.screenWidth(context) / 3 -
                                Responsive.screenWidth(context) * 0.05),
                            padding: const EdgeInsets.all(defaultPadding),
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: SizedBox(
                              width: Responsive.screenWidth(context) / 3,
                              height: Responsive.screenWidth(context) / 4,
                            ),
                          ),
                          SizedBox(height: defaultPadding),
                          Container(
                              width: (Responsive.screenWidth(context) / 3 -
                                  Responsive.screenWidth(context) * 0.05),
                              padding: const EdgeInsets.all(defaultPadding),
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Column(children: [
                                Text('График'),
                                FutureBuilder<Map<String, dynamic>?>(
                                    future: tasksByDate,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                      } else if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      } else {
                                        return CalendarWidget(snapshot.data);
                                      }
                                    }),
                              ]))
                        ],
                      ),
                      Column(children: [
                        Container(
                            width: Responsive.screenWidth(context) / 3 * 2 -
                                Responsive.screenWidth(context) * 0.05,
                            padding: const EdgeInsets.all(defaultPadding),
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Form(
                                key: _formKey,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      createTextController(nameController,
                                          'Имя', 'Введите имя', true),
                                      SizedBox(height: defaultPadding),
                                      createTextController(surnameController,
                                          'Фамилия', 'Введите фамилию', true),
                                      SizedBox(height: defaultPadding),
                                      createTextController(lastnameController,
                                          'Отчество', 'Введите отчество', true),
                                      const SizedBox(height: defaultPadding),
                                      TextFormField(
                                        inputFormatters: [
                                          PhoneInputFormatter()
                                        ],
                                        keyboardType: TextInputType.phone,
                                        controller: phoneController,
                                        decoration: const InputDecoration(
                                            labelText: 'Телефон',
                                            icon: Icon(Icons.phone)),
                                      ),
                                      const SizedBox(height: defaultPadding),
                                      createTextController(emailController,
                                          'Почта', 'Введите Почту', true),
                                      const SizedBox(height: defaultPadding),
                                      createTextController(addressController,
                                          'Адрес', 'Введите Почту', false),
                                      const SizedBox(height: defaultPadding),
                                      createDateController(
                                          birthController, 'Дата рождения'),
                                      const SizedBox(height: defaultPadding),
                                      createDateController(
                                          dateofstartController,
                                          'Принят на работу'),
                                      const SizedBox(height: defaultPadding),
                                      createTextController(innController, 'ИНН',
                                          'Введите Почту', false),
                                      const SizedBox(height: defaultPadding),
                                      createTextController(snilsController,
                                          'СНИЛС', 'Введите Почту', false),
                                      const SizedBox(height: defaultPadding),
                                      createTextController(passportController,
                                          'Паспорт', 'Введите Почту', false),
                                      const SizedBox(height: defaultPadding),
                                      createTextController(postController,
                                          'Должность', 'Введите Почту', false),
                                      const SizedBox(height: defaultPadding),
                                      createTextController(
                                          infoaboutrelocateController,
                                          'Информация о переводе',
                                          'Введите Почту',
                                          false),
                                      const SizedBox(height: defaultPadding),
                                      createTextController(
                                          attestationController,
                                          'Аттестация',
                                          'Введите Почту',
                                          false),
                                      const SizedBox(height: defaultPadding),
                                      createTextController(
                                          qualificationController,
                                          'Квалификация',
                                          'Введите Почту',
                                          false),
                                      const SizedBox(height: defaultPadding),
                                      createTextController(
                                          retrainingController,
                                          'Проф. переподготовка',
                                          'Введите Почту',
                                          false),
                                      const SizedBox(height: defaultPadding),
                                      CheckboxListTile(
                                        title: Text('Статус'),
                                        // Label for the checkbox
                                        value: status,
                                        // Current value of the checkbox
                                        onChanged: (bool? newValue) {
                                          setState(() {
                                            status = newValue ??
                                                false; // Update the status when the checkbox value changes
                                          });
                                        },
                                      ),
                                      const SizedBox(height: defaultPadding),
                                      createTextController(passwordController,
                                          'Пароль', 'Введите Почту', false),
                                      const SizedBox(height: defaultPadding),
                                      const SizedBox(height: defaultPadding),
                                      ElevatedButton(
                                        onPressed: () {
                                          if (_formKey.currentState
                                                  ?.validate() ??
                                              false) {
                                            saveUser();
                                          }
                                        },
                                        child: const Text('Сохранить'),
                                      ),
                                    ]))),
                        SizedBox(height: defaultPadding),
                        Container(
                          width: Responsive.screenWidth(context) / 3 * 2 -
                              Responsive.screenWidth(context) * 0.05,
                          child: Row(
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
                                      builder: (context) =>
                                          const DocumentForm(),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.add),
                                label: const Text("Создать"),
                              ),
                            ],
                          ),
                        ),
                        Container(
                            width: Responsive.screenWidth(context) / 3 * 2 -
                                Responsive.screenWidth(context) * 0.05,
                            child: MyTable(
                              user: widget.user,
                            ))
                      ])
                    ])
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: (Responsive.screenWidth(context)),
                            padding: const EdgeInsets.all(defaultPadding),
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: SizedBox(
                              width: Responsive.screenWidth(context) / 3,
                              height: Responsive.screenWidth(context) / 4,
                            ),
                          ),
                          SizedBox(height: defaultPadding),
                          Container(
                              width: (Responsive.screenWidth(context)),
                              padding: const EdgeInsets.all(defaultPadding),
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Column(children: [
                                Text('График'),
                                FutureBuilder<Map<String, dynamic>?>(
                                    future: tasksByDate,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                                child:
                                                    CircularProgressIndicator());
                                      } else if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      } else if (!snapshot.hasData ||
                                          snapshot.data!.isEmpty) {
                                        return const Text('Пользователей.');
                                      } else {
                                        return CalendarWidget(snapshot.data);
                                      }
                                    }),
                              ]))
                        ],
                      ),
                      SizedBox(height: defaultPadding),
                      Column(children: [
                        Container(
                            width: Responsive.screenWidth(context),
                            padding: const EdgeInsets.all(defaultPadding),
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Form(
                                key: _formKey,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      createTextController(nameController,
                                          'Имя', 'Введите имя', true),
                                      SizedBox(height: defaultPadding),
                                      createTextController(surnameController,
                                          'Фамилия', 'Введите фамилию', true),
                                      SizedBox(height: defaultPadding),
                                      createTextController(lastnameController,
                                          'Отчество', 'Введите отчество', true),
                                      const SizedBox(height: defaultPadding),
                                      TextFormField(
                                        inputFormatters: [
                                          PhoneInputFormatter()
                                        ],
                                        keyboardType: TextInputType.phone,
                                        controller: phoneController,
                                        decoration: const InputDecoration(
                                            labelText: 'Телефон',
                                            icon: Icon(Icons.phone)),
                                      ),
                                      const SizedBox(height: defaultPadding),
                                      createTextController(emailController,
                                          'Почта', 'Введите Почту', true),
                                      const SizedBox(height: defaultPadding),
                                      createTextController(addressController,
                                          'Адрес', 'Введите Почту', false),
                                      const SizedBox(height: defaultPadding),
                                      createDateController(
                                          birthController, 'Дата рождения'),
                                      const SizedBox(height: defaultPadding),
                                      createDateController(
                                          dateofstartController,
                                          'Принят на работу'),
                                      const SizedBox(height: defaultPadding),
                                      createTextController(innController, 'ИНН',
                                          'Введите Почту', false),
                                      const SizedBox(height: defaultPadding),
                                      createTextController(snilsController,
                                          'СНИЛС', 'Введите Почту', false),
                                      const SizedBox(height: defaultPadding),
                                      createTextController(passportController,
                                          'Паспорт', 'Введите Почту', false),
                                      const SizedBox(height: defaultPadding),
                                      createTextController(postController,
                                          'Должность', 'Введите Почту', false),
                                      const SizedBox(height: defaultPadding),
                                      createTextController(
                                          infoaboutrelocateController,
                                          'Информация о переводе',
                                          'Введите Почту',
                                          false),
                                      const SizedBox(height: defaultPadding),
                                      createTextController(
                                          attestationController,
                                          'Аттестация',
                                          'Введите Почту',
                                          false),
                                      const SizedBox(height: defaultPadding),
                                      createTextController(
                                          qualificationController,
                                          'Квалификация',
                                          'Введите Почту',
                                          false),
                                      const SizedBox(height: defaultPadding),
                                      createTextController(
                                          retrainingController,
                                          'Проф. переподготовка',
                                          'Введите Почту',
                                          false),
                                      const SizedBox(height: defaultPadding),
                                      CheckboxListTile(
                                        title: Text('Статус'),
                                        // Label for the checkbox
                                        value: status,
                                        // Current value of the checkbox
                                        onChanged: (bool? newValue) {
                                          setState(() {
                                            status = newValue ??
                                                false; // Update the status when the checkbox value changes
                                          });
                                        },
                                      ),
                                      const SizedBox(height: defaultPadding),
                                      createTextController(passwordController,
                                          'Пароль', 'Введите Почту', false),
                                      const SizedBox(height: defaultPadding),
                                      const SizedBox(height: defaultPadding),
                                      ElevatedButton(
                                        onPressed: () {
                                          if (_formKey.currentState
                                                  ?.validate() ??
                                              false) {
                                            saveUser();
                                          }
                                        },
                                        child: const Text('Сохранить'),
                                      ),
                                    ]))),
                        SizedBox(height: defaultPadding),
                        Container(
                          width: Responsive.screenWidth(context),
                          child: Row(
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
                                      builder: (context) =>
                                          const DocumentForm(),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.add),
                                label: const Text("Создать"),
                              ),
                            ],
                          ),
                        ),
                        Container(
                            width: Responsive.screenWidth(context),
                            child: MyTable(
                              user: widget.user,
                            ))
                      ])
                    ]),
          SizedBox(
            height: defaultPadding,
          )
        ])));
  }

  Row createTextController(TextEditingController itemController,
      String itemText, String validatorText, bool required) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(
        itemText,
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w100,
        ),
      ),
      SizedBox(
        width: defaultPadding,
      ),
      Container(
        width: Responsive.screenWidth(context) * 0.4,
        child: TextFormField(
          controller: itemController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (required) {
              if (value == null || value.isEmpty) {
                return validatorText;
              }
              return null;
            } else {
              return null;
            }
          },
        ),
      )
    ]);
  }

  Row createDateController(
      TextEditingController itemController, String itemText) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(
        itemText,
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w100,
        ),
      ),
      SizedBox(width: defaultPadding),
      Container(
          width: Responsive.screenWidth(context) * 0.4,
          child: TextFormField(
            controller: itemController,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), icon: Icon(Icons.date_range)),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return null;
              }
              if (!RegExp(r'\d{4}-\d{2}-\d{2}').hasMatch(value)) {
                return 'Неверный формат даты';
              }
              return null;
            },
            onTap: () async {
              DateTime? date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (date != null) {
                itemController.text =
                    date.toLocal().toString().substring(0, 10);
              }
            },
          ))
    ]);
  }

  void saveUser() async {
    try {
      DateTime? birth;
      DateTime? start;

      if (birthController.text != null && !birthController.text.isEmpty) {
        birth = DateTime.parse(birthController.text!);
      }
      if (dateofstartController.text != null &&
          !dateofstartController.text.isEmpty) {
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

class CalendarWidget extends StatelessWidget {
  final daysOfWeek = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вск'];
  final DateTime now = DateTime.now();
  late final String month;
  final Map<String, dynamic>? tasksByDate;

  CalendarWidget(this.tasksByDate) : month = _getMonth(DateTime.now().month);

  static String _getMonth(int monthNumber) {
    final Map<int, String> monthDictionary = {
      1: 'Январь',
      2: 'Февраль',
      3: 'Март',
      4: 'Апрель',
      5: 'Май',
      6: 'Июнь',
      7: 'Июль',
      8: 'Август',
      9: 'Сентябрь',
      10: 'Октябрь',
      11: 'Ноябрь',
      12: 'Декабрь',
    };
    return monthDictionary[monthNumber] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(height: 16), // Adjust spacing as needed
      Text(
        month,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 16), // Adjust spacing as needed
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          7,
          (index) => Text(
            daysOfWeek[index],
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      SizedBox(height: 16),
      SizedBox(
        width: Responsive.isDesktop(context)
            ? Responsive.screenWidth(context) / 3
            : Responsive.screenWidth(context),
        height: Responsive.isDesktop(context)
            ? Responsive.screenWidth(context) / 4
            : Responsive.screenWidth(context),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
          ),
          itemCount: 31, // Assuming 31 days in the month
          itemBuilder: (context, index) {
            final day = index + 1;
            final date =
                DateTime(DateTime.now().year, DateTime.now().month, day);

            final eventsForDay = tasksByDate?[
                    '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}'] ??
                [];

            Color tileColor = eventsForDay != null ? lightBlue : lightPurple;

            return GestureDetector(
              onTap: () {
                if (eventsForDay != null) {
                  // Handle tap event
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                            'Задачи на ${date.day}/${date.month}/${date.year}'),
                        content:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          SizedBox(
                            width: double.maxFinite,
                            // Adjust width as needed
                            height: 200,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: eventsForDay.length,
                              itemBuilder: (context, index) {
                                final eventId =
                                    eventsForDay[index]['id'].toString();
                                final eventName = eventsForDay[index]['name'];
                                return ListTile(
                                  title: Text('$eventId $eventName'),
                                  // Add more ListTile properties as needed
                                );
                              },
                            ),
                          ),
                        ]),
                      );
                    },
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                            'Задачи на ${date.day}/${date.month}/${date.year}'),
                        content:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          SizedBox(
                              width: double.maxFinite,
                              // Adjust width as needed
                              height: 200,
                              child: ListTile(
                                title: Text('Нет задач на эту дату'),
                                // Add more ListTile properties as needed
                              )),
                        ]),
                      );
                    },
                  );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  color: tileColor,
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 4),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        day.toString(),
                        style: TextStyle(
                            fontSize: 12), // Adjust font size as needed
                      ),
                      // Additional widgets can be added here
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      )
    ]);
  }
}
