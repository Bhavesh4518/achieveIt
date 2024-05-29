import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../common/widgets/confirm_dialog.dart';
import '../models/task_model.dart';

class TaskStreams extends StatelessWidget {
  const TaskStreams({Key? key, required this.stream});

  final Stream<List<Task>>? stream;

  void updateTaskStatus(String taskId, String status) {
    FirebaseFirestore.instance.collection('Tasks').doc(taskId).update({
      'status': status,
    }).then((_) {
      print('Task $taskId updated successfully.');
    }).catchError((error) {
      print('Failed to update task: $error');
    });
  }

  void deleteTask(String taskId) {
    FirebaseFirestore.instance.collection('Tasks').doc(taskId).delete().then((_) {
      print('Task $taskId deleted successfully.');
    }).catchError((error) {
      print('Failed to delete task: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 0, right: 8, top: 16, bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Color(0xFFF8F8F8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            spreadRadius: 2,
            blurRadius: 2,
            offset: Offset(0, 1),
          )
        ],
      ),
      child: StreamBuilder<List<Task>>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          final tasks = snapshot.data ?? [];
          if (tasks.isEmpty) {
            return Center(
              child: Text('No tasks found.'),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Dismissible(
                key: Key(task.id),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  deleteTask(task.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Task deleted')),
                  );
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                child: ListTile(
                  leading: IconButton(
                    icon: Icon(
                      task.status == 'completed'
                          ? Icons.task_alt_sharp
                          : Icons.task_alt,
                      color: task.status == 'completed'
                          ? Colors.green
                          : Colors.grey,
                    ),
                    onPressed: () async {
                      if (task.status != 'completed') {
                        final confirm = await showConfirmationDialog(context);
                        if (confirm == true) {
                          updateTaskStatus(task.id, 'completed');
                        }
                      }
                    },
                  ),
                  title: Text(task.title),
                  subtitle: Text(task.description),
                  trailing: Text(task.status),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
