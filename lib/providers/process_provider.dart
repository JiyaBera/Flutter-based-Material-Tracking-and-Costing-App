import 'package:flutter/foundation.dart';
import '../models/process.dart';
import '../models/material.dart';

class ProcessProvider with ChangeNotifier {
  final List<Process> _processes = [];
  final List<Process> _processTemplates = [];

  List<Process> get processes => _processes;
  List<Process> get processTemplates => _processTemplates;
  List<Process> get activeProcesses => _processes.where((p) => p.isActive).toList();
  List<Process> get completedProcesses => _processes.where((p) => p.isCompleted).toList();

  // Add some sample processes for demonstration
  ProcessProvider() {
    _initializeSampleData();
  }

  void _initializeSampleData() {
    // Sample process templates
    final weldingTemplate = Process(
      id: 'template_1',
      name: 'Standard Welding Process',
      description: 'Standard process for welding metal components',
      steps: [
        ProcessStep(
          id: 'step_1',
          name: 'Material Preparation',
          description: 'Clean and prepare metal surfaces',
          estimatedDuration: 30,
          requiredMaterials: [],
        ),
        ProcessStep(
          id: 'step_2',
          name: 'Welding',
          description: 'Perform welding operation',
          estimatedDuration: 60,
          requiredMaterials: [],
        ),
        ProcessStep(
          id: 'step_3',
          name: 'Quality Check',
          description: 'Inspect weld quality',
          estimatedDuration: 20,
          requiredMaterials: [],
        ),
      ],
      startDate: DateTime.now(),
      assignedOperatorId: 'operator_1',
      assignedOperatorName: 'John Doe',
    );

    final assemblyTemplate = Process(
      id: 'template_2',
      name: 'Component Assembly',
      description: 'Standard process for assembling components',
      steps: [
        ProcessStep(
          id: 'step_1',
          name: 'Parts Inspection',
          description: 'Inspect all parts for defects',
          estimatedDuration: 20,
          requiredMaterials: [],
        ),
        ProcessStep(
          id: 'step_2',
          name: 'Assembly',
          description: 'Assemble components according to specifications',
          estimatedDuration: 45,
          requiredMaterials: [],
        ),
        ProcessStep(
          id: 'step_3',
          name: 'Testing',
          description: 'Test assembled components',
          estimatedDuration: 30,
          requiredMaterials: [],
        ),
      ],
      startDate: DateTime.now(),
      assignedOperatorId: 'operator_1',
      assignedOperatorName: 'John Doe',
    );

    final paintingTemplate = Process(
      id: 'template_3',
      name: 'Surface Painting',
      description: 'Standard process for surface painting',
      steps: [
        ProcessStep(
          id: 'step_1',
          name: 'Surface Preparation',
          description: 'Clean and prepare surface for painting',
          estimatedDuration: 25,
          requiredMaterials: [],
        ),
        ProcessStep(
          id: 'step_2',
          name: 'Primer Application',
          description: 'Apply primer coat',
          estimatedDuration: 30,
          requiredMaterials: [],
        ),
        ProcessStep(
          id: 'step_3',
          name: 'Paint Application',
          description: 'Apply final paint coat',
          estimatedDuration: 40,
          requiredMaterials: [],
        ),
        ProcessStep(
          id: 'step_4',
          name: 'Quality Inspection',
          description: 'Inspect paint quality and finish',
          estimatedDuration: 20,
          requiredMaterials: [],
        ),
      ],
      startDate: DateTime.now(),
      assignedOperatorId: 'operator_1',
      assignedOperatorName: 'John Doe',
    );

    _processTemplates.addAll([weldingTemplate, assemblyTemplate, paintingTemplate]);

    // Sample active processes
    final activeProcess1 = Process(
      id: 'process_1',
      name: 'Frame Assembly',
      description: 'Assembly of main frame structure',
      steps: [
        ProcessStep(
          id: 'step_1',
          name: 'Component Alignment',
          description: 'Align frame components',
          estimatedDuration: 45,
          requiredMaterials: [],
          isCompleted: true,
        ),
        ProcessStep(
          id: 'step_2',
          name: 'Welding',
          description: 'Weld frame components',
          estimatedDuration: 120,
          requiredMaterials: [],
        ),
        ProcessStep(
          id: 'step_3',
          name: 'Quality Inspection',
          description: 'Inspect weld quality and alignment',
          estimatedDuration: 30,
          requiredMaterials: [],
        ),
      ],
      startDate: DateTime.now().subtract(const Duration(days: 1)),
      assignedOperatorId: 'operator_2',
      assignedOperatorName: 'Jane Smith',
    );

    final activeProcess2 = Process(
      id: 'process_2',
      name: 'Engine Block Painting',
      description: 'Painting of engine block components',
      steps: [
        ProcessStep(
          id: 'step_1',
          name: 'Surface Cleaning',
          description: 'Clean engine block surface',
          estimatedDuration: 30,
          requiredMaterials: [],
          isCompleted: true,
        ),
        ProcessStep(
          id: 'step_2',
          name: 'Primer Application',
          description: 'Apply heat-resistant primer',
          estimatedDuration: 45,
          requiredMaterials: [],
          isCompleted: true,
        ),
        ProcessStep(
          id: 'step_3',
          name: 'Paint Application',
          description: 'Apply final paint coat',
          estimatedDuration: 60,
          requiredMaterials: [],
        ),
      ],
      startDate: DateTime.now().subtract(const Duration(hours: 4)),
      assignedOperatorId: 'operator_3',
      assignedOperatorName: 'Mike Johnson',
    );

    final activeProcess3 = Process(
      id: 'process_3',
      name: 'Gearbox Assembly',
      description: 'Assembly of transmission gearbox',
      steps: [
        ProcessStep(
          id: 'step_1',
          name: 'Parts Verification',
          description: 'Verify all gearbox components',
          estimatedDuration: 20,
          requiredMaterials: [],
          isCompleted: true,
        ),
        ProcessStep(
          id: 'step_2',
          name: 'Gear Assembly',
          description: 'Assemble gear components',
          estimatedDuration: 90,
          requiredMaterials: [],
        ),
        ProcessStep(
          id: 'step_3',
          name: 'Lubrication',
          description: 'Apply lubricant to moving parts',
          estimatedDuration: 30,
          requiredMaterials: [],
        ),
        ProcessStep(
          id: 'step_4',
          name: 'Final Testing',
          description: 'Test gearbox operation',
          estimatedDuration: 45,
          requiredMaterials: [],
        ),
      ],
      startDate: DateTime.now().subtract(const Duration(hours: 2)),
      assignedOperatorId: 'operator_4',
      assignedOperatorName: 'Sarah Williams',
    );

    _processes.addAll([activeProcess1, activeProcess2, activeProcess3]);
  }

  void addProcess(Process process) {
    _processes.add(process);
    notifyListeners();
  }

  void updateProcess(Process process) {
    final index = _processes.indexWhere((p) => p.id == process.id);
    if (index != -1) {
      _processes[index] = process;
      notifyListeners();
    }
  }

  void deleteProcess(String processId) {
    _processes.removeWhere((p) => p.id == processId);
    notifyListeners();
  }

  void updateProcessStatus(String processId, ProcessStatus status) {
    final index = _processes.indexWhere((p) => p.id == processId);
    if (index != -1) {
      final process = _processes[index];
      _processes[index] = process.copyWith(
        status: status,
        endDate: status == ProcessStatus.completed ? DateTime.now() : null,
      );
      notifyListeners();
    }
  }

  void updateStepStatus(String processId, String stepId, bool isCompleted) {
    final processIndex = _processes.indexWhere((p) => p.id == processId);
    if (processIndex != -1) {
      final process = _processes[processIndex];
      final steps = process.steps.map((step) {
        if (step.id == stepId) {
          return step.copyWith(isCompleted: isCompleted);
        }
        return step;
      }).toList();

      _processes[processIndex] = process.copyWith(steps: steps);
      notifyListeners();
    }
  }

  void addProcessTemplate(Process template) {
    _processTemplates.add(template);
    notifyListeners();
  }

  void deleteProcessTemplate(String templateId) {
    _processTemplates.removeWhere((t) => t.id == templateId);
    notifyListeners();
  }
} 