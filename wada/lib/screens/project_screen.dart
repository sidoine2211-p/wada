// lib/screens/project_screen.dart
import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:wada/data/app_data.dart';
import 'package:wada/models/project.dart';
import 'package:wada/widgets/assistant_sheet.dart'; // Import the AI assistant sheet

import 'package:wada/screens/the_wada_invest_screen.dart'; // Import the new screen

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({super.key});

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> with TickerProviderStateMixin {
  late AnimationController _pathController;
  late Animation<double> _pathAnimation;
  late ScrollController _scrollController;

  UserProject? _currentProject; // Assuming a single
  bool _showFloatingInfo = false;

  @override
  void initState() {
    super.initState();
    _pathController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _pathAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pathController, curve: Curves.easeOutCubic),
    );

    _scrollController = ScrollController();
    _scrollController.addListener(_updateFloatingInfoVisibility);

    // For simplicity, we'll just pick the first project in the list for now.
    // In a real app, this would be based on user selection/state.
    _currentProject = userProjects.firstWhere(
      (proj) => proj.id == 'mon_app_fitness', // Or fetch active project
      orElse: () => userProjects.first, // Fallback if no specific project found
    );

    // Start animation if project is loaded
    if (_currentProject != null) {
      _pathController.forward();
    }
  }

  @override
  void dispose() {
    _pathController.dispose();
    _scrollController.removeListener(_updateFloatingInfoVisibility);
    _scrollController.dispose();
    super.dispose();
  }

  void _updateFloatingInfoVisibility() {
    setState(() {
      _showFloatingInfo = _scrollController.offset > 200; // Adjust threshold
    });
  }

  Color _getModuleColor(ProjectModule module) {
    if (module.isCompleted) {
      return const Color(0xFF00FF88); // Green for completed (aligned with LearningScreen's completed color)
    } else if (_currentProject?.modules.indexOf(module) ==
        _currentProject?.modules.indexWhere((m) => !m.isCompleted && !m.isLocked)) {
      // This is the current active module if not completed and not locked
      return const Color(0xFF00D4FF); // Vibrant blue for current (aligned with LearningScreen's primary accent)
    } else if (module.isLocked) {
      return const Color(0xFF64748B); // Grey for Locked (aligned with LearningScreen's grey/inactive)
    }
    return const Color(0xFF4A5568); // Default blue-grey for incomplete (aligned with LearningScreen's body text color)
  }

  void _openProjectModule(ProjectModule module) {
    // Logic to navigate to a detailed module screen
    // For now, let's show a bottom sheet or a simple snackbar
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildModuleBottomSheet(module),
    );
  }

  Widget _buildModuleBottomSheet(ProjectModule module) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.white.withOpacity(0.9),
            ],
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -10),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 60,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Icon(module.icon, color: _getModuleColor(module), size: 30),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    module.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Orbitron',
                      color: _getModuleColor(module),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Color(0xFF64748B)),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              module.description,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF475569), // Aligned with LearningScreen body text
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 24),
            _buildModuleDetail(Icons.access_time_rounded,
                '${module.estimatedTime.inHours}h ${module.estimatedTime.inMinutes.remainder(60)}min',
                'Temps estimé', Color(0xFF00D4FF)), // Changed to LearningScreen accent color
            const SizedBox(height: 8),
            _buildModuleDetail(Icons.auto_stories_rounded,
                module.deliverableTemplate, 'Livrable du module', Color(0xFF0066FF)), // Changed to LearningScreen primary color
            const SizedBox(height: 8),
            _buildSkillsSection(module.skillsCovered),
            const SizedBox(height: 32),
            if (!module.isLocked)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context); // Close bottom sheet
                    if (module.id == _currentProject?.modules.last.id &&
                        _currentProject?.modules.every((m) => m.isCompleted) == true) {
                      // Navigate to The Wada Invest screen if it's the last module and all are completed
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TheWadaInvestScreen(
                            project: _currentProject!,
                          ),
                        ),
                      );
                    } else {
                      // Simulate module completion and deliverable generation
                      setState(() {
                        final moduleIndex = _currentProject!.modules.indexOf(module);
                        if (moduleIndex != -1) {
                          _currentProject!.modules[moduleIndex] =
                              module.copyWith(isCompleted: true);
                          // Unlock next module if exists
                          if (moduleIndex + 1 < _currentProject!.modules.length) {
                            _currentProject!.modules[moduleIndex + 1] =
                                _currentProject!.modules[moduleIndex + 1]
                                    .copyWith(isLocked: false);
                          }
                          // Update project progress
                          _currentProject = _currentProject!.copyWith(
                            progress: _currentProject!.modules
                                    .where((m) => m.isCompleted)
                                    .length /
                                _currentProject!.modules.length,
                          );
                        }
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(module.isCompleted
                            ? 'Module "${module.title}" mis à jour.'
                            : 'Module "${module.title}" démarré !'),
                        backgroundColor: _getModuleColor(module),
                      ));

                      // Prompt for AI review/challenge after completing a module
                      _promptAIRecapAndChallenge(module);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getModuleColor(module),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 8,
                  ),
                  icon: Icon(module.isCompleted
                      ? Icons.check_circle_rounded
                      : Icons.play_arrow_rounded),
                  label: Text(
                    module.isCompleted ? 'Revoir le module' : 'Démarrer le module',
                    style: const TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            else
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.lock_rounded,
                        color: Color(0xFF64748B), size: 24),
                    const SizedBox(width: 8),
                    Text(
                      'Module Verrouillé',
                      style: TextStyle(
                        color: const Color(0xFF64748B),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Orbitron',
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildModuleDetail(
      IconData icon, String value, String label, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF64748B), // Aligned with LearningScreen
                  fontFamily: 'Roboto',
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1D29), // Aligned with LearningScreen headlines
                  fontFamily: 'Roboto',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSkillsSection(List<String> skills) {
    if (skills.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Compétences acquises :',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF64748B), // Aligned with LearningScreen
            fontFamily: 'Roboto',
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: skills.map((skill) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFE0F2F7), // Light blue background (kept as it aligns well)
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF00D4FF).withOpacity(0.5)), // Aligned with LearningScreen accent
              ),
              child: Text(
                skill,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF0066FF), // Dark blue text (changed to LearningScreen primary blue)
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _promptAIRecapAndChallenge(ProjectModule module) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AssistantSheet(
        initialPrompt:
            "J'ai terminé le module '${module.title}' de mon projet. Le livrable attendu était : '${module.deliverableTemplate}'. Peux-tu analyser mes résultats et me challenger pour améliorer mon travail ?",
        title: "Assistant Projet",
      ),
    );
  }

  Future<void> _inviteTeamMember() async {
    // Simulate inviting a member
    final TextEditingController emailController = TextEditingController(); // Renamed to avoid confusion with class-level _emailController if any

    await showDialog(
      context: context,
      builder: (context) {
        // Use StatefulBuilder to manage the lifecycle of the TextEditingController
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Inviter un membre'),
              content: TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: 'Email du membre',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    emailController.dispose(); // Dispose controller on cancel
                    Navigator.pop(context);
                  },
                  child: const Text('Annuler'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (emailController.text.isNotEmpty) {
                      // Update the state of the parent widget (ProjectScreen)
                      // This setState is for the _ProjectScreenState
                      this.setState(() {
                        _currentProject!.teamMembers.add(emailController.text);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${emailController.text} a été invité au projet !'),
                        ),
                      );
                      emailController.dispose(); // Dispose controller on invite success
                      Navigator.pop(context); // Close the dialog
                    } else {
                      // Provide feedback for empty input
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Veuillez entrer une adresse email.'),
                          backgroundColor: Colors.red, // Indicate an error
                        ),
                      );
                    }
                  },
                  child: const Text('Inviter'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_currentProject == null) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00D4FF)), // Aligned with LearningScreen accent
        ),
      );
    }
    // Determine the current active module for the "Continue" button
    final currentActiveModule =
        _currentProject!.modules.firstWhereOrNull(
      (m) => !m.isCompleted && !m.isLocked,
    );
    final allModulesCompleted =
        _currentProject!.modules.every((m) => m.isCompleted);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Set a consistent background color from LearningScreen
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildAppBar(),
          _buildProjectHeader(),
          _buildProgressStats(),
          _buildCollaborationSection(),
          _buildProjectTimeline(),
          SliverToBoxAdapter(
            child: SizedBox(
                height: MediaQuery.of(context).padding.bottom + 100), // Spacer for FAB
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_showFloatingInfo) _buildFloatingProjectInfo(),
          const SizedBox(height: 16),
          _buildContinueButton(currentActiveModule, allModulesCompleted),
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      backgroundColor: const Color(0xFFF5F7FA), // Aligned with LearningScreen app bar background
      elevation: 0,
      expandedHeight: 0, // No expanded height
      floating: true, // App bar floats over content
      pinned: true, // App bar stays at the top
      title: const Text(
        'Mon Projet',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: 'Orbitron',
          color: Color(0xFF1A1D29), // Aligned with LearningScreen headlines
        ),
      ),
      centerTitle: false,
    );
  }

  Widget _buildProjectHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF0066FF).withOpacity(0.1), // Changed to LearningScreen primary color
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF0066FF).withOpacity(0.3)), // Changed to LearningScreen primary color
              ),
              child: const Icon(
                Icons.emoji_objects_rounded, // Project icon
                color: Color(0xFF0066FF), // Changed to LearningScreen primary color
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _currentProject!.title,
              style: const TextStyle(
                fontFamily: 'Orbitron',
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1D29), // Aligned with LearningScreen headlines
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _currentProject!.description,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
                color: Color(0xFF4A5568), // Aligned with LearningScreen body text
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressStats() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Progression du Projet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1D29), // Aligned with LearningScreen headlines
                fontFamily: 'Orbitron',
              ),
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: _currentProject!.progress,
              backgroundColor: const Color(0xFFE2E8F0), // Aligned with LearningScreen neutral tones
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00D4FF)), // Aligned with LearningScreen accent
              minHeight: 10,
              borderRadius: BorderRadius.circular(8),
            ),
            const SizedBox(height: 8),
            Text(
              '${(_currentProject!.progress * 100).toInt()}% Complété',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF4A5568), // Aligned with LearningScreen body text
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCollaborationSection() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Équipe de Projet',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1D29), // Aligned with LearningScreen headlines
                    fontFamily: 'Orbitron',
                  ),
                ),
                TextButton.icon(
                  onPressed: _inviteTeamMember,
                  icon: const Icon(Icons.person_add_alt_1_rounded,
                      color: Color(0xFF0066FF)), // Changed to LearningScreen primary color
                  label: const Text(
                    'Inviter',
                    style: TextStyle(
                      color: Color(0xFF0066FF), // Changed to LearningScreen primary color
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_currentProject!.teamMembers.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Aucun membre invité. Invitez des collaborateurs pour travailler ensemble !',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontFamily: 'Roboto',
                  ),
                ),
              )
            else
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _currentProject!.teamMembers.length,
                  itemBuilder: (context, index) {
                    final member = _currentProject!.teamMembers[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Chip(
                        label: Text(member),
                        avatar: const CircleAvatar(
                          backgroundColor: Color(0xFF00D4FF), // Aligned with LearningScreen accent
                          child: Icon(Icons.person, color: Colors.white, size: 18),
                        ),
                        backgroundColor: const Color(0xFFE0F7FA), // Kept, aligns well
                        labelStyle: const TextStyle(
                            color: Color(0xFF0066FF), fontSize: 13), // Changed to LearningScreen primary color
                        side: const BorderSide(color: Color(0xFF00D4FF), width: 1), // Aligned with LearningScreen accent
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectTimeline() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final module = _currentProject!.modules[index];
            final isLast = index == _currentProject!.modules.length - 1;
            final isFirst = index == 0;
            final isEven = index % 2 == 0; // For alternating layout
            return AnimatedBuilder(
              animation: _pathAnimation,
              builder: (context, child) {
                // Staggered animation for each module
                final animationProgress = math.min(
                    1.0, _pathAnimation.value * (1.0 / _currentProject!.modules.length) * (index + 1));
                return Opacity(
                  opacity: animationProgress,
                  child: Transform.translate(
                    offset: Offset(0, 50 * (1 - animationProgress)),
                    child: _buildModuleCard(module, isLast, isFirst, isEven),
                  ),
                );
              },
            );
          },
          childCount: _currentProject!.modules.length,
        ),
      ),
    );
  }

  Widget _buildModuleCard(
      ProjectModule module, bool isLast, bool isFirst, bool isEven) {
    final moduleColor = _getModuleColor(module);
    final isActive = !module.isCompleted && !module.isLocked;
    return GestureDetector(
      onTap: () => _openProjectModule(module),
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        child: IntrinsicHeight(
          // Ensure children take full height for consistent line drawing
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left side (pathway line and icon)
              SizedBox(
                width: 80, // Consistent width for the path
                child: Column(
                  children: [
                    if (!isFirst)
                      Expanded(
                        child: Container(
                          width: 3,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                moduleColor.withOpacity(0.4),
                                moduleColor.withOpacity(0.8),
                              ],
                            ),
                          ),
                        ),
                      ),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          colors: [moduleColor, moduleColor.withOpacity(0.7)],
                        ),
                        boxShadow: isActive
                            ? [
                                BoxShadow(
                                  color: moduleColor.withOpacity(0.5),
                                  blurRadius: 10,
                                  spreadRadius: 3,
                                ),
                              ]
                            : null,
                      ),
                      child: Icon(module.icon, color: Colors.white, size: 28),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 3,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                moduleColor.withOpacity(0.8),
                                _getModuleColor(_currentProject!.modules[
                                        _currentProject!.modules.indexOf(module) + 1])
                                    .withOpacity(0.4),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Right side (module content)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1D29), // Changed card background to 0xFF1A1D29 as requested
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: moduleColor.withOpacity(0.3),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        module.title,
                        style: TextStyle(
                          fontFamily: 'Orbitron',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Changed text color to white for readability on dark background
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        module.description,
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          color: Colors.white70, // Changed text color to white70 for readability on dark background
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildInfoChip(
                              Icons.access_time_rounded,
                              '${module.estimatedTime.inMinutes}min',
                              moduleColor, // Keep accent color for chip's text/icon
                              isDarkBackground: true), // Indicate dark background for chip's text
                          _buildInfoChip(
                              Icons.auto_stories_rounded,
                              module.deliverableTemplate.split(' ').first, // Show first word of deliverable
                              moduleColor, // Keep accent color for chip's text/icon
                              isDarkBackground: true), // Indicate dark background for chip's text
                          if (module.isCompleted)
                            _buildInfoChip(Icons.check_circle_rounded,
                                'Terminé', const Color(0xFF00FF88), // Keep green for completed
                                isDarkBackground: true), // Indicate dark background for chip's text
                          if (module.isLocked)
                            _buildInfoChip(Icons.lock_rounded, 'Verrouillé',
                                const Color(0xFF64748B), // Keep grey for locked
                                isDarkBackground: true), // Indicate dark background for chip's text
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color, {bool isDarkBackground = false}) {
    // Adjust text color based on the background.
    // If the chip itself is on a dark background (like the new card), its text should be light.
    // However, the chip's background itself is a lighter version of 'color'.
    final textColor = isDarkBackground ? Colors.white : color; // The text *within* the chip will be light
    final chipBackgroundColor = isDarkBackground ? color.withOpacity(0.3) : color.withOpacity(0.1); // Make chip background slightly more opaque if card is dark
    final chipBorderColor = isDarkBackground ? color.withOpacity(0.6) : color.withOpacity(0.3);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: chipBackgroundColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: chipBorderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textColor, size: 16), // Icon color also adapted
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: textColor, // Text color adapted
              fontWeight: FontWeight.w500,
              fontFamily: 'Roboto',
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildFloatingProjectInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0066FF).withOpacity(0.95), // Dark blue with slight opacity (aligned with LearningScreen primary)
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.emoji_objects_rounded, color: Colors.white, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _currentProject!.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Orbitron',
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${(_currentProject!.progress * 100).toInt()}%',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00D4FF), // Accent color (aligned with LearningScreen accent)
              fontFamily: 'Orbitron',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton(
      ProjectModule? currentActiveModule, bool allModulesCompleted) {
    return FloatingActionButton.extended(
      onPressed: () {
        if (allModulesCompleted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  TheWadaInvestScreen(project: _currentProject!),
            ),
          );
        } else if (currentActiveModule != null) {
          _openProjectModule(currentActiveModule);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    "Tous les modules sont complétés ou verrouillés. Passez à l'étape The Wada Invest !"),
                backgroundColor: Color(0xFF0066FF)), // Changed to LearningScreen primary color
          );
        }
      },
      label: Text(
        allModulesCompleted ? 'Voir mon Pitch Invest' : 'Continuer le Projet',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontFamily: 'Orbitron',
        ),
      ),
      icon: Icon(
        allModulesCompleted
            ? Icons.emoji_events_rounded
            : Icons.arrow_forward_ios_rounded,
        color: Colors.white,
      ),
      backgroundColor: const Color(0xFF00D4FF), // Aligned with LearningScreen accent
      foregroundColor: Colors.white,
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
    );
  }
}

// Extension to easily find first where or null
extension ListExtension<T> on List<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }
}