import 'package:flutter/material.dart';
import 'package:timetrader/views/dashboard/hamburger_menu.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Account',
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
          'Account page content goes here',
        ),
      ),
    );
  }
}
