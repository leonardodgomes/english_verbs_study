import 'package:flutter/material.dart';
import '../state/quiz_notifier.dart';

class QuizScreen extends StatelessWidget {
  final DynamicQuizNotifier quizNotifier;

  const QuizScreen({super.key, required this.quizNotifier});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('English Verbs Study'),
        backgroundColor: Colors.indigo.shade100,
        centerTitle: true,
      ),
      body: ValueListenableBuilder<DynamicQuizState>(
        valueListenable: quizNotifier,
        builder: (context, state, child) {
          final question = state.currentQuestion;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Streamlined Dashboard Card
                Card(
                  color: Colors.indigo.shade50,
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Score: ${state.score}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.indigo),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              '🔥 Streak: ${state.streak}',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.orange),
                            ),

                            Text(
                              '🏆 Best: ${state.highestStreak}',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.amber),
                            ),

                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  question.questionText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 30),
                ...question.options.map((option) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: FilledButton.tonal(
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () => quizNotifier.submitAnswer(option),
                      child: Text(option, style: const TextStyle(fontSize: 18)),
                    ),
                  );
                }),
                const SizedBox(height: 20),
                const Divider(),
                if (state.history.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Text(
                      'Recent Activity',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ...state.history.map((entry) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      color: entry.isCorrect ? Colors.green.shade50 : Colors.red.shade50,
                      child: ListTile(
                        leading: Icon(
                          entry.isCorrect ? Icons.check_circle : Icons.cancel,
                          color: entry.isCorrect ? Colors.green : Colors.red,
                        ),
                        title: Text('${entry.verbInfinitive} (${entry.userAnswer})'),
                        subtitle: Text(
                          entry.isCorrect 
                              ? 'Correct!' 
                              : 'Incorrect. Answer was: ${entry.correctAnswer}',
                          style: TextStyle(
                            color: entry.isCorrect ? Colors.green.shade900 : Colors.red.shade900,
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

// Fallback color configurations for compile targets
extension on Colors {
  static const orangeDeep = Colors.orange;
  static const amberValues = Colors.amber;
}
