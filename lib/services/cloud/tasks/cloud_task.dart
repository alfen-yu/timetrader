import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:timetrader/services/cloud/cloud_storage_constants.dart';

@immutable
class CloudTask {
  final String taskId;
  final String ownerUserId;
  final String title;
  final String location;
  final bool status; // true for open, false for closed
  final int price;

  const CloudTask({
    required this.taskId,
    required this.ownerUserId,
    required this.title,
    required this.location,
    required this.status,
    required this.price,
  });

  // gives us the current snapshot of the cloud firestore
  CloudTask.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : taskId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        title = snapshot.data()[titleFieldName] as String,
        location = snapshot.data()[locationFieldName],
        status = snapshot.data()[statusFieldName],
        price = snapshot.data()[priceFieldName];
}
