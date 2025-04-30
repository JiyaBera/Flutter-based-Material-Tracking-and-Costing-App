import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../theme/app_theme.dart';
import 'create_task_screen.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog(context);
            },
          ),
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          final tasks = taskProvider.tasks;
          
          if (tasks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.task_alt,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No tasks found',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return _TaskCard(task: task);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateTaskScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Consumer<TaskProvider>(
          builder: (context, taskProvider, child) {
            return AlertDialog(
              title: const Text('Filter Tasks'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<String>(
                    title: const Text('All Tasks'),
                    value: 'all',
                    groupValue: taskProvider.filter,
                    onChanged: (value) {
                      taskProvider.setFilter(value!);
                      Navigator.pop(context);
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Pending'),
                    value: 'pending',
                    groupValue: taskProvider.filter,
                    onChanged: (value) {
                      taskProvider.setFilter(value!);
                      Navigator.pop(context);
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Completed'),
                    value: 'completed',
                    groupValue: taskProvider.filter,
                    onChanged: (value) {
                      taskProvider.setFilter(value!);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _TaskCard extends StatelessWidget {
  final Task task;

  const _TaskCard({required this.task});

  Color _getPriorityColor() {
    switch (task.priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    final isOverdue = task.dueDate.isBefore(DateTime.now()) && task.status != 'completed';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          // TODO: Show task details
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _PriorityChip(
                    priority: task.priority,
                    color: _getPriorityColor(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                task.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: isOverdue ? Colors.red : Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    dateFormat.format(task.dueDate),
                    style: TextStyle(
                      color: isOverdue ? Colors.red : Colors.grey[600],
                      fontWeight: isOverdue ? FontWeight.bold : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.person,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    task.assignedTo,
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _StatusChip(status: task.status),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          task.status == 'completed'
                              ? Icons.check_circle
                              : Icons.check_circle_outline,
                          color: task.status == 'completed'
                              ? AppTheme.successColor
                              : Colors.grey,
                        ),
                        onPressed: () {
                          context.read<TaskProvider>().toggleTaskStatus(task.id);
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: AppTheme.errorColor,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Task'),
                              content: const Text(
                                'Are you sure you want to delete this task?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    context
                                        .read<TaskProvider>()
                                        .deleteTask(task.id);
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    'Delete',
                                    style: TextStyle(color: AppTheme.errorColor),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PriorityChip extends StatelessWidget {
  final String priority;
  final Color color;

  const _PriorityChip({
    required this.priority,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        priority,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = status == 'completed'
        ? AppTheme.successColor
        : AppTheme.primaryColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
} 