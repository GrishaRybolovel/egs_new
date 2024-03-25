import 'package:flutter/material.dart';

class ScrumCardItem extends StatelessWidget {
  final String title;
  final String assignedTo;
  final String content;


  const ScrumCardItem(
      {super.key,
      required this.title,
      required this.assignedTo,
      required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
            ),
            Text(
              "Assigned to: $assignedTo",
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              content,
              maxLines: 5,
            ),
          ],
        ),
      ),
    );
  }
  
}