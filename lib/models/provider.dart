import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import './taskClass.dart';  // Import Task and SubTask models

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  TaskProvider() {
    loadTasks();  // Load tasks from local storage when the app starts
  }

  // Add a new task
  void addTask(Task task) {
    _tasks.add(task);
    saveTasks();
    notifyListeners();
  }

  // Update an existing task
  void updateTask(int index, Task updatedTask) {
    _tasks[index] = updatedTask;
    saveTasks();
    notifyListeners();
  }

  // Delete a task
  void deleteTask(int index) {
    _tasks.removeAt(index);
    saveTasks();
    notifyListeners();
  }

  // Toggle task completion status
  void toggleTaskCompletion(int index) {
    _tasks[index].isCompleted = !_tasks[index].isCompleted;
    saveTasks();
    notifyListeners();
  }

  // Add a new subtask to a specific task
  void addSubTask(int taskIndex, SubTask subTask) {
    // Ensure subTasks is mutable
    _tasks[taskIndex].subTasks = List.from(_tasks[taskIndex].subTasks)..add(subTask);
    saveTasks();
    notifyListeners();
  }

  // Toggle the completion status of a subtask
  void toggleSubTaskCompletion(int taskIndex, int subTaskIndex) {
    _tasks[taskIndex].subTasks = List.from(_tasks[taskIndex].subTasks);
    _tasks[taskIndex].subTasks[subTaskIndex].isCompleted =
        !_tasks[taskIndex].subTasks[subTaskIndex].isCompleted;
    saveTasks();
    notifyListeners();
  }

  // Remove a subtask from a specific task
  void removeSubTask(int taskIndex, int subTaskIndex) {
    _tasks[taskIndex].subTasks = List.from(_tasks[taskIndex].subTasks)..removeAt(subTaskIndex);
    saveTasks();
    notifyListeners();
  }

  // Save tasks to local storage
  void saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = _tasks.map((task) => json.encode(task.toJson())).toList();
    await prefs.setStringList('tasks', tasksJson);
  }

  // Load tasks from local storage
  void loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getStringList('tasks') ?? [];
    _tasks = tasksJson.map((taskJson) => Task.fromJson(json.decode(taskJson))).toList();
    notifyListeners();
  }
  
}
