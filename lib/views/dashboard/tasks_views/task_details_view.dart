import 'package:flutter/material.dart';
import 'package:timetrader/services/cloud/tasks/cloud_task.dart'; // Ensure this import matches your CloudTask model

class TaskDetailsView extends StatelessWidget {
  final CloudTask task;

  const TaskDetailsView({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(task.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Posted By: User Profile Section
            ListTile(
              leading: CircleAvatar(
                // Use user's profile picture or placeholder
                backgroundColor: Colors.grey,
                child: Text(task.taskId[0]), // Adjust as needed based on your data structure
              ),
              title: Text("Posted By: ${task.taskId}"), // Adjust as needed based on your data structure
            ),
            const SizedBox(height: 16.0),

            // Location Section
            _buildDetailRow(
              icon: Icons.location_on,
              title: 'Location',
              content: task.location,
            ),
            const SizedBox(height: 16.0),

            // Due Date Section (if available)
            _buildDetailRow(
              icon: Icons.date_range,
              title: 'Due Date',
              content: task.dueDate as String, // Replace with actual due date if available
            ),
            const SizedBox(height: 16.0),

            // Task Budget Estimate Section
            _buildBudgetEstimateSection(task),

            // Description Section
            const SizedBox(height: 16.0),
            const Text(
              'Description:',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              task.description,
              style: const TextStyle(fontSize: 16.0),
            ),

            // Offers Section (to be implemented)
            const SizedBox(height: 16.0),
            const Text(
              'Offers:',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'No offers yet.', // Placeholder for displaying offers
              style: TextStyle(fontSize: 16.0),
            ),

            // Comments Section (to be implemented)
            const SizedBox(height: 16.0),
            const Text(
              'Comments:',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'No comments yet.', // Placeholder for displaying comments
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({required IconData icon, required String title, required String content}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20.0),
        const SizedBox(width: 8.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4.0),
            Text(
              content,
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBudgetEstimateSection(CloudTask task) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Task Budget Estimate:',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Budget',
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              'Rs. ${task.budget}',
              style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        ElevatedButton(
          onPressed: () {
            // Implement action for making an offer
          },
          child: const Text('Make an Offer'),
        ),
      ],
    );
  }
}
