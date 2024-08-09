// import 'package:timetrader/services/cloud/tasks/cloud_task.dart';

// class TaskItem {
//   final CloudTask task;
//   final int index;

//   TaskItem(this.task, this.index);
// }

// List<CloudTask> knapsack(List<CloudTask> tasks, int capacity) {
//   int n = tasks.length;
//   List<List<int>> dp = List.generate(n + 1, (_) => List.filled(capacity + 1, 0));
//   List<List<bool>> keep = List.generate(n + 1, (_) => List.filled(capacity + 1, false));

//   for (int i = 1; i <= n; i++) {
//     for (int w = 0; w <= capacity; w++) {
//       if (tasks[i - 1].hours <= w) {
//         int include = tasks[i - 1].budget + dp[i - 1][w - tasks[i - 1].hours];
//         int exclude = dp[i - 1][w];
//         if (include > exclude) {
//           dp[i][w] = include;
//           keep[i][w] = true;
//         } else {
//           dp[i][w] = exclude;
//           keep[i][w] = false;
//         }
//       } else {
//         dp[i][w] = dp[i - 1][w];
//       }
//     }
//   }

//   List<CloudTask> result = [];
//   int w = capacity;
//   for (int i = n; i > 0; i--) {
//     if (keep[i][w]) {
//       result.add(tasks[i - 1]);
//       w -= tasks[i - 1].hours;
//     }
//   }

//   return result;
// }
