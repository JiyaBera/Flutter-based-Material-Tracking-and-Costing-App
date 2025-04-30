import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/process.dart';
import '../providers/process_provider.dart';
import '../models/material.dart';
import '../widgets/add_process_dialog.dart';

class ProcessesScreen extends StatelessWidget {
  const ProcessesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProcessProvider>(
      builder: (context, processProvider, child) {
        final processes = processProvider.activeProcesses;
        final templates = processProvider.processTemplates;

        return ListView(
          children: [
            // Active Processes Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Active Processes',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            if (processes.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text('No active processes'),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: processes.length,
                itemBuilder: (context, index) {
                  final process = processes[index];
                  return _ProcessCard(process: process);
                },
              ),

            const Divider(height: 32),

            // Process Templates Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Process Templates',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            if (templates.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text('No process templates'),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: templates.length,
                itemBuilder: (context, index) {
                  final template = templates[index];
                  return _ProcessTemplateCard(template: template);
                },
              ),
          ],
        );
      },
    );
  }

  void _showAddProcessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddProcessDialog(),
    );
  }
}

class _ProcessCard extends StatelessWidget {
  final Process process;

  const _ProcessCard({required this.process});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(process.name),
            subtitle: Text(process.description),
            trailing: _ProcessStatusChip(status: process.status),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Assigned to: ${process.assignedOperatorName}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: process.progress,
                  backgroundColor: Colors.grey[200],
                ),
                const SizedBox(height: 8),
                Text(
                  'Progress: ${(process.progress * 100).toStringAsFixed(0)}%',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const Divider(),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: process.steps.length,
            itemBuilder: (context, index) {
              final step = process.steps[index];
              return CheckboxListTile(
                title: Text(step.name),
                subtitle: Text(step.description),
                value: step.isCompleted,
                onChanged: (value) {
                  if (value != null) {
                    context.read<ProcessProvider>().updateStepStatus(
                          process.id,
                          step.id,
                          value,
                        );
                  }
                },
              );
            },
          ),
          ButtonBar(
            children: [
              TextButton.icon(
                onPressed: () => _showProcessDetails(context),
                icon: const Icon(Icons.visibility),
                label: const Text('View Details'),
              ),
              TextButton.icon(
                onPressed: () => _updateProcessStatus(context),
                icon: const Icon(Icons.edit),
                label: const Text('Update Status'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showProcessDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(process.name),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Description: ${process.description}'),
              const SizedBox(height: 8),
              Text('Start Date: ${process.startDate.toString()}'),
              if (process.endDate != null)
                Text('End Date: ${process.endDate.toString()}'),
              const SizedBox(height: 8),
              Text('Assigned Operator: ${process.assignedOperatorName}'),
              const SizedBox(height: 16),
              const Text('Steps:'),
              ...process.steps.map((step) => ListTile(
                    title: Text(step.name),
                    subtitle: Text(step.description),
                    trailing: Text('${step.estimatedDuration} min'),
                  )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _updateProcessStatus(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Process Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ProcessStatus.values.map((status) {
            return ListTile(
              title: Text(status.toString().split('.').last),
              onTap: () {
                context.read<ProcessProvider>().updateProcessStatus(
                      process.id,
                      status,
                    );
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _ProcessTemplateCard extends StatelessWidget {
  final Process template;

  const _ProcessTemplateCard({required this.template});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(template.name),
            subtitle: Text(template.description),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                context.read<ProcessProvider>().deleteProcessTemplate(template.id);
              },
            ),
          ),
          const Divider(),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: template.steps.length,
            itemBuilder: (context, index) {
              final step = template.steps[index];
              return ListTile(
                title: Text(step.name),
                subtitle: Text(step.description),
                trailing: Text('${step.estimatedDuration} min'),
              );
            },
          ),
          ButtonBar(
            children: [
              TextButton.icon(
                onPressed: () => _createProcessFromTemplate(context),
                icon: const Icon(Icons.add),
                label: const Text('Create Process'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _createProcessFromTemplate(BuildContext context) {
    final newProcess = template.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      startDate: DateTime.now(),
    );
    context.read<ProcessProvider>().addProcess(newProcess);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Process created from template: ${template.name}'),
      ),
    );
  }
}

class _ProcessStatusChip extends StatelessWidget {
  final ProcessStatus status;

  const _ProcessStatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;

    switch (status) {
      case ProcessStatus.active:
        color = Colors.green;
        label = 'Active';
        break;
      case ProcessStatus.paused:
        color = Colors.orange;
        label = 'Paused';
        break;
      case ProcessStatus.completed:
        color = Colors.blue;
        label = 'Completed';
        break;
      case ProcessStatus.cancelled:
        color = Colors.red;
        label = 'Cancelled';
        break;
    }

    return Chip(
      label: Text(
        label,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: color,
    );
  }
} 