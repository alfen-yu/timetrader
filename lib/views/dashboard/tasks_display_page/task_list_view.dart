import 'package:flutter/material.dart';
import 'package:timetrader/services/cloud/tasks/cloud_task.dart';
import 'package:timetrader/services/cloud/firebase_cloud_storage.dart';
import 'package:timetrader/enums/task_status.dart';

typedef TaskCallback = void Function(CloudTask task);

class TasksListView extends StatelessWidget {
  final Iterable<CloudTask> tasks;
  final TaskCallback onTapTask;

  const TasksListView({
    super.key,
    required this.tasks,
    required this.onTapTask,
  });

  Future<String> _getProfilePictureUrl(String userId) async {
    final FirebaseCloudStorage cloudStorage = FirebaseCloudStorage();
    return await cloudStorage.storage
        .ref()
        .child('profile_pictures/$userId.jpg')
        .getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    final sortedTasks = tasks.toList()
      ..sort((a, b) => b.taskId.compareTo(a.taskId));

    return ListView.builder(
      itemCount: sortedTasks.length,
      itemBuilder: (context, index) {
        final task = sortedTasks[index];
        return FutureBuilder<String>(
          future: _getProfilePictureUrl(task.ownerUserId),
          builder: (context, snapshot) {
            final profilePictureUrl =
                snapshot.data ?? 'https://via.placeholder.com/150';
            return Container(
              color: Colors.white,
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: ListTile(
                onTap: () => onTapTask(task),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: SizedBox(
                  width: 60,
                  height: 60,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(profilePictureUrl),
                  ),
                ),
                title: Text(
                  task.title,
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 14),
                        const SizedBox(width: 4),
                        Text(task.jobType == 'Physical' ? task.location : 'Online'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        FutureBuilder<int>(
                          future: FirebaseCloudStorage().getCommentsCount(task.taskId),
                          builder: (context, snapshot) {
                            final commentsCount = snapshot.data ?? 0;
                            return Row(
                              children: [
                                const Icon(Icons.comment, size: 10),
                                const SizedBox(width: 8),
                                Text(
                                  '$commentsCount Comments',
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(width: 16),
                        FutureBuilder<int>(
                          future: FirebaseCloudStorage().getOffersCount(task.taskId),
                          builder: (context, snapshot) {
                            final offersCount = snapshot.data ?? 0;
                            return Row(
                              children: [
                                const Icon(Icons.local_offer, size: 10),
                                const SizedBox(width: 8),
                                Text(
                                  '$offersCount Offers',
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: _getStatusColor(task.status),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Text(
                        _getStatusText(task.status),
                        style: const TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rs.${task.budget}',
                      style: const TextStyle(fontSize: 12, color: Colors.lightBlueAccent),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _getStatusText(TaskStatus status) {
    switch (status) {
      case TaskStatus.open:
        return 'Open';
      case TaskStatus.closed:
        return 'Closed';
      case TaskStatus.accepted:
        return 'Accepted';
      default:
        return 'Unknown';
    }
  }

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.open:
        return Colors.green;
      case TaskStatus.closed:
        return Colors.red;
      case TaskStatus.accepted:
        return Colors.yellow;
      default:
        return Colors.grey;
    }
  }
}
