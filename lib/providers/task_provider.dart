import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  final List<Task> _tasks = [];
  String _filter = 'all'; // all, pending, completed

  List<Task> get tasks {
    switch (_filter) {
      case 'pending':
        return _tasks.where((task) => task.status == 'pending').toList();
      case 'completed':
        return _tasks.where((task) => task.status == 'completed').toList();
      default:
        return _tasks;
    }
  }

  String get filter => _filter;

  void setFilter(String filter) {
    _filter = filter;
    notifyListeners();
  }

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void updateTask(Task task) {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  void toggleTaskStatus(String id) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      final task = _tasks[index];
      final updatedTask = task.copyWith(
        status: task.status == 'completed' ? 'pending' : 'completed',
        completedAt: task.status == 'completed' ? null : DateTime.now(),
      );
      _tasks[index] = updatedTask;
      notifyListeners();
    }
  }
} 