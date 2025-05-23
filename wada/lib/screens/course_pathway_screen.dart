// lib/screens/course_pathway_screen.dart
import 'package:flutter/material.dart';
import 'dart:math' as math; // Keep dart:math for animations

import 'package:wada/models/course_pathway.dart'; // Import models
import 'package:wada/data/app_data.dart'; // Import your data
import 'package:wada/widgets/pathway_background_painter.dart'; // Import the custom painter

class CoursePathwayScreen extends StatefulWidget {
  final CoursePathway pathway;
  const CoursePathwayScreen({
    super.key,
    required this.pathway,
  });

  @override
  State<CoursePathwayScreen> createState() => _CoursePathwayScreenState();
}

class _CoursePathwayScreenState extends State<CoursePathwayScreen> with TickerProviderStateMixin {
  // Correction: Removed 'extends CoursePathwayScreenState' and added 'with TickerProviderStateMixin'
  // for animation controllers

  late AnimationController _pathController;
  late AnimationController _pulseController;
  late AnimationController _sparkleController;
  late Animation<double> _pathAnimation;
  late Animation<double> _pulseAnimation;
  late ScrollController _scrollController;
  bool _showFloatingInfo = false;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _initScrollController();
  }

  void _initAnimations() {
    _pathController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _pathAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pathController, curve: Curves.easeInOut),
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _sparkleController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _pathController.forward();
    _pulseController.repeat(reverse: true);
    _sparkleController.repeat();
  }

  void _initScrollController() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      setState(() {
        _showFloatingInfo = _scrollController.offset > 100;
      });
    });
  }

  @override
  void dispose() {
    _pathController.dispose();
    _pulseController.dispose();
    _sparkleController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  List<LearningModule> get _modules {
    // Dynamically get modules from the app_data.dart based on the pathway ID
    return allPathwayModules[widget.pathway.id] ?? [];
  }

  IconData _getModuleIcon(LearningModule module) {
    if (module.isAssessment) return Icons.verified_outlined;
    if (module.isChallenge) return Icons.emoji_events_outlined;
    switch (module.type) {
      case 'video':
        return Icons.play_circle_outline;
      case 'article':
        return Icons.article_outlined;
      case 'quiz':
        return Icons.quiz_outlined;
      case 'project':
        return Icons.build_outlined;
      case 'challenge':
        return Icons.emoji_events_outlined; // Redundant but harmless
      default:
        return Icons.school_outlined;
    }
  }

  Color _getModuleColor(LearningModule module) {
    if (module.isCompleted) return const Color(0xFF00FF88); // Green for completed
    if (module.isCurrent) return module.accentColor; // Use its own accent color if current
    if (module.isLocked) return const Color(0xFF64748B); // Grey for locked
    return module.accentColor; // Default to module's accent color
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark().copyWith(
        primaryColor: widget.pathway.accentColor,
        scaffoldBackgroundColor: const Color(0xFF0F0F23),
        textTheme: const TextTheme( // Define text styles for consistency
          headlineSmall: TextStyle(
            fontFamily: 'Orbitron',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          titleMedium: TextStyle(
            fontFamily: 'Orbitron',
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Roboto',
            color: Colors.white70,
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        body: Stack(
          children: [
            _buildBackgroundPattern(),
            CustomScrollView(
              controller: _scrollController,
              slivers: [
                _buildAppBar(),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      _buildPathwayHeader(),
                      const SizedBox(height: 20),
                      _buildProgressStats(),
                      const SizedBox(height: 30),
                      _buildLearningPath(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
            if (_showFloatingInfo) _buildFloatingPathwayInfo(),
          ],
        ),
        floatingActionButton: _buildContinueButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat, // Keep FAB centered
      ),
    );
  }

  Widget _buildBackgroundPattern() {
    return Positioned.fill(
      child: CustomPaint(
        painter: PathwayBackgroundPainter(
            animation: _sparkleController,
            accentColor: widget.pathway.accentColor),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 60,
      floating: false,
      pinned: true,
      backgroundColor: const Color(0xFF0F0F23).withOpacity(0.95),
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xFF1A1A2E),
          border: Border.all(
            color: widget.pathway.accentColor.withOpacity(0.3),
          ),
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: const Color(0xFF1A1A2E),
            border: Border.all(
              color: widget.pathway.accentColor.withOpacity(0.3),
            ),
          ),
          child: IconButton(
            icon: const Icon(Icons.bookmark_outline, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("Parcours ajouté aux favoris"),
                  backgroundColor: widget.pathway.accentColor,
                ),
              );
            },
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF0F0F23),
                const Color(0xFF0F0F23).withOpacity(0.8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPathwayHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    colors: [
                      widget.pathway.accentColor,
                      widget.pathway.accentColor.withOpacity(0.7),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.pathway.accentColor.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  widget.pathway.icon,
                  color: Colors.white,
                  size: 36,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.pathway.title,
                      style: const TextStyle(
                        fontFamily: 'Orbitron',
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1D29),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.pathway.description,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        color: Colors.white70,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [
                  widget.pathway.accentColor.withOpacity(0.2),
                  widget.pathway.accentColor.withOpacity(0.1),
                ],
              ),
              border: Border.all(
                color: widget.pathway.accentColor.withOpacity(0.3),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround, // Distribute evenly
              children: [
                _buildHeaderStat('Niveau', widget.pathway.difficulty),
                _buildHeaderStat('Modules', '${widget.pathway.totalModules}'),
                _buildHeaderStat('XP Total', '${_modules.fold(0, (sum, m) => sum + m.xp)}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Orbitron',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: widget.pathway.accentColor,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 12,
            color: Color(0xFF1A1D29),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressStats() {
    final completedModules = _modules.where((m) => m.isCompleted).length;
    final totalXP = _modules.where((m) => m.isCompleted).fold(0, (sum, m) => sum + m.xp);

    // Calculate overall time for completed modules
    final totalCompletedTimeInMinutes = _modules
        .where((m) => m.isCompleted)
        .map((m) => m.estimatedTime.inMinutes)
        .fold(0, (sum, minutes) => sum + minutes);

    final averageTime = completedModules > 0
        ? Duration(minutes: totalCompletedTimeInMinutes ~/ completedModules)
        : Duration.zero;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
        ),
        border: Border.all(
          color: widget.pathway.accentColor.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Votre progression',
                style: TextStyle(
                  fontFamily: 'Orbitron',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                '${(widget.pathway.userProgress * 100).toInt()}%',
                style: TextStyle(
                  fontFamily: 'Orbitron',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: widget.pathway.accentColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
              AnimatedBuilder(
                animation: _pathAnimation,
                builder: (context, child) {
                  return Container(
                    height: 8,
                    width: (MediaQuery.of(context).size.width - 88) *
                        widget.pathway.userProgress *
                        _pathAnimation.value,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      gradient: LinearGradient(
                        colors: [
                          widget.pathway.accentColor,
                          widget.pathway.accentColor.withOpacity(0.7),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildProgressStat(
                Icons.check_circle_outline,
                '$completedModules/${_modules.length}',
                'Modules',
                const Color(0xFF00FF88),
              ),
              _buildProgressStat(
                Icons.flash_on_outlined,
                '$totalXP',
                'XP gagné',
                const Color(0xFFFFB800),
              ),
              _buildProgressStat(
                Icons.schedule_outlined,
                '${averageTime.inMinutes}min',
                'Temps moy.',
                const Color(0xFF00D4FF),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressStat(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: color.withOpacity(0.2),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Orbitron',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 11,
            color: Colors.white60,
          ),
        ),
      ],
    );
  }

  Widget _buildLearningPath() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Parcours d\'apprentissage',
            style: TextStyle(
              fontFamily: 'Orbitron',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1D29),
            ),
          ),
          const SizedBox(height: 20),
          ..._modules.asMap().entries.map((entry) {
            final index = entry.key;
            final module = entry.value;
            final isLast = index == _modules.length - 1;
            return _buildModuleCard(module, index, isLast);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildModuleCard(LearningModule module, int index, bool isLast) {
    final moduleColor = _getModuleColor(module);
    final isEven = index % 2 == 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Stack(
        children: [
          // Path line
          if (!isLast)
            Positioned(
              left: isEven ? 80 : null, // Position for even/odd cards
              right: isEven ? null : 80,
              top: 60, // Adjust top to align with the middle of the icon
              child: AnimatedBuilder(
                animation: _pathAnimation,
                builder: (context, child) {
                  // Only draw if the module is completed or current (for the connecting line)
                  if (index < _modules.indexOf(_modules.firstWhere((m) => m.isCurrent, orElse: () => _modules.last))) {
                    return Container(
                      width: 3,
                      height: 120, // Length of the connecting line
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            widget.pathway.accentColor,
                            widget.pathway.accentColor.withOpacity(0.3),
                          ],
                        ),
                      ),
                    );
                  } else if (module.isCurrent) {
                     return Container(
                      width: 3,
                      height: 120 * _pathAnimation.value, // Animate current line
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            widget.pathway.accentColor,
                            widget.pathway.accentColor.withOpacity(0.3),
                          ],
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          // Module card
          Row(
            children: [
              if (isEven) ...[
                Expanded(flex: 3, child: _buildModuleContent(module)),
                const SizedBox(width: 20), // Spacing between card and icon
                _buildModuleIcon(module, moduleColor),
              ] else ...[
                _buildModuleIcon(module, moduleColor),
                const SizedBox(width: 20), // Spacing between icon and card
                Expanded(flex: 3, child: _buildModuleContent(module)),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModuleIcon(LearningModule module, Color moduleColor) {
    return AnimatedBuilder(
      animation: module.isCurrent ? _pulseController : _pathController,
      builder: (context, child) {
        return Transform.scale(
          scale: module.isCurrent ? (0.95 + _pulseAnimation.value * 0.05) : 1.0, // More subtle pulse
          child: GestureDetector(
            onTap: module.isLocked ? null : () => _openModule(module),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: module.isLocked
                    ? LinearGradient(
                        colors: [
                          const Color(0xFF374151),
                          const Color(0xFF374151).withOpacity(0.8),
                        ],
                      )
                    : LinearGradient(
                        colors: [
                          moduleColor,
                          moduleColor.withOpacity(0.8),
                        ],
                      ),
                border: Border.all(
                  color: module.isCurrent
                      ? moduleColor.withOpacity(0.7) // Stronger border for current
                      : moduleColor.withOpacity(0.3),
                  width: module.isCurrent ? 3 : 1,
                ),
                boxShadow: [
                  if (module.isCurrent || module.isCompleted)
                    BoxShadow(
                      color: moduleColor.withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    _getModuleIcon(module),
                    color: module.isLocked ? Colors.white38 : Colors.white,
                    size: 28,
                  ),
                  if (module.isLocked)
                    Positioned(
                      bottom: 2,
                      right: 2,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFF374151),
                          border: Border.all(color: Colors.white38),
                        ),
                        child: const Icon(
                          Icons.lock,
                          color: Colors.white38,
                          size: 12,
                        ),
                      ),
                    ),
                  if (module.isCompleted)
                    Positioned(
                      bottom: -2,
                      right: -2,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00FF88), Color(0xFF00CC6A)],
                          ),
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildModuleContent(LearningModule module) {
    return GestureDetector(
      onTap: module.isLocked ? null : () => _openModule(module),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: module.isLocked
              ? const LinearGradient(
                  colors: [Color(0xFF1F2937), Color(0xFF111827)],
                )
              : const LinearGradient(
                  colors: [
                    Color(0xFF1A1A2E),
                    Color(0xFF16213E),
                  ],
                ),
          border: Border.all(
            color: module.isCurrent
                ? _getModuleColor(module).withOpacity(0.7)
                : _getModuleColor(module).withOpacity(0.2),
            width: module.isCurrent ? 2 : 1,
          ),
          boxShadow: [
            if (!module.isLocked)
              BoxShadow(
                color: _getModuleColor(module).withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    module.title,
                    style: TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: module.isLocked ? Colors.white38 : Colors.white,
                    ),
                  ),
                ),
                if (!module.isLocked)
                  Row(
                    children: [
                      const Icon(
                        Icons.flash_on,
                        color: Color(0xFFFFB800),
                        size: 16,
                      ),
                      Text(
                        '${module.xp}',
                        style: const TextStyle(
                          fontFamily: 'Orbitron',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFFB800),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              module.description,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                color: module.isLocked ? Colors.white24 : Colors.white70,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: _getModuleColor(module).withOpacity(0.2),
                    border: Border.all(
                      color: _getModuleColor(module).withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    module.type.toUpperCase(),
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color:
                          module.isLocked ? Colors.white38 : _getModuleColor(module),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      color: module.isLocked ? Colors.white24 : Colors.white60,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatDuration(module.estimatedTime),
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 12,
                        color: module.isLocked ? Colors.white24 : Colors.white60,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      Icons.circle,
                      size: 8,
                      color: index < module.difficulty
                          ? _getModuleColor(module)
                          : Colors.white.withOpacity(0.2),
                    );
                  }),
                ),
              ],
            ),
            if (module.skills.isNotEmpty && !module.isLocked) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: module.skills.map((skill) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _getModuleColor(module).withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      skill,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 10,
                        color: _getModuleColor(module),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
            if (module.progress != null && module.progress! > 0) ...[
              const SizedBox(height: 12),
              Stack(
                children: [
                  Container(
                    height: 6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                  Container(
                    height: 6,
                    width:
                        (MediaQuery.of(context).size.width - 140) * (module.progress ?? 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      gradient: LinearGradient(
                        colors: [
                          _getModuleColor(module),
                          _getModuleColor(module).withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingPathwayInfo() {
  return Positioned(
    top: 100,
    left: 20,
    right: 20,
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1A1A2E).withOpacity(0.95),
            const Color(0xFF16213E).withOpacity(0.95),
          ],
        ),
        border: Border.all(
          color: widget.pathway.accentColor.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [
                  widget.pathway.accentColor,
                  widget.pathway.accentColor.withOpacity(0.7),
                ],
              ),
            ),
            child: Icon(
              widget.pathway.icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.pathway.title,
                  style: const TextStyle(
                    fontFamily: 'Orbitron',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${(widget.pathway.userProgress * 100).toInt()}% complété',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 12,
                    color: widget.pathway.accentColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: widget.pathway.accentColor.withOpacity(0.2),
              border: Border.all(
                color: widget.pathway.accentColor.withOpacity(0.3),
              ),
            ),
            child: Text(
              'Continuer',
              style: TextStyle(
                fontFamily: 'Orbitron',
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: widget.pathway.accentColor,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildContinueButton() {
  // Find the first non-completed module to continue
  final currentModule = _modules.firstWhere(
    (module) => module.isCurrent,
    orElse: () => _modules.first,
  );

  return AnimatedBuilder(
    animation: _pulseAnimation,
    builder: (context, child) {
      return Transform.scale(
        scale: 0.95 + _pulseAnimation.value * 0.05, // Subtle pulse effect
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: ElevatedButton(
            onPressed: currentModule.isLocked ? null : () => _openModule(currentModule),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8,
            ),
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: currentModule.isLocked
                    ? LinearGradient(
                        colors: [
                          Colors.grey.withOpacity(0.5),
                          Colors.grey.withOpacity(0.3),
                        ],
                      )
                    : LinearGradient(
                        colors: [
                          widget.pathway.accentColor,
                          widget.pathway.accentColor.withOpacity(0.8),
                        ],
                      ),
              ),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      currentModule.isLocked
                          ? Icons.lock_outline
                          : Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      currentModule.isLocked
                          ? 'Module verrouillé'
                          : 'Continuer l\'apprentissage',
                      style: const TextStyle(
                        fontFamily: 'Orbitron',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

void _openModule(LearningModule module) {
  // Show details of the module or navigate to the module content
  Navigator.of(context).push(
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        // This would be replaced with the actual module content screen
        return Scaffold(
          appBar: AppBar(
            title: Text(module.title),
            backgroundColor: const Color(0xFF0F0F23),
            elevation: 0,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getModuleIcon(module),
                  size: 80,
                  color: module.accentColor,
                ),
                const SizedBox(height: 24),
                Text(
                  'Module: ${module.title}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    module.description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: module.accentColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Retour au parcours',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: const Color(0xFF0F0F23),
        );
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutQuart;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      },
    ),
  );
}

String _formatDuration(Duration duration) {
  if (duration.inHours > 0) {
    return '${duration.inHours}h ${duration.inMinutes.remainder(60)}min';
  } else {
    return '${duration.inMinutes}min';
  }
}
}