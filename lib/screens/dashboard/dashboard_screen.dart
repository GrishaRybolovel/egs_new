import 'package:egs/responsive.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../const.dart';
import 'components/tasks.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: Column(
            children: [
              MyTasks(),
            ],
          ),
        ),
      ],
    );
  }
}
