import 'package:cloud_firestore/cloud_firestore.dart';

class CloudUser {
  final String uid;
  final String email;
  final String fullName;
  final String address;
  final String phoneNumber;
  final String profilePictureUrl;
  final String cnicFrontPictureUrl;
  final String cnicBackPictureUrl;

  CloudUser({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.address,
    required this.phoneNumber,
    required this.profilePictureUrl,
    required this.cnicFrontPictureUrl,
    required this.cnicBackPictureUrl,
  });

  factory CloudUser.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return CloudUser(
      uid: snapshot.id,
      email: data['email'],
      fullName: data['fullName'] ?? '',
      address: data['address'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      profilePictureUrl: data['profilePictureUrl'] ?? '',
      cnicFrontPictureUrl: data['cnicFrontPictureUrl'] ?? '',
      cnicBackPictureUrl: data['cnicBackPictureUrl'] ?? '',
    );
  }
}
