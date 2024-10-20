class SubTask {
  String title;
  bool isCompleted;

  SubTask({required this.title, this.isCompleted = false});

  // Convert SubTask to JSON for saving
  Map<String, dynamic> toJson() => {
    'title': title,
    'isCompleted': isCompleted,
  };

  // Create SubTask from JSON
  static SubTask fromJson(Map<String, dynamic> json) => SubTask(
    title: json['title'],
    isCompleted: json['isCompleted'],
  );
}

class Task {
  String title;
  String description;
  DateTime dueDate;
  bool isCompleted;
  String importance;  // Add importance as a String
  List<SubTask> subTasks;

  Task({
    required this.title,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
    this.importance = 'Normal',  // Default importance
    List<SubTask>? subTasks,
  }) : subTasks = subTasks ?? [];

  // JSON serialization/deserialization
  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'dueDate': dueDate.toIso8601String(),
    'isCompleted': isCompleted,
    'importance': importance,
    'subTasks': subTasks.map((subTask) => subTask.toJson()).toList(),
  };

  static Task fromJson(Map<String, dynamic> json) => Task(
    title: json['title'],
    description: json['description'],
    dueDate: DateTime.parse(json['dueDate']),
    isCompleted: json['isCompleted'],
    importance: json['importance'] ?? 'Normal',  // Handle importance
    subTasks: (json['subTasks'] as List)
        .map((subTaskJson) => SubTask.fromJson(subTaskJson))
        .toList(),
  );
}
