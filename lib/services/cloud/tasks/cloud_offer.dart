import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

@immutable
class CloudOffer {
  final String offerId;
  final String taskId;
  final String offererId;
  final int offerAmount;
  final Timestamp timestamp;

  const CloudOffer({
    required this.offerId,
    required this.taskId,
    required this.offererId,
    required this.offerAmount,
    required this.timestamp,
  });

  CloudOffer.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : offerId = snapshot.id,
        taskId = snapshot.data()['taskId'],
        offererId = snapshot.data()['offererId'],
        offerAmount = snapshot.data()['offerAmount'],
        timestamp = snapshot.data()['timestamp'];
}
