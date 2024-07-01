import 'package:flutter/material.dart';
import 'package:timetrader/constants/routes.dart';
import 'package:timetrader/views/dashboard/hamburger_menu.dart';
import 'package:timetrader/views/dashboard/post_tasks/categories.dart';

class PostTaskView extends StatelessWidget {
  const PostTaskView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'What do you need help with?',
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
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          return IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                crudTaskViewRoute,
                arguments: {'category': categories[index].name},
              );
            },
            icon: CategoryTile(category: categories[index]),
          );
        },
      ),
    );
  }
}
