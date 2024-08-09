import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timetrader/services/auth/auth_service.dart';
import 'package:timetrader/services/cloud/firebase_cloud_storage.dart';
import 'package:timetrader/services/cloud/tasks/cloud_task.dart';
import 'package:timetrader/enums/task_status.dart'; // Import TaskStatus enum

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
  String _jobType = 'Physical';
  late String _category;
  late DateTime _dueDate;
  bool _isLoading = false;
  bool _isLocationEnabled = true;

  @override
  void initState() {
    _tasksService = FirebaseCloudStorage();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _hoursController = TextEditingController();
    _locationController = TextEditingController();
    _budgetController = TextEditingController();
    _dueDate = DateTime.now(); 
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

  Future<void> _pickDueDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)), 
    );
    if (pickedDate != null) {
      setState(() {
        _dueDate = pickedDate;
      });
    }
  }

  void _deleteEmptyTask() async {
    final task = _task;
    if (task != null &&
        _titleController.text.isEmpty &&
        _descriptionController.text.isEmpty &&
        _hoursController.text.isEmpty &&
        _locationController.text.isEmpty &&
        _budgetController.text.isEmpty) {
      await _tasksService.deleteTask(task.taskId);
    }
  }

  void _saveTask() async {
    final task = _task;
    final title = _titleController.text;
    final description = _descriptionController.text;
    final hours = _hoursController.text;
    final jobType = _jobType;
    final category = _category;
    final location = _jobType == 'Online' ? '' : _locationController.text;
    final budget = int.tryParse(_budgetController.text) ?? 0;
    const status = TaskStatus.open; 

    if (task != null && title.isNotEmpty && description.isNotEmpty) {
      // Update existing task
      await _tasksService.updateTask(
        documentId: task.taskId,
        title: title,
        description: description,
        hours: hours,
        jobType: jobType,
        category: category,
        status: status,
        location: location,
        budget: budget,
        dueDate: _dueDate,
      );
    } else {
      // Create new task
      final currentUser = AuthService.firebase().currentUser!;
      final uid = currentUser.id;
      final createdAt = Timestamp.now();

      final newTask = await _tasksService.createNewTask(
        ownerUserId: uid,
        title: title,
        description: description,
        hours: hours,
        jobType: jobType,
        category: category,
        status: status,
        location: location,
        budget: budget,
        createdAt: createdAt,
        dueDate: _dueDate, 
      );
      _task = newTask;
    }

    _deleteEmptyTask();
  }

   @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map?;
    if (arguments != null && arguments.containsKey('category')) {
      _category = arguments['category'];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_task != null ? 'Edit Task' : 'Create a Task'),
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
                      DropdownMenuItem(
                          value: 'Physical', child: Text('Physical')),
                      DropdownMenuItem(value: 'Online', child: Text('Online')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _jobType = value!;
                        _isLocationEnabled = _jobType == 'Physical';
                        if (!_isLocationEnabled) {
                          _locationController.text = '';
                        }
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
              enabled: _isLocationEnabled,
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
            GestureDetector(
              onTap: _pickDueDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Due Date',
                  hintText: 'Select Due Date',
                  border: OutlineInputBorder(),
                ),
                child: Text(
                  '${_dueDate.day}/${_dueDate.month}/${_dueDate.year}',
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Category: $_category',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  _isLoading = true;
                });
                _saveTask(); 
                setState(() {
                  _isLoading = false;
                });
                if (!context.mounted) return;
                Navigator.of(context).pop();
              },
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Save Task'),
            ),
          ],
        ),
      ),
    );
  }
}
