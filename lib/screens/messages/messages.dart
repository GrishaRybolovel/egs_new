import 'package:flutter/material.dart';
import 'package:egs/api/service.dart';
import 'package:egs/model/user.dart';

import '../../ui/const.dart';
import 'components/message_list.dart';

class MessagesScreen extends StatefulWidget {
  final int projectId;

  const MessagesScreen({Key? key, required this.projectId}) : super(key: key);

  @override
  MessagesScreenState createState() => MessagesScreenState();
}

class MessagesScreenState extends State<MessagesScreen> {
  late Future<User>? userFuture;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    setState(() {
      try {
        userFuture = ApiService().fetchUserData();
      } catch (error) {
        print('Error fetching messages: $error');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
        future: userFuture,
        builder: (context, snapshot) {
          if (userFuture == null) {
            return const Expanded(
                child: Center(child: CircularProgressIndicator()));
          } else if (snapshot.hasError) {
            // Error while fetching data, show an error message
            return Text('Error: ${snapshot.error}');
          } else {
            int currentUser = snapshot.data?.id ?? 0;
            return Container(
              height: 500,
              padding: const EdgeInsets.all(defaultPadding),
              child: MessageList(
                userId: currentUser,
                taskId: widget.projectId,
              ),
            );
          }
        });
  }
}
