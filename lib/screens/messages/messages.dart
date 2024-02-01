import 'package:flutter/material.dart';

import '../../const.dart';
import 'components/message_list.dart';
import 'components/message_form.dart';

class MessagesScreen extends StatefulWidget {
  final int projectId;

  const MessagesScreen({Key? key, required this.projectId}) : super(key: key);

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
        padding: EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child:
            MessageList(
              userId: 2,
              taskId: widget.projectId,
            ),
    );
  }
}
