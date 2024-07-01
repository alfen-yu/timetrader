import 'package:flutter/material.dart';

class Category {
  final String name;
  final IconData icon;

  Category({required this.name, required this.icon});
}

class CategoryTile extends StatelessWidget {
  final Category category;

  const CategoryTile({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(category.icon, size: 40, color: const Color.fromARGB(255, 70, 65, 65)),
          const SizedBox(height: 8),
          Text(
            category.name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

final List<Category> categories = [
  Category(name: 'Cleaning', icon: Icons.cleaning_services),
  Category(name: 'AC Service', icon: Icons.ac_unit),
  Category(name: 'Electrician', icon: Icons.electrical_services),
  Category(name: 'Plumber', icon: Icons.plumbing),
  Category(name: 'Carpenter', icon: Icons.build),
  Category(name: 'Painter', icon: Icons.palette),
  Category(name: 'Web Developer', icon: Icons.web),
  Category(name: 'Digital Marketing', icon: Icons.mark_email_read),
  Category(name: 'Tailor', icon: Icons.content_cut),
  Category(name: 'Pickup & Delivery', icon: Icons.delivery_dining),
  Category(name: 'Labor', icon: Icons.work),
  Category(name: 'Home & Office Repairs', icon: Icons.home_repair_service),
  Category(name: 'Moving', icon: Icons.local_shipping),
  Category(name: 'Handyman', icon: Icons.handyman),
  Category(name: 'Event Planner', icon: Icons.event),
  Category(name: 'Graphic Designer', icon: Icons.graphic_eq),
  Category(name: 'Gardener', icon: Icons.eco),
  Category(name: 'Car Washer', icon: Icons.local_car_wash),
  Category(name: 'Photographers', icon: Icons.camera_alt),
  Category(name: 'Beautician', icon: Icons.face),
  Category(name: 'Domestic Help', icon: Icons.people_alt),
  Category(name: 'Drivers and Cab', icon: Icons.directions_car),
  Category(name: 'Tile Fixer', icon: Icons.bathtub),
  Category(name: 'CCTV', icon: Icons.security),
  Category(name: 'Welder', icon: Icons.construction),
  Category(name: 'Pest Control', icon: Icons.bug_report),
  Category(name: 'Cooking Services', icon: Icons.restaurant_menu),
  Category(name: 'Lock Master', icon: Icons.lock),
  Category(name: 'Consultant', icon: Icons.leaderboard),
  Category(name: 'Mechanic', icon: Icons.build_circle),
  Category(name: 'Fitness Trainer', icon: Icons.fitness_center),
  Category(name: 'Repairing', icon: Icons.settings),
  Category(name: 'UI/UX', icon: Icons.mobile_friendly),
  Category(name: 'Video and Audio Editors', icon: Icons.videocam),
  Category(name: 'Interior Designer', icon: Icons.home),
  Category(name: 'Architect', icon: Icons.architecture),
  Category(name: 'Lawyers/Legal Advisors', icon: Icons.gavel),
  Category(name: 'Others', icon: Icons.more_horiz),
];