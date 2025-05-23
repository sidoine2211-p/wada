
import 'package:flutter/material.dart';

class AssistantSheet extends StatelessWidget {
  final String? initialPrompt;
  final String title;

  const AssistantSheet({
    super.key,
    this.initialPrompt,
    this.title = 'Assistant IA', // Default title
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController _textEditingController = TextEditingController(text: initialPrompt);

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFFFFFFF),
              const Color(0xFFF8FAFC),
            ],
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          border: Border.all(
            color: const Color(0xFF00D4FF).withOpacity(0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00D4FF).withOpacity(0.15),
              blurRadius: 30,
              offset: const Offset(0, -10),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 70,
                height: 6,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF00D4FF),
                      const Color(0xFF3B82F6),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF00D4FF).withOpacity(0.15),
                        const Color(0xFF3B82F6).withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: const Color(0xFF00D4FF).withOpacity(0.3),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00D4FF).withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.auto_awesome_outlined,
                    color: Color(0xFF1E40AF),
                    size: 26,
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Orbitron',
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: const Icon(
                        Icons.close,
                        color: Color(0xFF64748B),
                        size: 26,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              'Comment puis-je vous aider aujourd\'hui ?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF475569),
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView(
                controller: controller,
                children: [
                  _buildSuggestionButton(
                    context,
                    'Aide-moi à définir mon idée de projet',
                    const Color(0xFF1E40AF),
                  ),
                  _buildSuggestionButton(
                    context,
                    'Comment créer un MVP ?',
                    const Color(0xFF7C3AED),
                  ),
                  _buildSuggestionButton(
                    context,
                    'Trouve-moi un mentor en marketing',
                    const Color(0xFF059669),
                  ),
                  _buildSuggestionButton(
                    context,
                    'Génère un business model canvas',
                    const Color(0xFFDC2626),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: const Color(0xFF00D4FF).withOpacity(0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00D4FF).withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: TextField(
                controller: _textEditingController,
                style: const TextStyle(
                  color: Color(0xFF1E293B),
                  fontFamily: 'Roboto',
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  hintText: 'Posez votre question...',
                  hintStyle: TextStyle(
                    color: const Color(0xFF64748B).withOpacity(0.7),
                    fontFamily: 'Roboto',
                  ),
                  fillColor: Colors.transparent,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 18,
                  ),
                  suffixIcon: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00D4FF), Color(0xFF3B82F6)],
                      ),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00D4FF).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(22),
                        onTap: () {
                          // Simulate sending message to AI
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Envoi à l\'IA: "${_textEditingController.text}"'),
                              backgroundColor: Colors.blueAccent,
                            ),
                          );
                          _textEditingController.clear();
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionButton(BuildContext context, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Simulate AI response based on suggestion
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Demande envoyée à l\'IA: "$text"'),
                backgroundColor: color,
              ),
            );
          },
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 22),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: color.withOpacity(0.3), width: 1.5),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1E293B),
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.arrow_forward,
                    color: color,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}