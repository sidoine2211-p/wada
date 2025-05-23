
import 'package:flutter/material.dart';
import 'dart:math' as math;

// --- MODÈLES DE DONNÉES FICTIFS ---
class UserProfile {
  final String name;
  final String avatarUrl;
  final String level;
  final double globalProgress;
  final int streakDays;
  final int totalPoints;

  UserProfile({
    required this.name,
    required this.avatarUrl,
    required this.level,
    required this.globalProgress,
    this.streakDays = 0,
    this.totalPoints = 0,
  });
}

class CoursePreview {
  final String id;
  final String title;
  final String category;
  final String iconAsset;
  final Color backgroundColor;
  final Color accentColor;
  final double userProgress;
  final int lessonsCompleted;
  final int totalLessons;
  final String difficulty;

  CoursePreview({
    required this.id,
    required this.title,
    required this.category,
    required this.iconAsset,
    required this.backgroundColor,
    required this.accentColor,
    required this.userProgress,
    this.lessonsCompleted = 0,
    this.totalLessons = 0,
    this.difficulty = 'Beginner',
  });
}

class ProjectPreview {
  final String id;
  final String name;
  final String nextStep;
  final double progress;
  final String status;
  final DateTime deadline;
  final List<String> tags;

  ProjectPreview({
    required this.id,
    required this.name,
    required this.nextStep,
    required this.progress,
    this.status = 'Active',
    required this.deadline,
    this.tags = const [],
  });
}

class InspirationTip {
  final String id;
  final String quote;
  final String author;
  final String category;

  InspirationTip({
    required this.id,
    required this.quote,
    required this.author,
    this.category = 'Motivation',
  });
}

// --- ÉCRAN D'ACCUEIL FUTURISTE ---
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _FuturisticHomeScreenState();
}

class _FuturisticHomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _slideController;
  late AnimationController _glowController;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _glowAnimation;

  // Données fictives améliorées
  final UserProfile _userProfile = UserProfile(
    name: "Alexandre",
    avatarUrl: "assets/images/default_avatar.png",
    level: "Quantum Silver",
    globalProgress: 0.78,
    streakDays: 17,
    totalPoints: 2540,
  );

  final List<CoursePreview> _userCourses = [
    CoursePreview(
      id: '1',
      title: "AI-Powered Validation",
      category: "Innovation",
      iconAsset: "assets/icons/ai_brain.svg",
      backgroundColor: const Color(0xFF1A1A2E),
      accentColor: const Color(0xFF00D4FF),
      userProgress: 0.85,
      lessonsCompleted: 17,
      totalLessons: 20,
      difficulty: "Advanced",
    ),
    CoursePreview(
      id: '2',
      title: "Neural Business Model",
      category: "Strategy",
      iconAsset: "assets/icons/neural_network.svg",
      backgroundColor: const Color(0xFF16213E),
      accentColor: const Color(0xFF7B2CBF),
      userProgress: 0.60,
      lessonsCompleted: 12,
      totalLessons: 18,
      difficulty: "Expert",
    ),
    CoursePreview(
      id: '3',
      title: "Quantum Marketing",
      category: "Growth",
      iconAsset: "assets/icons/quantum.svg",
      backgroundColor: const Color(0xFF0F3460),
      accentColor: const Color(0xFF00F5FF),
      userProgress: 0.35,
      lessonsCompleted: 7,
      totalLessons: 15,
      difficulty: "Intermediate",
    ),
  ];

  final ProjectPreview _userProject = ProjectPreview(
    id: 'proj1',
    name: "Project Wada Nexus",
    nextStep: "Deploy quantum prototype alpha",
    progress: 0.73,
    status: "Critical",
    deadline: DateTime.now().add(const Duration(days: 14)),
    tags: ["AI", "Blockchain", "IoT"],
  );

  final InspirationTip _dailyTip = InspirationTip(
    id: 'tip1',
    quote:
        "The future belongs to those who understand that technology is not just a tool, but an extension of human potential.",
    author: "Digital Visionary",
    category: "Innovation",
  );

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.elasticOut),
    );

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _pulseController.repeat(reverse: true);
    _slideController.forward();
    _glowController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _slideController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 6) return 'Good night';
    if (hour < 12) return 'Good morning';
    if (hour < 18) return 'Good afternoon';
    if (hour < 22) return 'Good evening';
    return 'Good night';
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _buildFuturisticTheme(),
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
                  _buildQuantumProgressCard(),
                  const SizedBox(height: 30),
                  _buildSectionHeader(
                    "Neural Pathways",
                    "Continue Your Journey",
                  ),
                  const SizedBox(height: 16),
                  _buildQuantumCoursesCarousel(),
                  const SizedBox(height: 30),
                  _buildSectionHeader("Active Mission", "Your Current Project"),
                  const SizedBox(height: 16),
                  _buildHolographicProjectCard(),
                  const SizedBox(height: 30),
                  _buildSectionHeader(
                    "Daily Inspiration",
                    "Fuel Your Innovation",
                  ),
                  const SizedBox(height: 16),
                  _buildInspirationHologram(),
                  const SizedBox(height: 30),
                  _buildSectionHeader("Quick Access", "Instant Navigation"),
                  const SizedBox(height: 16),
                  _buildQuantumQuickAccess(),
                  const SizedBox(height: 100),
                ]),
              ),
            ),
          ],
        ),
        floatingActionButton: _buildQuantumFAB(),
      ),
    );
  }

  ThemeData _buildFuturisticTheme() {
    return ThemeData.light().copyWith(
      // Changé de .dark() à .light()
      primaryColor: const Color(0xFF0066FF),
      scaffoldBackgroundColor: const Color(
        0xFFF5F7FA,
      ), // Background principal éclairé
      cardColor: const Color(0xFFFFFFFF), // Cards blanches
      textTheme: const TextTheme(
        headlineSmall: TextStyle(
          fontFamily: 'Orbitron',
          fontWeight: FontWeight.bold,
          color: Color(0xFF1A1D29), // Texte sombre sur fond clair
        ),
        titleMedium: TextStyle(
          fontFamily: 'Orbitron',
          fontWeight: FontWeight.w600,
          color: Color(0xFF1A1D29),
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Roboto',
          color: Color(0xFF4A5568), // Texte secondaire gris
        ),
      ),
    );
  }

  Widget _buildFuturisticAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: const Color(0xFFF5F7FA), // Background éclairé
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFFF5F7FA),
                const Color(0xFFE2E8F0), // Gradient subtil
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _slideAnimation,
                        builder: (context, child) {
                          return SlideTransition(
                            position: _slideAnimation,
                            child: Text(
                              '${_getGreeting()},',
                              style: const TextStyle(
                                fontFamily: 'Orbitron',
                                fontSize: 16,
                                color: Color(0xFF0066FF), // Bleu principal
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 4),
                      AnimatedBuilder(
                        animation: _slideAnimation,
                        builder: (context, child) {
                          return SlideTransition(
                            position: _slideAnimation,
                            child: Text(
                              _userProfile.name,
                              style: const TextStyle(
                                fontFamily: 'Orbitron',
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A1D29), // Texte sombre
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _buildQuantumNotificationBell(),
                      const SizedBox(width: 16),
                      _buildHolographicAvatar(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuantumNotificationBell() {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(
                  0xFF00D4FF,
                ).withOpacity(_glowAnimation.value * 0.3),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Material(
            color: const Color(0xFFFFFFFF), // Background blanc
            borderRadius: BorderRadius.circular(12),
            elevation: 4, // Ajout d'une ombre subtile
            child: InkWell(
              // ... reste du code
              child: Container(
                padding: const EdgeInsets.all(12),
                child: const Icon(
                  Icons.notifications_none_rounded,
                  color: Color(0xFF0066FF), // Icône bleue
                  size: 24,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHolographicAvatar() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF0066FF), Color(0xFF00B4D8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0066FF).withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 1,
                ),
              ],
            ),
            padding: const EdgeInsets.all(3),
            child: CircleAvatar(
              radius: 22,
              backgroundColor: const Color(0xFFFFFFFF), // Background blanc
              child: Text(
                _userProfile.name.isNotEmpty
                    ? _userProfile.name[0].toUpperCase()
                    : 'U',
                style: const TextStyle(
                  fontFamily: 'Orbitron',
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0066FF), // Texte bleu
                  fontSize: 18,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuantumProgressCard() {
    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
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
                  color: const Color(0xFF00D4FF).withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Quantum Progress",
                      style: TextStyle(
                        fontFamily: 'Orbitron',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF00D4FF),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        _userProfile.level,
                        style: const TextStyle(
                          fontFamily: 'Orbitron',
                          fontSize: 12,
                          color: Color(0xFF00D4FF),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Stack(
                  children: [
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    Container(
                      height: 8,
                      width:
                          MediaQuery.of(context).size.width *
                          0.85 *
                          _userProfile.globalProgress,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00D4FF), Color(0xFF7B2CBF)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00D4FF).withOpacity(0.5),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatItem(
                      "Progress",
                      "${(_userProfile.globalProgress * 100).toInt()}%",
                    ),
                    _buildStatItem("Streak", "${_userProfile.streakDays} days"),
                    _buildStatItem("Points", "${_userProfile.totalPoints}"),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.analytics_outlined, size: 20),
                        label: const Text("Analytics"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00D4FF),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Accessing quantum analytics..."),
                              backgroundColor: Color(0xFF00D4FF),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      child: const Icon(Icons.share_outlined),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: const Color(0xFF00D4FF),
                        side: const BorderSide(color: Color(0xFF00D4FF)),
                        padding: const EdgeInsets.all(12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Orbitron',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF00D4FF),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 12,
            color: Colors.white.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(
          fontFamily: 'Orbitron',
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1A1D29), // Titre en gris très foncé/noir
        ),
      ),
      const SizedBox(height: 4),
      Text(
        subtitle,
        style: const TextStyle(
          fontFamily: 'Roboto',
          fontSize: 14,
          color: Color(0xFF64748B), // Sous-titre en gris moyen
        ),
      ),
    ],
  );
}

  Widget _buildQuantumCoursesCarousel() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _userCourses.length,
        itemBuilder: (context, index) {
          final course = _userCourses[index];
          return _buildQuantumCourseCard(course, index);
        },
      ),
    );
  }

  Widget _buildQuantumCourseCard(CoursePreview course, int index) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          width: 160,
          margin: const EdgeInsets.only(right: 16),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Loading ${course.title}..."),
                    backgroundColor: course.accentColor,
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      course.backgroundColor,
                      course.backgroundColor.withOpacity(0.8),
                    ],
                  ),
                  border: Border.all(
                    color: course.accentColor.withOpacity(0.3),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: course.accentColor.withOpacity(
                        _glowAnimation.value * 0.2,
                      ),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: [
                            course.accentColor,
                            course.accentColor.withOpacity(0.6),
                          ],
                        ),
                      ),
                      child: Icon(
                        _getCourseIcon(course.category),
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      course.title,
                      style: const TextStyle(
                        fontFamily: 'Orbitron',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      course.category,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 11,
                        color: course.accentColor,
                      ),
                    ),
                    const Spacer(),
                    Stack(
                      children: [
                        Container(
                          height: 4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                        Container(
                          height: 4,
                          width: 128 * course.userProgress,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            gradient: LinearGradient(
                              colors: [
                                course.accentColor,
                                course.accentColor.withOpacity(0.6),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${(course.userProgress * 100).toInt()}%",
                          style: TextStyle(
                            fontFamily: 'Orbitron',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: course.accentColor,
                          ),
                        ),
                        Text(
                          "${course.lessonsCompleted}/${course.totalLessons}",
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 10,
                            color: Colors.white60,
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

  IconData _getCourseIcon(String category) {
    switch (category) {
      case 'Innovation':
        return Icons.lightbulb_outline;
      case 'Strategy':
        return Icons.hub_outlined;
      case 'Growth':
        return Icons.trending_up_outlined;
      default:
        return Icons.school_outlined;
    }
  }

  Widget _buildHolographicProjectCard() {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF1A1A2E),
                const Color(0xFF16213E).withOpacity(0.9),
              ],
            ),
            border: Border.all(
              color: const Color(0xFF7B2CBF).withOpacity(0.4),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(
                  0xFF7B2CBF,
                ).withOpacity(_glowAnimation.value * 0.2),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Opening ${_userProject.name}..."),
                    backgroundColor: const Color(0xFF7B2CBF),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF7B2CBF), Color(0xFF00D4FF)],
                            ),
                          ),
                          child: const Icon(
                            Icons.rocket_launch_outlined,
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
                                _userProject.name,
                                style: const TextStyle(
                                  fontFamily: 'Orbitron',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: _getStatusColor(_userProject.status),
                                ),
                                child: Text(
                                  _userProject.status,
                                  style: const TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Next Mission:",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _userProject.nextStep,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              Container(
                                height: 6,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: Colors.white.withOpacity(0.2),
                                ),
                              ),
                              Container(
                                height: 6,
                                width:
                                    (MediaQuery.of(context).size.width - 80) *
                                    _userProject.progress,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF7B2CBF),
                                      Color(0xFF00D4FF),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "${(_userProject.progress * 100).toInt()}%",
                          style: const TextStyle(
                            fontFamily: 'Orbitron',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF7B2CBF),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Deadline",
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 11,
                                color: Colors.white.withOpacity(0.6),
                              ),
                            ),
                            Text(
                              "${_userProject.deadline.day}/${_userProject.deadline.month}/${_userProject.deadline.year}",
                              style: const TextStyle(
                                fontFamily: 'Orbitron',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Wrap(
                          spacing: 4,
                          children:
                              _userProject.tags.map((tag) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: const Color(
                                        0xFF7B2CBF,
                                      ).withOpacity(0.5),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    tag,
                                    style: const TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 9,
                                      color: Color(0xFF7B2CBF),
                                    ),
                                  ),
                                );
                              }).toList(),
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Critical':
        return const Color(0xFFFF3366);
      case 'Active':
        return const Color(0xFF00D4FF);
      case 'Completed':
        return const Color(0xFF00FF88);
      default:
        return const Color(0xFF7B2CBF);
    }
  }

  Widget _buildInspirationHologram() {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF0F3460).withOpacity(0.8),
                const Color(0xFF1A1A2E).withOpacity(0.6),
              ],
            ),
            border: Border.all(
              color: const Color(0xFF00F5FF).withOpacity(0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(
                  0xFF00F5FF,
                ).withOpacity(_glowAnimation.value * 0.2),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00F5FF), Color(0xFF0080FF)],
                      ),
                    ),
                    child: const Icon(
                      Icons.auto_awesome_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Neural Insight",
                          style: TextStyle(
                            fontFamily: 'Orbitron',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          _dailyTip.category,
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 12,
                            color: Color(0xFF00F5FF),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                '"${_dailyTip.quote}"',
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "— ${_dailyTip.author}",
                  style: const TextStyle(
                    fontFamily: 'Orbitron',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF00F5FF),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuantumQuickAccess() {
    final quickAccessItems = [
      {
        'icon': Icons.people_alt_outlined,
        'title': 'Neural Network',
        'subtitle': 'Connect & Collaborate',
        'color': const Color(0xFF00D4FF),
        'bgColor': const Color(0xFF1A1A2E),
      },
      {
        'icon': Icons.psychology_outlined,
        'title': 'AI Mentors',
        'subtitle': 'Quantum Guidance',
        'color': const Color(0xFF7B2CBF),
        'bgColor': const Color(0xFF16213E),
      },
      {
        'icon': Icons.explore_outlined,
        'title': 'Discovery Lab',
        'subtitle': 'Future Insights',
        'color': const Color(0xFF00FF88),
        'bgColor': const Color(0xFF0F3460),
      },
      {
        'icon': Icons.leaderboard_outlined,
        'title': 'Quantum Ranks',
        'subtitle': 'Global Leaderboard',
        'color': const Color(0xFFFF6B35),
        'bgColor': const Color(0xFF1A1A2E),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.1,
      ),
      itemCount: quickAccessItems.length,
      itemBuilder: (context, index) {
        final item = quickAccessItems[index];
        return _buildQuantumQuickAccessCard(
          icon: item['icon'] as IconData,
          title: item['title'] as String,
          subtitle: item['subtitle'] as String,
          color: item['color'] as Color,
          bgColor: item['bgColor'] as Color,
          index: index,
        );
      },
    );
  }

  Widget _buildQuantumQuickAccessCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Color bgColor,
    required int index,
  }) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [bgColor, bgColor.withOpacity(0.8)],
            ),
            border: Border.all(color: color.withOpacity(0.3), width: 1),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(_glowAnimation.value * 0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Accessing $title..."),
                    backgroundColor: color,
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          colors: [color, color.withOpacity(0.7)],
                        ),
                      ),
                      child: Icon(icon, color: Colors.white, size: 24),
                    ),
                    const Spacer(),
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Orbitron',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 12,
                        color: color,
                      ),
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

  Widget _buildQuantumFAB() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.95 + (_pulseController.value * 0.1),
          child: FloatingActionButton.extended(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Initiating quantum scan..."),
                  backgroundColor: Color(0xFF00D4FF),
                ),
              );
            },
            backgroundColor: const Color(0xFF00D4FF),
            foregroundColor: Colors.black,
            elevation: 8,
            icon: AnimatedBuilder(
              animation: _glowController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _glowController.value * 2 * math.pi,
                  child: const Icon(Icons.radar_outlined, size: 24),
                );
              },
            ),
            label: const Text(
              "Quantum Scan",
              style: TextStyle(
                fontFamily: 'Orbitron',
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        );
      },
    );
  }
}


