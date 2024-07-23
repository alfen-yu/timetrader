import 'package:flutter/material.dart';
import 'package:timetrader/services/auth/auth_service.dart';
import 'package:timetrader/services/cloud/firebase_cloud_storage.dart';
import 'package:timetrader/services/cloud/tasks/cloud_task.dart';
import 'package:timetrader/views/dashboard/side_menu_page/side_menu.dart';
import 'package:timetrader/views/dashboard/tasks_display_page/task_details_view.dart';
import 'package:timetrader/views/dashboard/tasks_display_page/task_list_view.dart';

class TaskHistoryPage extends StatefulWidget {
  const TaskHistoryPage({super.key});

  @override
  State<TaskHistoryPage> createState() => _TaskHistoryPageState();
}

class _TaskHistoryPageState extends State<TaskHistoryPage> {
  bool _isTaskerSelected = true;
  late final FirebaseCloudStorage _tasksService;
  late final String _uid;

  @override
  void initState() {
    super.initState();
    _tasksService = FirebaseCloudStorage();
    _uid = AuthService.firebase().currentUser!.id;
  }

  void _toggleView(bool isTasker) {
    setState(() {
      _isTaskerSelected = isTasker;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideMenu(),
      appBar: AppBar(
        title: const Text(
          'Task History',
          style: TextStyle(fontSize: 18),
        ),
        centerTitle: true,
        shadowColor: Colors.amber,
        backgroundColor: Colors.lightBlueAccent,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0), // Padding around the container
            child: Container(
              width: double.infinity,
              height: 80, // Reduced height
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(0), // No border radius
                border: Border.all(
                  color: Colors.grey,
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _toggleView(true),
                      child: Container(
                        color: _isTaskerSelected
                            ? Colors.lightBlueAccent
                            : Colors.transparent,
                        child: Center(
                          child: Text(
                            'As Tasker',
                            style: TextStyle(
                              color: _isTaskerSelected
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 16, // Reduced font size
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 1,
                    height: double.infinity,
                    color: Colors.grey,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _toggleView(false),
                      child: Container(
                        color: !_isTaskerSelected
                            ? Colors.lightBlueAccent
                            : Colors.transparent,
                        child: Center(
                          child: Text(
                            'As Poster',
                            style: TextStyle(
                              color: !_isTaskerSelected
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 16, // Reduced font size
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<CloudTask>>(
              stream: _isTaskerSelected
                  ? _tasksService.tasksByTasker(_uid)
                  : _tasksService.tasksByPoster(_uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No tasks available.'));
                } else {
                  final tasks = snapshot.data!;
                  return TasksListView(
                    tasks: tasks,
                    onTapTask: (task) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => TaskDetailsView(task: task),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
