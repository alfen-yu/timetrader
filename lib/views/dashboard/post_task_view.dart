import 'package:flutter/material.dart';
import 'package:timetrader/views/dashboard/hamburger_menu.dart';

class PostTaskView extends StatelessWidget {
  const PostTaskView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Post a Task',
          style: TextStyle(fontSize: 18),
        ),
        centerTitle: true,
        shadowColor: Colors.amber,
        backgroundColor: Colors.lightBlueAccent,
        foregroundColor: Colors.white,
        actions: const [
          HamburgerMenu(),
        ],
      ),
      body: const Center(
        child: Text(
          'Post a Task page content goes here',
        ),
      ),
    );
  }
}
