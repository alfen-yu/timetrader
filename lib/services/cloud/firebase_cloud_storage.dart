import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:timetrader/enums/task_status.dart';
import 'package:timetrader/services/auth/auth_service.dart';
import 'package:timetrader/services/cloud/cloud_storage_constants.dart';
import 'package:timetrader/services/cloud/cloud_storage_exception.dart';
import 'package:timetrader/services/cloud/cloud_user.dart';
import 'package:timetrader/services/cloud/tasks/cloud_comment.dart';
import 'package:timetrader/services/cloud/tasks/cloud_offer.dart';
import 'package:timetrader/services/cloud/tasks/cloud_task.dart';
import 'package:timetrader/services/cloud/tasks/cloud_tasker.dart';

class FirebaseCloudStorage {
  final CollectionReference users =
      FirebaseFirestore.instance.collection(usersCollection);

  final CollectionReference taskers =
      FirebaseFirestore.instance.collection(taskersCollection);

  final FirebaseStorage storage = FirebaseStorage.instance;

  final CollectionReference tasks =
      FirebaseFirestore.instance.collection(tasksCollection);

  final CollectionReference offers =
      FirebaseFirestore.instance.collection(offersCollection);

  final CollectionReference comments =
      FirebaseFirestore.instance.collection(commentsCollection);

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;

  // Create a new user with basic details and return the CloudUser instance
  Future<CloudUser> createNewUser({
    required String uid,
    required String email,
    required String fullName,
    required String address,
    required String phoneNumber,
    required File? profilePicture,
    required File? cnicFrontPicture,
    required File? cnicBackPicture,
  }) async {
    try {
      // Upload profile pictures to Firebase Storage and get download URLs
      String profilePictureUrl = '';
      String cnicFrontPictureUrl = '';
      String cnicBackPictureUrl = '';

      if (profilePicture != null) {
        final profileRef = storage.ref().child('profile_pictures/$uid.jpg');
        await profileRef.putFile(profilePicture);
        profilePictureUrl = await profileRef.getDownloadURL();
      }

      if (cnicFrontPicture != null) {
        final cnicFrontRef = storage.ref().child('cnic_front/$uid.jpg');
        await cnicFrontRef.putFile(cnicFrontPicture);
        cnicFrontPictureUrl = await cnicFrontRef.getDownloadURL();
      }

      if (cnicBackPicture != null) {
        final cnicBackRef = storage.ref().child('cnic_back/$uid.jpg');
        await cnicBackRef.putFile(cnicBackPicture);
        cnicBackPictureUrl = await cnicBackRef.getDownloadURL();
      }

      // Create user document in Firestore
      await users.doc(uid).set({
        'email': email,
        'fullName': fullName,
        'address': address,
        'phoneNumber': phoneNumber,
        'profilePictureUrl': profilePictureUrl,
        'cnicFrontPictureUrl': cnicFrontPictureUrl,
        'cnicBackPictureUrl': cnicBackPictureUrl,
      });

      // Return CloudUser instance
      return CloudUser(
        uid: uid,
        email: email,
        fullName: fullName,
        address: address,
        phoneNumber: phoneNumber,
        profilePictureUrl: profilePictureUrl,
        cnicFrontPictureUrl: cnicFrontPictureUrl,
        cnicBackPictureUrl: cnicBackPictureUrl,
      );
    } catch (e) {
      throw CouldNotCreateUserException();
    }
  }

  // Fetches the user's name from Firestore
  Future<String> getUserName(String userId) async {
    try {
      final doc = await users.doc(userId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return data['fullName'] ?? 'Unknown User';
      } else {
        return 'Unknown User';
      }
    } catch (e) {
      throw Exception('Error fetching user name: $e');
    }
  }

// Fetches the user's profile picture URL from Firestore
  Future<String> getUserProfilePicture(String userId) async {
    try {
      final doc = await users.doc(userId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return data['profilePictureUrl'] ?? '';
      } else {
        return '';
      }
    } catch (e) {
      throw Exception('Error fetching user profile picture: $e');
    }
  }

  Future<Map<String, dynamic>?> getUserDetails(String userId) async {
    try {
      final doc = await users.doc(userId).get();
      return doc.exists ? doc.data() as Map<String, dynamic> : null;
    } catch (e) {
      throw Exception('Error fetching user details: $e');
    }
  }

  // Firebase Cloud Functions for Tasks

  Stream<Iterable<CloudTask>> allTasks() {
    return tasks.snapshots().map((event) => event.docs.map((doc) =>
        CloudTask.fromSnapshot(
            doc as QueryDocumentSnapshot<Map<String, dynamic>>)));
  }

  // Fetch comments count
  Future<int> getCommentsCount(String taskId) async {
    final snapshot = await comments.where('taskId', isEqualTo: taskId).get();
    return snapshot.docs.length;
  }

  // Fetch offers count
  Future<int> getOffersCount(String taskId) async {
    final snapshot = await offers.where('taskId', isEqualTo: taskId).get();
    return snapshot.docs.length;
  }

  Future<void> deleteTask(String taskId) async {
    try {
      // Delete the task document
      await tasks.doc(taskId).delete();

      // Delete associated offers
      final offersSnapshot =
          await offers.where('taskId', isEqualTo: taskId).get();
      if (offersSnapshot.docs.isNotEmpty) {
        for (var offerDoc in offersSnapshot.docs) {
          await offerDoc.reference.delete();
        }
      }

      // Delete associated comments
      final commentsSnapshot =
          await comments.where('taskId', isEqualTo: taskId).get();

      if (commentsSnapshot.docs.isNotEmpty) {
        for (var commentDoc in commentsSnapshot.docs) {
          await commentDoc.reference.delete();
        }
      }
    } catch (e) {
      throw CouldNotDeleteTaskException();
    }
  }

  Future<CloudTask> createNewTask({
    required String ownerUserId,
    required String title,
    required String description,
    required String hours,
    required String location,
    required int budget,
    required String jobType,
    required String category,
    required TaskStatus status,
    required Timestamp createdAt,
    required DateTime dueDate,
  }) async {
    try {
      final document = await tasks.add({
        ownerUserIdFieldName: ownerUserId,
        titleFieldName: title,
        descriptionFieldName: description,
        hoursFieldName: hours,
        locationFieldName: location,
        budgetFieldName: budget,
        jobTypeFieldName: jobType,
        categoryFieldName: category,
        statusFieldName: status.toString().split('.').last,
        createdAtFieldName: createdAt,
        dueDateFieldName: Timestamp.fromDate(dueDate),
      });

      final fetchedTask = await document.get();
      return CloudTask.fromSnapshot(
          fetchedTask as DocumentSnapshot<Map<String, dynamic>>);
    } catch (e) {
      throw CouldNotCreateTaskException();
    }
  }

  Future<void> updateTask({
    required String documentId,
    required String title,
    required String description,
    required String hours,
    required String location,
    required int budget,
    required String category,
    required TaskStatus status,
    required String jobType,
    required DateTime dueDate,
  }) async {
    try {
      Map<String, dynamic> updateData = {
        titleFieldName: title,
        descriptionFieldName: description,
        hoursFieldName: hours,
        locationFieldName: location,
        budgetFieldName: budget,
        categoryFieldName: category,
        statusFieldName: status.toString().split('.').last,
        jobTypeFieldName: jobType,
        dueDateFieldName: Timestamp.fromDate(dueDate),
      };

      await tasks.doc(documentId).update(updateData);
    } catch (e) {
      throw CouldNotUpdateTaskException();
    }
  }

  Future<void> updateTaskStatus({
    required String taskId,
    required TaskStatus status,
  }) async {
    try {
      // Convert the TaskStatus enum to a string
      final statusString = status.toString().split('.').last;

      // Get a reference to the Firestore document
      final taskDocRef =
          FirebaseFirestore.instance.collection(tasksCollection).doc(taskId);

      // Update the status field in the Firestore document
      await taskDocRef.update({
        'status': statusString,
      });
    } catch (e) {
      // Handle errors, e.g., show an error message to the user
    }
  }

  Stream<List<CloudTask>> tasksByTasker(String taskerId) {
    return tasks.where('taskerId', isEqualTo: taskerId).snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => CloudTask.fromSnapshot(
                doc as DocumentSnapshot<Map<String, dynamic>>))
            .toList());
  }

  Stream<List<CloudTask>> tasksByPoster(String posterId) {
    return tasks.where('uid', isEqualTo: posterId).snapshots().map((snapshot) =>
        snapshot.docs
            .map((doc) => CloudTask.fromSnapshot(
                doc as DocumentSnapshot<Map<String, dynamic>>))
            .toList());
  }

  Future<void> createOffer(CloudOffer offer) async {
    try {
      // Generate a new document ID for the offer
      final offerDocRef = offers.doc();

      // Set the offer data
      await offerDocRef.set({
        'taskId': offer.taskId,
        'offererId': offer.offererId,
        'offerAmount': offer.offerAmount,
        'offerTime': offer.offerTime,
        'timestamp': offer.timestamp,
      });
    } catch (e) {
      throw CouldNotCreateOfferException();
    }
  }

  Future<List<CloudOffer>> getOffersForTask(String taskId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection(offersCollection)
        .where('taskId', isEqualTo: taskId)
        .get();

    return querySnapshot.docs
        .map((doc) => CloudOffer.fromSnapshot(doc))
        .toList();
  }

  Future<void> addComment({
    required String taskId,
    required String commentText,
  }) async {
    final userId = AuthService.firebase().currentUser!.id;

    // Create a new comment
    CloudComment newComment = CloudComment(
      commentId: comments.doc().id,
      taskId: taskId,
      commenterId: userId,
      commentText: commentText,
      timestamp: Timestamp.now(),
    );

    // Save the comment to Firestore
    await comments.doc(newComment.commentId).set({
      'taskId': newComment.taskId,
      'commenterId': newComment.commenterId,
      'commentText': newComment.commentText,
      'timestamp': newComment.timestamp,
    });
  }

  Stream<List<CloudComment>> getComments(String taskId) {
    return comments
        .where('taskId', isEqualTo: taskId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CloudComment.fromSnapshot(
                doc as QueryDocumentSnapshot<Map<String, dynamic>>))
            .toList());
  }

  // Functions for Taskers
  Future<CloudTasker> createNewTasker({
    required String userId,
    required int capacityOfWork,
    required List<String> skills,
  }) async {
    if (userId.isEmpty) {
      throw Exception('User ID is missing or empty');
    }

    try {
      // Create tasker document in Firestore
      await taskers.doc(userId).set({
        'uid': userId, // id of the user not the tasker
        'capacityOfWork': capacityOfWork,
        'skills': skills,
        'isTasker': true,
      });

      return CloudTasker(
        userId: userId,
        capacityOfWork: capacityOfWork,
        skills: skills,
      );
    } catch (e) {
      throw CouldNotCreateTaskerException();
    }
  }

  Future<bool> isUserRegisteredAsTasker(String userId) async {
    final taskerDoc = await FirebaseFirestore.instance
        .collection(taskersCollection)
        .doc(userId)
        .get();

    return taskerDoc.exists;
  }
}
