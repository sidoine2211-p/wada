
import 'package:flutter/material.dart';
import 'package:wada/screens/homescreen.dart';
import 'package:wada/screens/learning_screen.dart';
import 'package:wada/screens/project_screen.dart'; // NEW: Import ProjectScreen
import 'package:wada/widgets/assistant_sheet.dart'; // NEW: Import AssistantSheet from widgets folder

// Placeholder screens for other tabs (you might have these in separate files)
class NetworkScreen extends StatelessWidget {
  const NetworkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF).withOpacity(0.95),
        elevation: 0,
        title: const Text(
          'Réseau & Collaboration',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Orbitron',
            color: Color(0xFF1E293B),
          ),
        ),
        centerTitle: false,
      ),
      body: Center(
        child: Text(
          'Communauté',
          style: TextStyle(
            color: const Color(0xFF059669),
            fontSize: 24,
            fontFamily: 'Orbitron',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF).withOpacity(0.95),
        elevation: 0,
        title: const Text(
          'Profil',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Orbitron',
            color: Color(0xFF1E293B),
          ),
        ),
        centerTitle: false,
      ),
      body: Center(
        child: Text(
          'Page de profil',
          style: TextStyle(
            color: const Color(0xFF1E40AF),
            fontSize: 24,
            fontFamily: 'Orbitron',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class WadaBottomNavigation extends StatefulWidget {
  const WadaBottomNavigation({super.key});

  @override
  State<WadaBottomNavigation> createState() => _WadaBottomNavigationState();
}

class _WadaBottomNavigationState extends State<WadaBottomNavigation> {
  int _selectedIndex = 0;

  // Pages qui seront affichées selon l'onglet sélectionné
  static final List<Widget> _pages = [
    const HomeScreen(),
    const LearningScreen(),
    const ProjectScreen(), // Use the new ProjectScreen
    const NetworkScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFF8FAFC), // Blanc très doux
              const Color(0xFFE2E8F0), // Gris très clair
              const Color(0xFFCBD5E1), // Gris clair
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        child: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00D4FF).withOpacity(0.15),
              blurRadius: 30,
              spreadRadius: 0,
              offset: const Offset(0, -8),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              spreadRadius: 0,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFFFFFFFF), // Blanc pur
                  const Color(0xFFF8FAFC), // Blanc très légèrement teinté
                ],
              ),
              border: Border(
                top: BorderSide(
                  color: const Color(0xFF00D4FF).withOpacity(0.25),
                  width: 2,
                ),
              ),
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              selectedItemColor: const Color(0xFF1E40AF), // Bleu plus foncé pour contraste
              unselectedItemColor: const Color(0xFF64748B), // Gris moderne
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 11,
                fontFamily: 'Orbitron',
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 10,
                fontFamily: 'Roboto',
              ),
              type: BottomNavigationBarType.fixed,
              currentIndex: _selectedIndex,
              elevation: 0,
              onTap: _onItemTapped,
              items: [
                _buildNavItem(Icons.home_rounded, 'Accueil', 0),
                _buildNavItem(Icons.school_rounded, 'Apprendre', 1),
                _buildNavItem(Icons.rocket_launch_rounded, 'Projet', 2),
                _buildNavItem(Icons.people_alt_rounded, 'Réseau', 3),
                _buildNavItem(Icons.person_rounded, 'Profil', 4),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00D4FF).withOpacity(0.4),
              blurRadius: 25,
              spreadRadius: 3,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              spreadRadius: 1,
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            // Action pour ouvrir l'assistant IA ou le coach
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => const AssistantSheet(), // Use the new AssistantSheet
            );
          },
          backgroundColor: const Color(0xFF00D4FF),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: const Icon(
            Icons.chat_bubble_outline,
            size: 28,
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;

    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: isSelected
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF00D4FF).withOpacity(0.15),
                    const Color(0xFF3B82F6).withOpacity(0.1),
                  ],
                ),
                border: Border.all(
                  color: const Color(0xFF00D4FF).withOpacity(0.4),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00D4FF).withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              )
            : null,
        child: Icon(
          icon,
          size: isSelected ? 28 : 24,
        ),
      ),
      label: label,
    );
  }
}