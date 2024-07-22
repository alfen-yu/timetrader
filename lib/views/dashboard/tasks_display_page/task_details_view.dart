import 'package:flutter/material.dart';
import 'package:timetrader/services/cloud/firebase_cloud_storage.dart';
import 'package:timetrader/services/cloud/tasks/cloud_task.dart';
import 'package:intl/intl.dart';

class TaskDetailsView extends StatelessWidget {
  final CloudTask task;

  const TaskDetailsView({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final dueDateFormatted = DateFormat('yyyy-MM-dd').format(task.dueDate);

    return Scaffold(
      appBar: AppBar(
        title: Text(task.title),
        backgroundColor: const Color(0xFF01A47D), 
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Map<String, dynamic>?>(
          future: FirebaseCloudStorage().getUserDetails(task.ownerUserId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('User not found.'));
            } else {
              final userDetails = snapshot.data!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Posted By Section
                  _buildUserProfileSection(userDetails),
                  const SizedBox(height: 20),
                  // Details Card
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Location Section
                          _buildDetailRow(
                            icon: Icons.location_on,
                            title: 'Location',
                            content: task.location,
                          ),
                          const SizedBox(height: 16.0),
                          // Due Date Section
                          _buildDetailRow(
                            icon: Icons.date_range,
                            title: 'Due Date',
                            content: dueDateFormatted,
                          ),
                          const SizedBox(height: 16.0),
                          // Task Budget Estimate Section
                          _buildBudgetEstimateSection(task),
                          // Description Section
                          const SizedBox(height: 20.0), 
                          const Text(
                            'Description:',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            task.description,
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Offers Section
                  _buildOffersSection(),
                  const SizedBox(height: 20),
                  // Comments Section
                  _buildCommentsSection(),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20.0, color: Colors.teal),
        const SizedBox(width: 8.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              content,
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.black87,
              ),
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
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
        const SizedBox(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Budget',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black87,
              ),
            ),
            Text(
              'Rs. ${task.budget}',
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20.0),
        Center(
          child: ElevatedButton(
            onPressed: () {
              // Implement action for making an offer
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              backgroundColor: const Color(0xFF01A47D), 
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            child: const Text(
              'Make an Offer',
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserProfileSection(Map<String, dynamic> userDetails) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(userDetails['profilePictureUrl']),
          radius: 25,
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Posted By: ${userDetails['fullName']}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOffersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Offers:',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
        const SizedBox(height: 8.0),
        Center(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.redAccent.withOpacity(0.1),
              border: Border.all(color: Colors.redAccent),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: const Text(
              'No offers yet.',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.redAccent,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCommentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Comments:',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
        const SizedBox(height: 8.0),
        Center(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: const Text(
              'No comments yet.',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black54,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
