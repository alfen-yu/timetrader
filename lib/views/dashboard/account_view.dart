import 'package:flutter/material.dart';
import 'package:timetrader/views/dashboard/side_menu_page/side_menu.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideMenu(),
      appBar: AppBar(
        title: const Text(
          'Account',
          style: TextStyle(fontSize: 18),
        ),
        centerTitle: true,
        shadowColor: Colors.amber,
        backgroundColor: Colors.lightBlueAccent,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Account page content goes here',
        ),
      ),
    );
  }
}
