class Task {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final String assignedTo;
  final String status;
  final String priority;
  final DateTime createdAt;
  final DateTime? completedAt;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.assignedTo,
    required this.status,
    required this.priority,
    required this.createdAt,
    this.completedAt,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    String? assignedTo,
    String? status,
    String? priority,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      assignedTo: assignedTo ?? this.assignedTo,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
} 