import 'package:cloud_firestore/cloud_firestore.dart';

class CloudTasker {
  final String userId; // Link to the CloudUser
  final int capacityOfWork; // Number of hours a tasker can work in a day
  final List<String> skills; // List of skills the tasker has

  CloudTasker({
    required this.userId,
    required this.capacityOfWork,
    required this.skills,
  });

  factory CloudTasker.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    var data = snapshot.data()!;
    return CloudTasker(
      userId: data['uid'] ?? '',
      capacityOfWork: data['capacityOfWork'] ?? 0,
      skills: List<String>.from(data['skills'] ?? []),
    );
  }
}
