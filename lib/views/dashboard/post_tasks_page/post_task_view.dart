import 'package:flutter/material.dart';
import 'package:timetrader/constants/categories.dart';
import 'package:timetrader/constants/routes.dart';
import 'package:timetrader/views/dashboard/post_tasks_page/category_tiles.dart';
import 'package:timetrader/views/dashboard/side_menu_page/side_menu.dart';

class PostTaskView extends StatelessWidget {
  const PostTaskView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideMenu(),
      appBar: AppBar(
        title: const Text(
          'What do you need help with?',
          style: TextStyle(fontSize: 18),
        ),
        centerTitle: true,
        shadowColor: Colors.amber,
        backgroundColor: Colors.lightBlueAccent,
        foregroundColor: Colors.white,
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
          return InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(
                crudTaskViewRoute,
                arguments: {'category': categories[index].name},
              );
            },
            child: CategoryTile(category: categories[index]),
          );
        },
      ),
    );
  }
}
