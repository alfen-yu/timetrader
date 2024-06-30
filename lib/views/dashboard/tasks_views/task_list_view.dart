import 'package:flutter/material.dart';
import 'package:timetrader/services/cloud/tasks/cloud_task.dart';
import 'package:timetrader/utilities/dialogs/generic_dialog.dart';
// import 'package:timetrader/utilities/dialogs/generic_dialog.dart';

typedef TaskCallback = void Function(CloudTask task);

class TasksListView extends StatelessWidget {
  final Iterable<CloudTask> tasks;
  final TaskCallback onDeleteTask;
  final TaskCallback onTapTask;

  const TasksListView(
      {super.key, required this.tasks, required this.onDeleteTask, required this.onTapTask});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks.elementAt(index);
        return ListTile(
          onTap: () => {onTapTask(task)},
          title: Text(
            task.title,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            onPressed: () async {
              final deleteResult = await showGenericDialog(
                context: context,
                title: 'Delete Task?',
                content: 'Do you want to delete this task?',
                optionsBuilder: () => {'OK': true, 'Cancel': false},
              );
              if (deleteResult == true) {
                onDeleteTask(task);
              }
            },
            icon: const Icon(Icons.delete),
          ),
        );
      },
    );
  }
}
