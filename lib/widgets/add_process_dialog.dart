import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/process.dart';
import '../providers/process_provider.dart';
import '../models/material.dart';

class AddProcessDialog extends StatefulWidget {
  const AddProcessDialog({super.key});

  @override
  State<AddProcessDialog> createState() => _AddProcessDialogState();
}

class _AddProcessDialogState extends State<AddProcessDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _operatorNameController = TextEditingController();
  final List<ProcessStep> _steps = [];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _operatorNameController.dispose();
    super.dispose();
  }

  void _addStep() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Step'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Step Name'),
              onChanged: (value) {},
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Description'),
              onChanged: (value) {},
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Estimated Duration (minutes)'),
              keyboardType: TextInputType.number,
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _steps.add(
                  ProcessStep(
                    id: 'step_${_steps.length + 1}',
                    name: 'Step ${_steps.length + 1}',
                    description: 'Description',
                    estimatedDuration: 30,
                    requiredMaterials: [],
                  ),
                );
              });
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _saveProcess() {
    if (_formKey.currentState!.validate()) {
      final process = Process(
        id: 'process_${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text,
        description: _descriptionController.text,
        steps: _steps,
        startDate: DateTime.now(),
        assignedOperatorId: 'operator_${DateTime.now().millisecondsSinceEpoch}',
        assignedOperatorName: _operatorNameController.text,
      );

      context.read<ProcessProvider>().addProcess(process);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Process'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Process Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _operatorNameController,
                decoration: const InputDecoration(labelText: 'Assigned Operator'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an operator name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text('Steps:'),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _steps.length,
                itemBuilder: (context, index) {
                  final step = _steps[index];
                  return ListTile(
                    title: Text(step.name),
                    subtitle: Text(step.description),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          _steps.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
              TextButton.icon(
                onPressed: _addStep,
                icon: const Icon(Icons.add),
                label: const Text('Add Step'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _saveProcess,
          child: const Text('Save'),
        ),
      ],
    );
  }
} 