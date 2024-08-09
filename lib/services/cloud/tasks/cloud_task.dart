import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:timetrader/enums/task_status.dart';
import 'package:timetrader/services/cloud/cloud_storage_constants.dart';

@immutable
class CloudTask {
  final String taskId;
  final String ownerUserId;
  final String title;
  final String description;
  final String hours;
  final String location;
  final int budget;
  final String jobType;
  final String category;
  final TaskStatus status;
  final Timestamp createdAt;
  final DateTime dueDate;

  const CloudTask({
    required this.taskId,
    required this.ownerUserId,
    required this.title,
    required this.description,
    required this.hours,
    required this.location,
    required this.budget,
    required this.jobType,
    required this.category,
    required this.status,
    required this.createdAt,
    required this.dueDate,
  });

  factory CloudTask.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;

    // Use default values if fields are missing
    return CloudTask(
      taskId: snapshot.id,
      ownerUserId: data[ownerUserIdFieldName] ?? '',
      title: data[titleFieldName] ?? '',
      description: data[descriptionFieldName] ?? '',
      hours: data[hoursFieldName] ?? '',
      location: data[locationFieldName] ?? '',
      budget: (data[budgetFieldName] as int?) ?? 0,
      jobType: data[jobTypeFieldName] ?? '',
      category: data[categoryFieldName] ?? '',
      status: TaskStatus.values.firstWhere(
        (e) => e.toString().split('.').last == data[statusFieldName],
        orElse: () => TaskStatus.open,
      ),
      createdAt: data[createdAtFieldName] as Timestamp? ?? Timestamp.now(),
      dueDate:
          (data[dueDateFieldName] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  CloudTask copyWith({
    String? taskId,
    String? ownerUserId,
    String? title,
    String? description,
    String? hours,
    String? location,
    int? budget,
    String? jobType,
    String? category,
    TaskStatus? status,
    Timestamp? createdAt,
    DateTime? dueDate,
  }) {
    return CloudTask(
      taskId: taskId ?? this.taskId,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      title: title ?? this.title,
      description: description ?? this.description,
      hours: hours ?? this.hours,
      location: location ?? this.location,
      budget: budget ?? this.budget,
      jobType: jobType ?? this.jobType,
      category: category ?? this.category,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
    );
  }
}
