
// lib/screens/learning_screen.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:wada/models/course_pathway.dart'; // Import models
import 'package:wada/data/app_data.dart'; // Import your data
import 'package:wada/screens/course_pathway_screen.dart'; // Import the destination screen

class LearningScreen extends StatefulWidget {
  const LearningScreen({super.key});

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _glowController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _glowAnimation;

  String _selectedFilter = 'all';
  final List<String> _filters = [
    'all',
    'in_progress',
    'completed',
    'recommended'
  ];

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOut),
    );

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _slideController.forward();
    _glowController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _slideController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  List<CoursePathway> get _filteredPathways {
    switch (_selectedFilter) {
      case 'in_progress':
        return userPathways
            .where((p) => p.userProgress > 0 && p.userProgress < 1)
            .toList();
      case 'completed':
        return userPathways.where((p) => p.userProgress >= 1).toList();
      case 'recommended':
         // Assuming 'recommended' pathways are those not started
        return userPathways.where((p) => p.userProgress == 0).toList();
      default:
        return userPathways;
    }
  }

  String _getFilterLabel(String filter) {
    switch (filter) {
      case 'in_progress':
        return 'En cours';
      case 'completed':
        return 'Terminé';
      case 'recommended':
        return 'Recommandé';
      default:
        return 'Tous';
    }
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Beginner':
        return const Color(0xFF00FF88);
      case 'Intermediate':
        return const Color(0xFFFFB800);
      case 'Advanced':
        return const Color(0xFFFF3366);
      default:
        return const Color(0xFF00D4FF);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _buildLearningTheme(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        body: CustomScrollView(
          slivers: [
            _buildFuturisticAppBar(),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 20),
                  _buildProgressOverview(),
                  const SizedBox(height: 30),
                  _buildFilterTabs(),
                  const SizedBox(height: 20),
                  _buildPathwaysList(),
                  const SizedBox(height: 100),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ThemeData _buildLearningTheme() {
    return ThemeData.light().copyWith(
      primaryColor: const Color(0xFF0066FF),
      scaffoldBackgroundColor: const Color(0xFFF5F7FA),
      cardColor: const Color(0xFFFFFFFF),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(
          fontFamily: 'Orbitron',
          fontWeight: FontWeight.bold,
          color: Color(0xFF1A1D29),
        ),
        titleMedium: TextStyle(
          fontFamily: 'Orbitron',
          fontWeight: FontWeight.w600,
          color: Color(0xFF1A1D29),
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Roboto',
          color: Color(0xFF4A5568),
        ),
      ),
    );
  }

  Widget _buildFuturisticAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: const Color(0xFFF5F7FA),
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFF5F7FA),
                Color(0xFFE2E8F0),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Neural Learning',
                          style: TextStyle(
                            fontFamily: 'Orbitron',
                            fontSize: 16,
                            color: Color(0xFF0066FF),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Pathways',
                          style: TextStyle(
                            fontFamily: 'Orbitron',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1D29),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Removed search and settings buttons if they are part of a parent navigation
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressOverview() {
    // Calculate these based on _filteredPathways from allPathwayModules
    final totalPathwayModules = _filteredPathways.fold(0, (sum, p) => sum + (allPathwayModules[p.id]?.length ?? 0));
    final completedPathwayModules = _filteredPathways.fold(0, (sum, p) {
      final modules = allPathwayModules[p.id];
      if (modules != null) {
        return sum + modules.where((m) => m.isCompleted).length;
      }
      return sum;
    });

    final overallProgress = totalPathwayModules > 0
        ? completedPathwayModules / totalPathwayModules
        : 0.0;

    final inProgressPathwaysCount = _filteredPathways.where((p) => p.userProgress > 0 && p.userProgress < 1).length;
    final completedPathwaysCount = _filteredPathways.where((p) => p.userProgress >= 1).length;


    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0066FF).withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.dashboard_outlined,
                  color: Color(0xFF00D4FF),
                  size: 24,
                ),
                SizedBox(width: 12),
                Text(
                  "Learning Dashboard",
                  style: TextStyle(
                    fontFamily: 'Orbitron',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    "Progression",
                    "${(overallProgress * 100).toInt()}%",
                    const Color(0xFF00D4FF),
                    Icons.trending_up_outlined,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    "Terminés",
                    "$completedPathwaysCount/${_filteredPathways.length}",
                    const Color(0xFF00FF88),
                    Icons.check_circle_outline,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    "En cours",
                    "$inProgressPathwaysCount",
                    const Color(0xFFFFB800),
                    Icons.play_circle_outline,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
        color: color.withOpacity(0.1),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Orbitron',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = _selectedFilter == filter;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.only(right: 16),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(25),
                onTap: () {
                  setState(() {
                    _selectedFilter = filter;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    gradient: isSelected
                        ? const LinearGradient(
                            colors: [Color(0xFF0066FF), Color(0xFF00D4FF)],
                          )
                        : null,
                    color: isSelected ? null : const Color(0xFFFFFFFF),
                    border: Border.all(
                      color: isSelected ? Colors.transparent : const Color(0xFFE2E8F0),
                      width: 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: const Color(0xFF0066FF).withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                  ),
                  child: Text(
                    _getFilterLabel(filter),
                    style: TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : const Color(0xFF1A1D29),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPathwaysList() {
    final pathways = _filteredPathways;
    if (pathways.isEmpty) {
      return _buildEmptyState();
    }
    return Column(
      children: pathways.map((pathway) => _buildPathwayCard(pathway)).toList(),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(
            Icons.school_outlined,
            size: 64,
            color: const Color(0xFF64748B).withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            "Aucun parcours trouvé",
            style: TextStyle(
              fontFamily: 'Orbitron',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF64748B).withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Essayez un autre filtre",
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              color: const Color(0xFF64748B).withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPathwayCard(CoursePathway pathway) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                pathway.backgroundColor,
                pathway.backgroundColor.withOpacity(0.8),
              ],
            ),
            border: Border.all(
              color: pathway.accentColor.withOpacity(0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: pathway.accentColor.withOpacity(_glowAnimation.value * 0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () {
                // Navigate to the CoursePathwayScreen, passing the selected pathway
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CoursePathwayScreen(pathway: pathway),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            gradient: LinearGradient(
                              colors: [
                                pathway.accentColor,
                                pathway.accentColor.withOpacity(0.7),
                              ],
                            ),
                          ),
                          child: Icon(
                            pathway.icon,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pathway.title,
                                style: const TextStyle(
                                  fontFamily: 'Orbitron',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: _getDifficultyColor(pathway.difficulty),
                                ),
                                child: Text(
                                  pathway.difficulty,
                                  style: const TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          "${(pathway.userProgress * 100).toInt()}%",
                          style: TextStyle(
                            fontFamily: 'Orbitron',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: pathway.accentColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      pathway.description,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        color: Colors.white70,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Stack(
                      children: [
                        Container(
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                        Container(
                          height: 8,
                          width: (MediaQuery.of(context).size.width - 88) * pathway.userProgress,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            gradient: LinearGradient(
                              colors: [
                                pathway.accentColor,
                                pathway.accentColor.withOpacity(0.7),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.play_lesson_outlined,
                              color: pathway.accentColor,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "${pathway.completedModules}/${pathway.totalModules} modules",
                              style: const TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 12,
                                color: Colors.white60,
                              ),
                            ),
                          ],
                        ),
                        if (pathway.skills.isNotEmpty)
                          Expanded( // Use Expanded to prevent overflow in Wrap
                            child: Wrap(
                              alignment: WrapAlignment.end,
                              spacing: 4,
                              children: pathway.skills.take(3).map((skill) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: pathway.accentColor.withOpacity(0.5),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    skill,
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 9,
                                      color: pathway.accentColor,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}