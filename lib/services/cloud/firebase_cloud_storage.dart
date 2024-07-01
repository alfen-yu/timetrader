import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:timetrader/services/cloud/cloud_storage_constants.dart';
import 'package:timetrader/services/cloud/cloud_storage_exception.dart';
import 'package:timetrader/services/cloud/cloud_user.dart';
import 'package:timetrader/services/cloud/tasks/cloud_task.dart';

class FirebaseCloudStorage {
  final CollectionReference users =
      FirebaseFirestore.instance.collection(usersCollection);

  final FirebaseStorage storage = FirebaseStorage.instance;

  final CollectionReference tasks =
      FirebaseFirestore.instance.collection(tasksCollection);

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

  // Firebase Cloud Functions for Tasks

  Stream<Iterable<CloudTask>> allTasks() {
    return tasks.snapshots().map((event) => event.docs.map((doc) =>
        CloudTask.fromSnapshot(
            doc as QueryDocumentSnapshot<Map<String, dynamic>>)));
  }

  // fetch comments count
  Future<int> getCommentsCount(String taskId) async {
    final snapshot = await tasks.doc(taskId).collection('comments').get();
    return snapshot.docs.length;
  }

  // fetch offers count
  Future<int> getOffersCount(String taskId) async {
    final snapshot = await tasks.doc(taskId).collection('offers').get();
    return snapshot.docs.length;
  }

  Future<void> deleteTask({required String documentId}) async {
    try {
      await tasks.doc(documentId).delete();
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
    required String? category,
    required bool status,
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
        statusFieldName: status,
      });

      final fetchedTask = await document.get();
      return CloudTask.fromSnapshot(
          fetchedTask as QueryDocumentSnapshot<Map<String, dynamic>>);
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
    required String? category,
    required bool status,
    required String jobType,
  }) async {
    try {
      await tasks.doc(documentId).update({
        titleFieldName: title,
        descriptionFieldName: description,
        hoursFieldName: hours,
        locationFieldName: location,
        budgetFieldName: budget,
        categoryFieldName: category,
        statusFieldName: status,
        jobTypeFieldName: jobType,
      });
    } catch (e) {
      throw CouldNotUpdateTaskException();
    }
  }
}

// // using snapshots for live changes, get to retrieve the data,
// Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) =>
//     notes.snapshots().map((event) => event.docs
//         .map((doc) => CloudNote.fromSnapshot(doc))
//         .where((note) => note.ownerUserId == ownerUserId));

// Future<void> updateNote({required String documentId, required String text}) async {
//   try {
//     await notes.doc(documentId).update({textFieldName: text});
//   } catch (e) {
//     throw CouldNotUpdateNoteException();
//   }
// }

// Future<void> deleteNote({required String documentId}) async {
//   try {
//     await notes.doc(documentId).delete();
//   } catch (_) {
//     throw CouldNotDeleteNoteException();
//   }
// }

// Future<Iterable<CloudNote>> getNote({required String ownerUserId}) async {
//   try {
//     return await notes
//         .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
//         .get()
//         .then((value) => value.docs.map((doc) => CloudNote.fromSnapshot(doc)));
//   } catch (e) {
//     throw CouldNotRetrieveNotesException();
//   }
// }

// Future<CloudNote> createNewNote({required String ownerUserId}) async {
//   final document = await notes.add({ownerUserIdFieldName: ownerUserId, textFieldName: ''});
//   final fetchedNote = await document.get();
//   return CloudNote(documentId: fetchedNote.id, ownerUserId: ownerUserId, text: '');
// }
