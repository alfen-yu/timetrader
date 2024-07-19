import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
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
  final bool status;
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

  factory CloudTask.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return CloudTask(
      taskId: snapshot.id,
      ownerUserId: data[ownerUserIdFieldName],
      title: data[titleFieldName],
      description: data[descriptionFieldName],
      hours: data[hoursFieldName],
      location: data[locationFieldName] ?? '',
      budget: data[budgetFieldName] ?? 0,
      jobType: data[jobTypeFieldName],
      category: data[categoryFieldName],
      status: data[statusFieldName] ?? false,
      createdAt: data[createdAtFieldName],
      dueDate: (data[dueDateFieldName] as Timestamp).toDate(),
    );
  }
}