import 'package:flutter/material.dart';
import 'package:timetrader/constants/routes.dart';
import 'package:timetrader/enums/menu_action.dart';
import 'package:timetrader/services/auth/auth_service.dart';
import 'package:timetrader/utilities/dialogs/generic_dialog.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Earn Money', style: TextStyle(fontSize: 18),),
        centerTitle: true,
        shadowColor: Colors.amber,
        backgroundColor: Colors.lightBlueAccent,
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<MenuAction>(onSelected: (value) async {
            switch (value) {
              case MenuAction.logout:
                final logoutResult = await showGenericDialog(
                    context: context,
                    title: 'Logout?',
                    content: 'Are you sure you want to logout?',
                    optionsBuilder: () => {'OK': true, 'Cancel': false});
                if (logoutResult) {
                  await AuthService.firebase().logout();
                  if (!context.mounted) return;
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(loginRoute, (_) => false);
                }
              default:
            }
          }, itemBuilder: (context) {
            return const [
              PopupMenuItem<MenuAction>(
                value: MenuAction.logout,
                child: Text('Logout'),
              ),
              PopupMenuItem<MenuAction>(
                value: MenuAction.logout,
                child: Text('Settings'),
              )
            ];
          })
        ],
      ),
    );
  }
}
