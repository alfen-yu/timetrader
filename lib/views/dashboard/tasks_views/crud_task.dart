import 'package:flutter/material.dart';
import 'package:timetrader/services/auth/auth_service.dart';
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
  late final TextEditingController _descriptionController;
  late final TextEditingController _hoursController;
  late final TextEditingController _locationController;
  late final TextEditingController _budgetController;
  String _jobType = 'Online';
  String? _category;
  bool _isLoading = false;

  @override
  void initState() {
    _tasksService = FirebaseCloudStorage();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _hoursController = TextEditingController();
    _locationController = TextEditingController();
    _budgetController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _hoursController.dispose();
    _locationController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  void _deleteEmptyTask() async {
    final task = _task;
    if (task != null &&
        _titleController.text.isEmpty &&
        _descriptionController.text.isEmpty &&
        _hoursController.text.isEmpty &&
        _locationController.text.isEmpty &&
        _budgetController.text.isEmpty) {
      await _tasksService.deleteTask(documentId: task.taskId);
    }
  }

  void _saveTask() async {
    final task = _task;
    final title = _titleController.text;
    final description = _descriptionController.text;
    final hours = _hoursController.text;
    final jobType = _jobType;
    final category = _category;
    final location = _locationController.text;
    final budget = int.tryParse(_budgetController.text) ?? 0;

    if (task != null && title.isNotEmpty && description.isNotEmpty) {
      await _tasksService.updateTask(
        documentId: task.taskId,
        title: title,
        description: description,
        hours: hours,
        jobType: jobType,
        category: category,
        status: true,
        location: location,
        budget: budget,
      );
    } else {
      final currentUser = AuthService.firebase().currentUser!;
      final uid = currentUser.id;
      final newTask = await _tasksService.createNewTask(
        ownerUserId: uid,
        title: title,
        description: description,
        hours: hours,
        jobType: jobType,
        category: category,
        status: true,
        location: location,
        budget: budget,
      );
      _task = newTask;
    }

    _deleteEmptyTask();
  }

  // Future<CloudTask> createReadUpdateTask(BuildContext context) async {
  //   final widgetTask = context.getArgument<CloudTask>();
  //   if (widgetTask != null) {
  //     _task = widgetTask;
  //     _titleController.text = widgetTask.title;
  //     _descriptionController.text = widgetTask.description;
  //     _hoursController.text = widgetTask.hours;
  //     _skillsController.text = widgetTask.skills;
  //     _locationController.text = widgetTask.location;
  //     _budgetController.text = widgetTask.budget.toString();
  //     _jobType = widgetTask.jobType;
  //     _category = widgetTask.category;
  //     return widgetTask;
  //   }
  //   final existingTask = _task;
  //   if (existingTask != null) {
  //     return existingTask;
  //   }

  //   final currentUser = AuthService.firebase().currentUser!;
  //   final uid = currentUser.id;
  //   final newTask = await _tasksService.createNewTask(
  //     ownerUserId: uid,
  //     title: '',
  //     description: '',
  //     hours: '',
  //     skills: '',
  //     location: '',
  //     budget: 0,
  //     jobType: 'Online',
  //     category: _category,
  //     status: true,
  //   );
  //   _task = newTask;
  //   return newTask;
  // }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map?;
    _category ??= args?['category'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a Task'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Job Title',
                labelText: 'Job Title',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Job Description',
                labelText: 'Job Description',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _hoursController,
                    decoration: const InputDecoration(
                      hintText: 'Hours of Work',
                      labelText: 'Hours of Work',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: DropdownButton<String>(
                    value: _jobType,
                    items: const [
                      DropdownMenuItem(value: 'Online', child: Text('Online')),
                      DropdownMenuItem(
                          value: 'Physical', child: Text('Physical')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _jobType = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                hintText: 'Location',
                labelText: 'Location',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _budgetController,
              decoration: const InputDecoration(
                hintText: 'Budget',
                labelText: 'Budget',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  _isLoading = true;
                });
                _saveTask(); // Save task logic moved here
                setState(() {
                  _isLoading = false;
                });
                if (!context.mounted) return;
                Navigator.of(context).pop();
              },
              child: const Text('Save Task'),
            ),
            if (_isLoading) const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
