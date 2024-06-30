import 'package:timetrader/services/auth/auth_service.dart';
import 'package:timetrader/utilities/generics/get_arguments.dart';
import 'package:flutter/material.dart';
import 'package:timetrader/services/cloud/firebase_cloud_storage.dart';
import 'package:timetrader/services/cloud/tasks/cloud_task.dart';

class CRUDTaskView extends StatefulWidget {
  const CRUDTaskView({super.key});

  @override
  State<CRUDTaskView> createState() => _CRUDTaskViewState();
}

class _CRUDTaskViewState extends State<CRUDTaskView> {
  CloudTask? _task;
  late final FirebaseCloudStorage _tasksService;
  late final TextEditingController _titleController;
  late final TextEditingController _locationController;
  late final TextEditingController _priceController;

  @override
  void initState() {
    _tasksService = FirebaseCloudStorage();
    _titleController = TextEditingController();
    _locationController = TextEditingController();
    _priceController = TextEditingController();
    super.initState();
  }

  void _deleteEmptyTask() {
    final task = _task;
    if (_titleController.text.isEmpty && task != null) {
      _tasksService.deleteTask(documentId: task.taskId);
    }
  }

  void _saveTask() async {
    final task = _task;
    final title = _titleController.text;
    final location = _locationController.text;
    final price = int.tryParse(_priceController.text) ?? 0;

    if (task != null && title.isNotEmpty && location.isNotEmpty) {
      await _tasksService.updateTask(
        documentId: task.taskId,
        title: title,
        location: location,
        status: true,
        price: price,
      );
    }
  }

  void _titleControllerListener() async {
    final task = _task;

    if (task == null) {
      return;
    } else {
      final title = _titleController.text;
      await _tasksService.updateTask(
        documentId: task.taskId,
        title: title,
        location: task.location,
        status: task.status,
        price: task.price,
      );
    }
  }

  void _setupListener() {
    _titleController.removeListener(_titleControllerListener);
    _titleController.addListener(_titleControllerListener);
  }

  Future<CloudTask> createReadUpdateTask(BuildContext context) async {
    final widgetTask = context.getArgument<CloudTask>();
    if (widgetTask != null) {
      _task = widgetTask;
      _titleController.text = widgetTask.title;
      _locationController.text = widgetTask.location;
      _priceController.text = widgetTask.price.toString();
      return widgetTask;
    }

    final existingTask = _task;
    if (existingTask != null) {
      return existingTask;
    }

    final currentUser = AuthService.firebase().currentUser!;
    final uid = currentUser.id;
    final newTask = await _tasksService.createNewTask(
      ownerUserId: uid,
      title: '',
      location: '',
      status: true,
      price: 0,
    );
    _task = newTask;
    return newTask;
  }

  @override
  void dispose() {
    _deleteEmptyTask();
    _saveTask();
    _titleController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a Task'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: FutureBuilder(
        future: createReadUpdateTask(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _setupListener();
              return Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      hintText: 'Task Title',
                    ),
                  ),
                  TextField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                      hintText: 'Task Location',
                    ),
                  ),
                  TextField(
                    controller: _priceController,
                    decoration: const InputDecoration(
                      hintText: 'Task Price',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final title = _titleController.text;
                      final location = _locationController.text;
                      final price = int.tryParse(_priceController.text) ?? 0;

                      if (title.isNotEmpty && location.isNotEmpty) {
                        if (_task != null) {
                          await _tasksService.updateTask(
                            documentId: _task!.taskId,
                            title: title,
                            location: location,
                            status: true,
                            price: price,
                          );
                        } else {
                          final currentUser = AuthService.firebase().currentUser!;
                          final uid = currentUser.id;
                          await _tasksService.createNewTask(
                            ownerUserId: uid,
                            title: title,
                            location: location,
                            status: true,
                            price: price,
                          );
                        }
                        if (!context.mounted) return; 
                        Navigator.of(context).pop();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('All fields must be filled out')),
                        );
                      }
                    },
                    child: const Text('Save Task'),
                  ),
                ],
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}