import 'package:egs/ui/const.dart';
import 'package:intl/intl.dart';
import 'package:egs/model/task.dart';
import 'package:flutter/material.dart';

class FileInfoCard extends StatelessWidget {
  const FileInfoCard({
    super.key,
    required this.info,
  });

  final Task info;

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.fromBorderSide(
          BorderSide(
              color: (info.completion!.difference(DateTime.now()) <
                              const Duration(days: 7) &&
                          DateTime.now().isBefore(info.completion!)) ||
                      DateTime.now().isAfter(info.completion!)
                  ? Colors.red
                  : ((info.completion!.difference(DateTime.now()) <
                              const Duration(days: 14) &&
                          DateTime.now().isBefore(info.completion!))
                      ? Colors.orange
                      : Theme.of(context).colorScheme.primary),
              width: 2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  height: 30,
                  alignment: Alignment.center,
                  color: (info.completion!.difference(DateTime.now()) <
                                  const Duration(days: 7) &&
                              DateTime.now().isBefore(info.completion!)) ||
                          DateTime.now().isAfter(info.completion!)
                      ? Colors.red
                      : ((info.completion!.difference(DateTime.now()) <
                                  const Duration(days: 14) &&
                              DateTime.now().isBefore(info.completion!))
                          ? Colors.orange
                          : Theme.of(context).colorScheme.primary),
                  child: Text(
                    info.name,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.black
                            : Colors.white),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  info.description == null ? "" : info.description!.toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Создано ${DateFormat('dd.MM.yyyy').format(info.created ?? DateTime.now())}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Завершить до ${DateFormat('dd.MM.yyyy').format(info.completion ?? DateTime.now())}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        info.done == null
                            ? Container()
                            : Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Выполнено ${DateFormat('dd.MM.yyyy').format(info.done ?? DateTime.now())}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'Автор:',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          info.authorId!.toString(),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
