
import 'package:flutter/material.dart';

// Represents a single step/module within a project pathway
class ProjectModule {
  final String id;
  final String title;
  final String description;
  final String deliverableTemplate; // Template for the deliverable
  final bool isCompleted;
  final bool isLocked;
  final Duration estimatedTime;
  final List<String> skillsCovered;
  final IconData icon; // Icon for the module type

  ProjectModule({
    required this.id,
    required this.title,
    required this.description,
    required this.deliverableTemplate,
    this.isCompleted = false,
    this.isLocked = false,
    required this.estimatedTime,
    this.skillsCovered = const [],
    this.icon = Icons.lightbulb_outline_rounded,
  });

  ProjectModule copyWith({
    bool? isCompleted,
    bool? isLocked,
  }) {
    return ProjectModule(
      id: id,
      title: title,
      description: description,
      deliverableTemplate: deliverableTemplate,
      isCompleted: isCompleted ?? this.isCompleted,
      isLocked: isLocked ?? this.isLocked,
      estimatedTime: estimatedTime,
      skillsCovered: skillsCovered,
      icon: icon,
    );
  }
}

// Represents an entire user project
class UserProject {
  final String id;
  final String title;
  final String description;
  final double progress; // 0.0 to 1.0
  final List<ProjectModule> modules;
  final List<String> teamMembers; // User IDs of team members
  final String? generatedDeliverable; // The final generated deliverable

  UserProject({
    required this.id,
    required this.title,
    required this.description,
    this.progress = 0.0,
    this.modules = const [],
    this.teamMembers = const [],
    this.generatedDeliverable,
  });

  UserProject copyWith({
    double? progress,
    List<ProjectModule>? modules,
    List<String>? teamMembers,
    String? generatedDeliverable,
  }) {
    return UserProject(
      id: id,
      title: title,
      description: description,
      progress: progress ?? this.progress,
      modules: modules ?? this.modules,
      teamMembers: teamMembers ?? this.teamMembers,
      generatedDeliverable: generatedDeliverable ?? this.generatedDeliverable,
    );
  }
}