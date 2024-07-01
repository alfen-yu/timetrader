import 'package:flutter/material.dart';
import 'package:timetrader/constants/routes.dart';
import 'package:timetrader/services/auth/auth_service.dart';
import 'package:timetrader/services/cloud/firebase_cloud_storage.dart';
import 'package:timetrader/services/cloud/tasks/cloud_task.dart';
import 'package:timetrader/views/dashboard/hamburger_menu.dart';
import 'package:timetrader/views/dashboard/tasks_views/task_list_view.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  late final FirebaseCloudStorage _tasksService;
  String get uid => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _tasksService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Earn Money',
          style: TextStyle(fontSize: 18),
        ),
        centerTitle: true,
        shadowColor: Colors.amber,
        backgroundColor: Colors.lightBlueAccent,
        foregroundColor: Colors.white,
        actions: const [
          HamburgerMenu(),
        ],
      ),
      body: Container(
        color: Colors.grey[200],
        child: StreamBuilder<Iterable<CloudTask>>(
          stream: _tasksService.allTasks(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No tasks available.'));
            } else {
              final allTasks = snapshot.data!;
              return TasksListView(
                tasks: allTasks,
                onDeleteTask: (task) async {
                  await _tasksService.deleteTask(documentId: task.taskId);
                },
                onTapTask: (task) {
                  Navigator.of(context).pushNamed(crudTaskViewRoute, arguments: task);
                },
              );
            }
          },
        ),
      ),
    );
  }
}
