import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

@immutable
class CloudComment {
  final String commentId;
  final String taskId;
  final String commenterId;
  final String commentText;
  final Timestamp timestamp;

  const CloudComment({
    required this.commentId,
    required this.taskId,
    required this.commenterId,
    required this.commentText,
    required this.timestamp,
  });

  CloudComment.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : commentId = snapshot.id,
        taskId = snapshot.data()['taskId'],
        commenterId = snapshot.data()['commenterId'],
        commentText = snapshot.data()['commentText'],
        timestamp = snapshot.data()['timestamp'];
}
