import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/provider.dart';
import '../models/taskClass.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  String _selectedImportance = 'Normal';  // Default importance

  void _pickDueDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  _selectedDate == null
                      ? 'No due date chosen!'
                      : 'Due Date: ${_selectedDate!.toLocal()}'.split(' ')[0],
                ),
                const Spacer(),
                TextButton(
                  onPressed: _pickDueDate,
                  child: const Text('Pick Due Date'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: _selectedImportance,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedImportance = newValue!;
                });
              },
              items: ['Important', 'Medium', 'Normal'].map((String importance) {
                return DropdownMenuItem<String>(
                  value: importance,
                  child: Text(importance),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: () {
                if (_titleController.text.isNotEmpty &&
                    _descriptionController.text.isNotEmpty &&
                    _selectedDate != null) {
                  final taskProvider =
                      Provider.of<TaskProvider>(context, listen: false);
                  taskProvider.addTask(Task(
                    title: _titleController.text,
                    description: _descriptionController.text,
                    dueDate: _selectedDate!,
                    importance: _selectedImportance,
                  ));
                  Navigator.pop(context);
                }
              },
              child: const Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}
