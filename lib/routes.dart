import 'package:egs/model/task.dart';
import 'package:egs/model/user.dart';
import 'package:egs/screens/dashboard/components/task_form.dart';
import 'package:egs/screens/dashboard/components/tasks.dart';
import 'package:egs/screens/dashboard/dashboard_screen.dart';
import 'package:egs/screens/documents/documents.dart';
import 'package:egs/screens/employees/employees.dart';
import 'package:egs/screens/login/login.dart';
import 'package:egs/screens/mails/mails.dart';
import 'package:egs/screens/messages/messages.dart';
import 'package:egs/screens/projects/projects.dart';
import 'package:egs/screens/registration/register.dart';
import 'package:egs/screens/employees/components/employee_form.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(
          builder: (context) => const LoginScreen(),
          settings: const RouteSettings(name: '/login'),
        );
      case '/register':
        return MaterialPageRoute(
          builder: (context) => const RegistrationScreen(),
          settings: const RouteSettings(name: '/register'),
        );
      case '/dashboard':
        return MaterialPageRoute(
          builder: (context) => const DashboardScreen(),
          settings: const RouteSettings(name: '/dashboard'),
        );
      case '/documents':
        return MaterialPageRoute(
          builder: (context) => const DocumentsScreen(),
          settings: const RouteSettings(name: '/documents'),
        );
      case '/employees':
        return MaterialPageRoute(
          builder: (context) => const EmployeesScreen(),
          settings: const RouteSettings(name: '/employees'),
        );
      case '/mails':
        return MaterialPageRoute(
          builder: (context) => const MailsScreen(),
          settings: const RouteSettings(name: '/mails'),
        );
      case '/messages':
        return MaterialPageRoute(
          builder: (context) =>
              MessagesScreen(projectId: settings.arguments as int),
          settings: const RouteSettings(name: '/messages'),
        );
      case '/projects':
        return MaterialPageRoute(
          builder: (context) => const ProjectsScreen(),
          settings: const RouteSettings(name: '/projects'),
        );
      case '/taskForm':
        return MaterialPageRoute(
          builder: (context) =>
              TaskFormScreen(initialTask: settings.arguments as Task?),
          settings: const RouteSettings(name: '/taskForm'),
        );
      case '/userForm':
        return MaterialPageRoute(builder: (context) =>
            EmployeeForm(user: settings.arguments as User?),
          settings: const RouteSettings(name: '/userForm'),
        );
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (context) {
      return const Scaffold(
        body: Center(
          child: Text('Error: Route not found!'),
        ),
      );
    });
  }
}
