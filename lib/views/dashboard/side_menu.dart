import 'package:flutter/material.dart';
import 'package:timetrader/constants/routes.dart';
import 'package:timetrader/services/auth/auth_service.dart';
import 'package:timetrader/services/cloud/firebase_cloud_storage.dart';
import 'package:timetrader/utilities/dialogs/generic_dialog.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  Future<Map<String, dynamic>?>? user;

  @override
  void initState() {
    super.initState();
    user = fetchUserDetails();
  }

  Future<Map<String, dynamic>?> fetchUserDetails() async {
    final authUser = AuthService.firebase().currentUser;
    if (authUser != null) {
      final userObject =
          await FirebaseCloudStorage().getUserDetails(authUser.id);
      return userObject;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder<Map<String, dynamic>?>(
        future: user,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('User not found'));
          } else {
            final userData = snapshot.data!;
            return Column(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.green,
                  ),
                  accountName: Text(userData['fullName'] ?? 'User Name'),
                  accountEmail: Text(userData['email'] ?? 'user@example.com'),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: NetworkImage(
                      userData['profilePictureUrl'] ??
                          'https://via.placeholder.com/150',
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.verified_user),
                  title: const Text('Profile'),
                  onTap: () {
                    Navigator.of(context).pop();
                    // Handle navigation here
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () {
                    Navigator.of(context).pop();
                    // Handle navigation here
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.exit_to_app),
                  title: const Text('Logout'),
                  onTap: () async {
                    final logoutResult = await showGenericDialog(
                      context: context,
                      title: 'Logout?',
                      content: 'Are you sure you want to logout?',
                      optionsBuilder: () => {'OK': true, 'Cancel': false},
                    );
                    if (logoutResult) {
                      await AuthService.firebase().logout();
                      if (!context.mounted) return;
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil(loginRoute, (_) => false);
                    }
                  },
                ),
                const Spacer(),
                ListTile(
                  title: ElevatedButton(
                    onPressed: () {
                      // Handle navigation to the registration page
                    },
                    child: const Text('Register as a Tasker'),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
