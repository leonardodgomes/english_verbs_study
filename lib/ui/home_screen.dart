import 'package:flutter/material.dart';
import '../state/quiz_notifier.dart';
import '../state/vocab_notifier.dart';
import '../data/vocab_model.dart';
import 'quiz_screen.dart';
import 'vocab_screen.dart';

class HomeScreen extends StatelessWidget {
  final DynamicQuizNotifier quizNotifier;
  final List<VocabularyItem> vocabularyList;

  const HomeScreen({
    super.key, 
    required this.quizNotifier, 
    required this.vocabularyList,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DynamicQuizState>(
      valueListenable: quizNotifier,
      builder: (context, state, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('English Study Hub'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(state.isDarkMode ? Icons.light_mode : Icons.dark_mode),
                onPressed: () => quizNotifier.toggleTheme(),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome Back!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Verbs Top Streak: 🏆 ${state.highestStreak}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 40),
                Card(
                  elevation: 2,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizScreen(quizNotifier: quizNotifier),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: const Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Row(
                        children: [
                          Icon(Icons.translate, size: 40, color: Colors.indigo),
                          SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Verb Tense Mastery', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                SizedBox(height: 4),
                                Text('Practice Past, Participles, and Gerund forms.', style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 2,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VocabScreen(
                            vocabNotifier: VocabQuizNotifier(vocabularyList, quizNotifier.prefsInstance),
                          ),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: const Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Row(
                        children: [
                          Icon(Icons.edit_note, size: 40, color: Colors.orange),
                          SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Word Writer Quiz', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                SizedBox(height: 4),
                                Text('Identify object icons and type the matching English terms.', style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
