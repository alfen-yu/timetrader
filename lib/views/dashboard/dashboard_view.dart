import 'package:flutter/material.dart';
import 'package:timetrader/views/dashboard/account_view.dart';
import 'package:timetrader/views/dashboard/messages_view.dart';
import 'package:timetrader/views/dashboard/navigation_bar.dart';
import 'package:timetrader/views/dashboard/post_tasks_page/post_task_view.dart';
import 'package:timetrader/views/dashboard/tasks_display_page/tasks_view.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int pageIndex = 0;

  void onPageSelected(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBarView(
        currentIndex: pageIndex,
        onDestinationSelected: onPageSelected,
      ),
      body: <Widget>[
        const TasksPage(),
        const PostTaskView(),
        const MessagesPage(),
        const AccountPage(),
      ][pageIndex],
    );
  }
}
