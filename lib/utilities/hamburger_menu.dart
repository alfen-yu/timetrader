import 'package:flutter/material.dart';
import 'package:timetrader/constants/routes.dart';
import 'package:timetrader/enums/menu_action.dart';
import 'package:timetrader/services/auth/auth_service.dart';
import 'package:timetrader/utilities/dialogs/generic_dialog.dart';

class HamburgerMenu extends StatelessWidget {
  const HamburgerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuAction>(
      onSelected: (value) async {
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
            break;
          case MenuAction.settings:
            break;
        }
      },
      itemBuilder: (context) {
        return const [
          PopupMenuItem<MenuAction>(
            value: MenuAction.logout,
            child: Text('Logout'),
          ),
          PopupMenuItem<MenuAction>(
            value: MenuAction.settings,
            child: Text('Settings'),
          ),
        ];
      },
    );
  }
}
