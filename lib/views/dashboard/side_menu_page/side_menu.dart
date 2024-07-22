import 'package:flutter/material.dart';
import 'package:timetrader/constants/routes.dart';
import 'package:timetrader/services/auth/auth_service.dart';
import 'package:timetrader/services/cloud/firebase_cloud_storage.dart';
import 'package:timetrader/utilities/dialogs/generic_dialog.dart';
import 'package:timetrader/views/dashboard/side_menu_page/register_tasker_sheet.dart';

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
                _buildHeader(userData),
                _buildMenuItem(Icons.verified_user, 'Profile', () {
                  Navigator.pop(context);
                  // Handle profile navigation here
                }),
                _buildMenuItem(Icons.settings, 'Settings', () {
                  Navigator.pop(context);
                  // Handle settings navigation here
                }),
                const Divider(),
                _buildMenuItem(Icons.exit_to_app, 'Logout', () async {
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
                }),
                const Spacer(), // Push the button to the bottom
                _buildRegisterTaskerButton(userData),
                const SizedBox(height: 20.0),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildHeader(Map<String, dynamic> userData) {
    return UserAccountsDrawerHeader(
      margin: EdgeInsets.zero,
      decoration: const BoxDecoration(
        color: Color(0xFF01A47D),
      ),
      accountName: Text(
        userData['fullName'] ?? 'User Name',
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      accountEmail: Text(userData['email'] ?? 'user@example.com'),
      currentAccountPicture: CircleAvatar(
        backgroundImage: NetworkImage(
          userData['profilePictureUrl'] ?? 'https://via.placeholder.com/150',
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

  Widget _buildRegisterTaskerButton(Map<String, dynamic> userData) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ElevatedButton(
        onPressed: () async {
          final authUser = AuthService.firebase().currentUser!;
          final isRegistered = await FirebaseCloudStorage()
              .isUserRegisteredAsTasker(authUser.id);
          if (!mounted) return;
          if (isRegistered) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('You are already registered as a tasker.')));
          } else {
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) =>
                  RegisterTaskerBottomSheet(userData: userData),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          textStyle: const TextStyle(fontSize: 16),
        ),
        child: const Text('Register as a Tasker'),
      ),
    );
  }
}
