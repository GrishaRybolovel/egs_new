import 'package:flutter/material.dart';

import '../../ui/const.dart';
import 'components/message_list.dart';

class MessagesScreen extends StatefulWidget {
  final int projectId;

  const MessagesScreen({Key? key, required this.projectId}) : super(key: key);

  @override
  MessagesScreenState createState() => MessagesScreenState();
}

class MessagesScreenState extends State<MessagesScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: MessageList(
        userId: 2,
        taskId: widget.projectId,
      ),
    );
  }
}
