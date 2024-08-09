import 'package:cloud_firestore/cloud_firestore.dart';

class CloudTasker {
  final String userId; // Link to the CloudUser
  final int capacityOfWork; // Number of hours a tasker can work in a day
  final List<String> skills; // List of skills the tasker has
  final double rating; // Average rating out of 5 stars
  final int ratingCount; // Number of ratings received

  const CloudTasker({
    required this.userId,
    required this.capacityOfWork,
    required this.skills,
    required this.rating,
    required this.ratingCount,
  });

  factory CloudTasker.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    var data = snapshot.data()!;
    return CloudTasker(
      userId: data['uid'] ?? '',
      capacityOfWork: data['capacityOfWork'] ?? 0,
      skills: List<String>.from(data['skills'] ?? []),
      rating: (data['rating'] ?? 0.0).toDouble(),
      ratingCount: data['ratingCount'] ?? 0,
    );
  }

  // Convert CloudTasker to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': userId,
      'capacityOfWork': capacityOfWork,
      'skills': skills,
      'rating': rating,
      'ratingCount': ratingCount,
    };
  }
}
