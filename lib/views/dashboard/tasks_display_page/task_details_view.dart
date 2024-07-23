import 'package:flutter/material.dart';
import 'package:timetrader/enums/task_status.dart';
import 'package:timetrader/services/auth/auth_service.dart';
import 'package:timetrader/services/cloud/firebase_cloud_storage.dart';
import 'package:timetrader/services/cloud/tasks/cloud_comment.dart';
import 'package:timetrader/services/cloud/tasks/cloud_offer.dart';
import 'package:timetrader/services/cloud/tasks/cloud_task.dart';
import 'package:intl/intl.dart';
import 'package:timetrader/views/dashboard/tasks_display_page/make_offer.dart';

class TaskDetailsView extends StatefulWidget {
  final CloudTask task;

  const TaskDetailsView({super.key, required this.task});

  @override
  State<TaskDetailsView> createState() => _TaskDetailsViewState();
}

class _TaskDetailsViewState extends State<TaskDetailsView> {
  late CloudTask task;

  @override
  void initState() {
    super.initState();
    task = widget.task;
  }

  @override
  Widget build(BuildContext context) {
    final dueDateFormatted =
        DateFormat('yyyy-MM-dd').format(widget.task.dueDate);
    final userId = AuthService.firebase().currentUser!.id;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task.title),
        backgroundColor: const Color(0xFF01A47D),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Map<String, dynamic>?>(
          future:
              FirebaseCloudStorage().getUserDetails(widget.task.ownerUserId),
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
                            content: widget.task.location,
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
                          _buildBudgetEstimateSection(
                              widget.task, userId, context),
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
                            widget.task.description,
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
                  FutureBuilder<List<CloudOffer>>(
                    future: FirebaseCloudStorage()
                        .getOffersForTask(widget.task.taskId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return _buildNoOffersSection();
                      } else {
                        final offers = snapshot.data!;
                        return _buildOffersSection(offers);
                      }
                    },
                  ),
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

  Widget _buildBudgetEstimateSection(
      CloudTask task, String userId, BuildContext context) {
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
        if (task.ownerUserId != userId &&
            task.status !=
                TaskStatus
                    .accepted) // Check if the user is not the task owner and task is not accepted
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Check if the user is a registered tasker
                FirebaseCloudStorage()
                    .isUserRegisteredAsTasker(userId)
                    .then((isTasker) {
                  if (isTasker) {
                    makeOfferSheet(
                      context: context,
                      taskId: task.taskId,
                      offererId: userId,
                      onOfferMade: (offerAmount) {
                        _handleOfferMade(context, task, userId, offerAmount);
                      },
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please register as a tasker first.'),
                      ),
                    );
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF01A47D),
                foregroundColor: Colors.white,
              ),
              child: const Text('Make an Offer'),
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

  void _handleOfferMade(BuildContext context, CloudTask task, String userId,
      double offerAmount) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Accept Task'),
          content: const Text('Do you want to accept this task?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Accept'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      final updatedTask = task.copyWith(
        status: TaskStatus.accepted,
      );

      await FirebaseCloudStorage().updateTaskStatus(
        taskId: updatedTask.taskId,
        status: updatedTask.status,
      );

      // Update UI to reflect the changes
      // In a StatelessWidget, you would need to use a StatefulWidget or a state management solution
      // to trigger a rebuild or refresh

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task has been accepted.'),
        ),
      );
    }
  }

  Widget _buildOffersSection(List<CloudOffer> offers) {
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
        if (widget.task.status == TaskStatus.accepted)
          Center(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: const Text(
                'Task has been accepted. No further actions allowed.',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
        else
          for (final offer in offers) _buildOfferCard(offer),
      ],
    );
  }

  void _handleAcceptOffer(CloudOffer offer) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Accept Task'),
          content: const Text('Do you want to accept this task?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Accept'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      final updatedTask = widget.task.copyWith(
        status: TaskStatus.accepted,
      );

      await FirebaseCloudStorage().updateTaskStatus(
        taskId: updatedTask.taskId,
        status: updatedTask.status,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task has been accepted.'),
        ),
      );

      setState(() {
        task = updatedTask; // Update the task in the UI
      });
    }
  }

  Widget _buildOfferCard(CloudOffer offer) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: FirebaseCloudStorage().getUserDetails(offer.offererId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('User not found.'));
        } else {
          final userDetails = snapshot.data!;
          final DateTime offerDateTime = (offer.timestamp).toDate();
          final timeAgo = _getTimeDifference(offerDateTime);

          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            NetworkImage(userDetails['profilePictureUrl']),
                        radius: 20,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userDetails['fullName'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            timeAgo,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Rs. ${offer.offerAmount}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      if (widget.task.ownerUserId ==
                              AuthService.firebase().currentUser!.id &&
                          widget.task.status != TaskStatus.accepted)
                        TextButton(
                          onPressed: () => _handleAcceptOffer(offer),
                          child: const Text('Accept'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildNoOffersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
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
    TextEditingController commentController = TextEditingController();

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
        if (widget.task.status == TaskStatus.accepted)
          Center(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: const Text(
                'Task has been accepted. Comments are disabled.',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
        else ...[
          const SizedBox(height: 16.0),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: commentController,
                  decoration: InputDecoration(
                    hintText: 'Type your comment...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 10.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              IconButton(
                icon: const Icon(Icons.send, color: Colors.teal),
                onPressed: () async {
                  if (commentController.text.isNotEmpty) {
                    await FirebaseCloudStorage().addComment(
                      taskId: widget.task.taskId,
                      commentText: commentController.text,
                    );

                    // Clear the text field
                    commentController.clear();
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          StreamBuilder<List<CloudComment>>(
            stream: FirebaseCloudStorage().getComments(widget.task.taskId),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              var comments = snapshot.data!;

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  CloudComment comment = comments[index];
                  return ListTile(
                    leading: FutureBuilder<String>(
                      future: FirebaseCloudStorage()
                          .getUserProfilePicture(comment.commenterId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return const Icon(Icons.error);
                        } else {
                          final profilePictureUrl = snapshot.data ?? '';
                          return CircleAvatar(
                            backgroundImage: profilePictureUrl.isNotEmpty
                                ? NetworkImage(profilePictureUrl)
                                : null,
                            child: profilePictureUrl.isEmpty
                                ? const Icon(Icons.person)
                                : null,
                          );
                        }
                      },
                    ),
                    title: FutureBuilder<String>(
                      future: FirebaseCloudStorage()
                          .getUserName(comment.commenterId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text('Loading...');
                        } else if (snapshot.hasError) {
                          return const Text('Error');
                        } else {
                          return Text(snapshot.data ?? 'Unknown User');
                        }
                      },
                    ),
                    subtitle: Text(
                      '${comment.commentText}\n${_getTimeDifference(comment.timestamp.toDate())}',
                    ),
                  );
                },
              );
            },
          ),
        ],
      ],
    );
  }

  String _getTimeDifference(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'just now';
    }
  }
}