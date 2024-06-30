import 'package:flutter/material.dart';

class NavigationBarView extends StatelessWidget {
  final int currentIndex;
  final Function(int) onDestinationSelected;

  const NavigationBarView
({
    required this.currentIndex,
    required this.onDestinationSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      onDestinationSelected: onDestinationSelected,
      indicatorColor: Colors.lightBlueAccent,
      backgroundColor: Colors.white,
      selectedIndex: currentIndex,
      destinations: const <Widget>[
        NavigationDestination(
          selectedIcon: Icon(Icons.task),
          icon: Icon(Icons.task_outlined),
          label: 'Tasks',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.post_add),
          icon: Icon(Icons.post_add_outlined),
          label: 'Post a Task',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.messenger),
          icon: Icon(Icons.messenger_outline),
          label: 'Messages',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.account_circle),
          icon: Icon(Icons.account_circle_outlined),
          label: 'Account',
        ),
      ],
    );
  }
}
