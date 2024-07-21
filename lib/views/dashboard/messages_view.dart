import 'package:flutter/material.dart';
import 'package:timetrader/views/dashboard/side_menu_page/side_menu.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideMenu(),
      appBar: AppBar(
        title: const Text(
          'Messages',
          style: TextStyle(fontSize: 18),
        ),
        centerTitle: true,
        shadowColor: Colors.amber,
        backgroundColor: Colors.lightBlueAccent,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Messages page content goes here',
          // style: Theme.of(context).textTheme.headline4,
        ),
      ),
    );
  }
}
