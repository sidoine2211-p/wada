
import 'package:flutter/material.dart';
import 'package:wada/models/project.dart';

class TheWadaInvestScreen extends StatelessWidget {
  final UserProject project;

  const TheWadaInvestScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Soft white background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'The Wada Invest',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Orbitron',
            color: Color(0xFF1E293B),
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Icon(
                Icons.emoji_events_rounded,
                size: 80,
                color: const Color(0xFFFFA500), // Gold-like color
              ),
            ),
            const SizedBox(height: 24),
            Text(
              project.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Orbitron',
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              project.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
                color: const Color(0xFF475569),
              ),
            ),
            const SizedBox(height: 40),
            _buildSectionTitle('Votre Parcours de Projet'),
            const SizedBox(height: 20),
            // Iterate through completed project modules
            ...project.modules
                .where((m) => m.isCompleted)
                .map((module) => _buildProjectRecapCard(module))
                .toList(),
            if (project.modules.where((m) => m.isCompleted).isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Aucune étape de projet complétée pour le récapitulatif.',
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            const SizedBox(height: 40),
            _buildSectionTitle('Livrable Final Généré (Exemple)'),
            const SizedBox(height: 20),
            _buildGeneratedDeliverableCard(context, project.generatedDeliverable ?? 'Aucun livrable final généré pour le moment.'),
            const SizedBox(height: 40),
            _buildSectionTitle('Participer à "The Wada Invest" ?'),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Félicitations ! Votre projet est prêt à être présenté. "The Wada Invest" est une opportunité unique de rencontrer des investisseurs et d\'obtenir un accompagnement.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF475569),
                      fontFamily: 'Roboto',
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Simulate participation
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Votre candidature à "The Wada Invest" a été soumise ! Nous vous contacterons bientôt.'),
                            backgroundColor: Color(0xFF00D4FF),
                          ),
                        );
                        // Optionally, navigate back or to a confirmation screen
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00D4FF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 8,
                      ),
                      child: const Text(
                        'Participer à l\'événement !',
                        style: TextStyle(
                          fontFamily: 'Orbitron',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context); // Go back to project screen
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF1E40AF),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        side: const BorderSide(color: Color(0xFF1E40AF), width: 2),
                      ),
                      child: const Text(
                        'Non, merci, je veux revoir mon projet',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'Orbitron',
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 4,
          width: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF00D4FF),
                const Color(0xFF3B82F6),
              ],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _buildProjectRecapCard(ProjectModule module) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(module.icon, color: const Color(0xFF1E40AF), size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  module.title,
                  style: const TextStyle(
                    fontFamily: 'Orbitron',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
              const Icon(Icons.check_circle_rounded, color: Color(0xFF059669), size: 24),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            module.description,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              color: Color(0xFF475569),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Livrable : ${module.deliverableTemplate}',
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E40AF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneratedDeliverableCard(BuildContext context, String deliverableText) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF00D4FF).withOpacity(0.1),
            const Color(0xFF3B82F6).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF00D4FF).withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00D4FF).withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Livrable Final de votre Projet',
            style: TextStyle(
              fontFamily: 'Orbitron',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E40AF),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            deliverableText,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 15,
              color: Color(0xFF475569),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                // Simulate downloading/viewing the full deliverable
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Téléchargement du livrable en cours...'),
                    backgroundColor: Color(0xFF00D4FF),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E40AF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
              ),
              icon: const Icon(Icons.download_rounded, size: 20),
              label: const Text(
                'Voir le livrable complet',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}