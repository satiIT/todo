import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/provider.dart';
import '../models/taskClass.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;
  final int index;

  TaskDetailScreen({super.key, required this.task, required this.index});

  final _subTaskController = TextEditingController();
   Color _getImportanceColor(String importance) {
    switch (importance) {
      case 'Important':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Normal':
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(task.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
             const SizedBox(height: 10),
            Text(
              'Importance: ${task.importance}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _getImportanceColor(task.importance),
              )),
            Text('Due Date: ${task.dueDate.toLocal()}'.split(' ')[0]),
            const SizedBox(height: 10),
            Expanded(
              child: Consumer<TaskProvider>(
                builder: (context, taskProvider, child) {
                  return ListView.builder(
                    itemCount: task.subTasks.length,
                    itemBuilder: (context, subTaskIndex) {
                      final subTask = task.subTasks[subTaskIndex];
                      return ListTile(
                        title: Text(subTask.title),
                        trailing: Checkbox(
                          value: subTask.isCompleted,
                          onChanged: (value) {
                            taskProvider.toggleSubTaskCompletion(
                                index, subTaskIndex);
                          },
                        ),
                        onLongPress: () {
                          taskProvider.removeSubTask(index, subTaskIndex);
                        },
                      );
                    },
                  );
                },
              ),
            ),
            TextField(
              controller: _subTaskController,
              decoration: const InputDecoration(labelText: 'New SubTask'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_subTaskController.text.isNotEmpty) {
                  final taskProvider =
                      Provider.of<TaskProvider>(context, listen: false);
                  taskProvider.addSubTask(
                    index,
                    SubTask(title: _subTaskController.text),
                  );
                  _subTaskController.clear();
                }
              },
              child: const Text('Add SubTask'),
            ),
          ],
        ),
      ),
    );
  }
}
