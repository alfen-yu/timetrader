// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:permission_handler/permission_handler.dart';

// class GetPermissions {
//   static Future<bool> getCameraPermission() async {
//     PermissionStatus permissionStatus = await Permission.camera.status;

//     if (permissionStatus.isGranted) {
//       return true;
//     } else if (permissionStatus.isDenied) {
//       PermissionStatus status = await Permission.camera.request();
//       if (status.isGranted) {
//         return true;
//       } else {
//         Fluttertoast.showToast(
//         msg: "Camera permission is required.",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.CENTER,
//         textColor: Colors.white,
//         fontSize: 16.0
//     );
//         return false;
//       }
//     } else {
//       Fluttertoast.showToast(
//         msg: "Camera permission is required.",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.CENTER,
//         textColor: Colors.white,
//         fontSize: 16.0
//     );
//       return false;
//     }
//   }

//   static Future<bool> getStoragePermission() async {
//     PermissionStatus permissionStatus = await Permission.storage.status;

//     if (permissionStatus.isGranted) {
//       return true;
//     } else if (permissionStatus.isDenied) {
//       PermissionStatus status = await Permission.storage.request();
//       if (status.isGranted) {
//         return true;
//       } else {
//         Fluttertoast.showToast(
//         msg: "Storage permission is required.",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.CENTER,
//         textColor: Colors.white,
//         fontSize: 16.0
//     );
//         return false;
//       }
//     } else {
//       Fluttertoast.showToast(
//         msg: "Storage permission is required.",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.CENTER,
//         textColor: Colors.white,
//         fontSize: 16.0
//     );
//       return false;
//     }
//   }
// }
