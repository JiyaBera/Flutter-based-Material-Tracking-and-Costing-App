import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../theme/app_theme.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _dueDate = DateTime.now().add(const Duration(days: 1));
  String _priority = 'Medium';
  String _assignedTo = 'John Doe'; // This would come from a user list in a real app

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final task = Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        description: _descriptionController.text,
        dueDate: _dueDate,
        assignedTo: _assignedTo,
        status: 'pending',
        priority: _priority,
        createdAt: DateTime.now(),
      );

      context.read<TaskProvider>().addTask(task);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Task'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Task Title',
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Due Date',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    '${_dueDate.day}/${_dueDate.month}/${_dueDate.year}',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _priority,
                decoration: const InputDecoration(
                  labelText: 'Priority',
                  prefixIcon: Icon(Icons.priority_high),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Low',
                    child: Text('Low'),
                  ),
                  DropdownMenuItem(
                    value: 'Medium',
                    child: Text('Medium'),
                  ),
                  DropdownMenuItem(
                    value: 'High',
                    child: Text('High'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _priority = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _assignedTo,
                decoration: const InputDecoration(
                  labelText: 'Assign To',
                  prefixIcon: Icon(Icons.person),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'John Doe',
                    child: Text('John Doe'),
                  ),
                  DropdownMenuItem(
                    value: 'Jane Smith',
                    child: Text('Jane Smith'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _assignedTo = value!;
                  });
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _handleSubmit,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'Create Task',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 