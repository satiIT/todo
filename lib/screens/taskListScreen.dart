import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/provider.dart';
import './taskDetailScreen.dart';
import './addTaskScreen.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

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
        title: const Text('Task List'),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          return ListView.builder(
            itemCount: taskProvider.tasks.length,
            itemBuilder: (context, index) {
              final task = taskProvider.tasks[index];
              return Dismissible(
                key: Key(task.title),
                onDismissed: (direction) {
                  taskProvider.deleteTask(index);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Task deleted')),
                  );
                },
                background: Container(color: Colors.red ,child: const Center(child: Text('delete Task',style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                ),)),),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 102, 124, 223),  // Darker container background
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    title:  Text(
                          task.importance,
                          style: TextStyle(
                            color: _getImportanceColor(task.importance),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(task.title, style: const TextStyle(color: Colors.white)),
                        Text(
                          'Due: ${task.dueDate.toLocal()}'.split(' ')[0],
                          style: const TextStyle(color: Colors.white70),
                        ),
                       
                      ],
                    ),
                    trailing: Checkbox(
                      value: task.isCompleted,
                      onChanged: (value) {
                        taskProvider.toggleTaskCompletion(index);
                      },
                      activeColor: Colors.green,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TaskDetailScreen(task: task, index: index),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
