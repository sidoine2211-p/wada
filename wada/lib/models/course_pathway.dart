
// lib/models/course_pathway.dart
import 'package:flutter/material.dart';

class CoursePathway {
  final String id;
  final String title;
  final String description;
  final double userProgress; // 0.0 to 1.0
  final Color backgroundColor;
  final Color accentColor;
  final int totalModules;
  final int completedModules;
  final String difficulty;
  final List<String> skills;
  final IconData icon;

  CoursePathway({
    required this.id,
    required this.title,
    required this.description,
    required this.userProgress,
    required this.backgroundColor,
    required this.accentColor,
    this.totalModules = 0,
    this.completedModules = 0,
    this.difficulty = 'Beginner',
    this.skills = const [],
    this.icon = Icons.school_outlined,
  });
}

class LearningModule {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final bool isLocked;
  final bool isCurrent;
  final Duration estimatedTime;
  final String type; // video, article, quiz, project, assessment
  final double? progress;
  final int difficulty; // 1-5
  final List<String> skills;
  final Color accentColor; // Accent color inherited or defined for the module
  final int xp;
  final bool isChallenge;
  final bool isAssessment;

  LearningModule({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    this.isLocked = false,
    this.isCurrent = false,
    required this.estimatedTime,
    this.type = 'article',
    this.progress,
    this.difficulty = 1,
    this.skills = const [],
    required this.accentColor, // Now required to pass accent color for consistency
    this.xp = 10,
    this.isChallenge = false,
    this.isAssessment = false,
  });
}