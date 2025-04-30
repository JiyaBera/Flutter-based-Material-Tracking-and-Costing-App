import 'package:flutter/material.dart';
import 'material.dart';

enum ProcessStatus {
  active,
  paused,
  completed,
  cancelled
}

class ProcessStep {
  final String id;
  final String name;
  final String description;
  final int estimatedDuration; // in minutes
  final List<MaterialItem> requiredMaterials;
  bool isCompleted;

  ProcessStep({
    required this.id,
    required this.name,
    required this.description,
    required this.estimatedDuration,
    required this.requiredMaterials,
    this.isCompleted = false,
  });

  ProcessStep copyWith({
    String? id,
    String? name,
    String? description,
    int? estimatedDuration,
    List<MaterialItem>? requiredMaterials,
    bool? isCompleted,
  }) {
    return ProcessStep(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      requiredMaterials: requiredMaterials ?? this.requiredMaterials,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class Process {
  final String id;
  final String name;
  final String description;
  final List<ProcessStep> steps;
  final DateTime startDate;
  final DateTime? endDate;
  ProcessStatus status;
  final String assignedOperatorId;
  final String assignedOperatorName;

  Process({
    required this.id,
    required this.name,
    required this.description,
    required this.steps,
    required this.startDate,
    this.endDate,
    this.status = ProcessStatus.active,
    required this.assignedOperatorId,
    required this.assignedOperatorName,
  });

  bool get isCompleted => status == ProcessStatus.completed;
  bool get isActive => status == ProcessStatus.active;
  bool get isPaused => status == ProcessStatus.paused;
  bool get isCancelled => status == ProcessStatus.cancelled;

  double get progress {
    if (steps.isEmpty) return 0;
    final completedSteps = steps.where((step) => step.isCompleted).length;
    return completedSteps / steps.length;
  }

  Process copyWith({
    String? id,
    String? name,
    String? description,
    List<ProcessStep>? steps,
    DateTime? startDate,
    DateTime? endDate,
    ProcessStatus? status,
    String? assignedOperatorId,
    String? assignedOperatorName,
  }) {
    return Process(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      steps: steps ?? this.steps,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      assignedOperatorId: assignedOperatorId ?? this.assignedOperatorId,
      assignedOperatorName: assignedOperatorName ?? this.assignedOperatorName,
    );
  }
} 