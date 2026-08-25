import 'package:flutter/material.dart';
import '../state/quiz_notifier.dart';

class QuizScreen extends StatefulWidget {
  final DynamicQuizNotifier quizNotifier;

  const QuizScreen({super.key, required this.quizNotifier});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final TextEditingController _verbController = TextEditingController();

  void _submitText() {
    if (_verbController.text.isEmpty) return;
    widget.quizNotifier.submitAnswer(_verbController.text);
    _verbController.clear(); // Flush input slot for the next verb prompt cycle
  }

  @override
  void dispose() {
    _verbController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verb Grammar Quiz'),
        backgroundColor: Colors.indigo.shade100,
        centerTitle: true,
      ),
      body: ValueListenableBuilder<DynamicQuizState>(
        valueListenable: widget.quizNotifier,
        builder: (context, state, child) {
          final question = state.currentQuestion;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Mini Dashboard Panel
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
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.indigo),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('🔥 Streak: ${state.streak}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
                            Text('🏆 Best: ${state.highestStreak}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 35),
                
                // Question text
                Text(
                  question.questionText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 35),

                // Dynamic Wrong Correction Feedback Box
                if (state.revealCorrection != null) ...[
                  Card(
                    color: Colors.red.shade50,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.red.shade200),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        'Correction: The accurate target form was "${state.revealCorrection}"',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red.shade900, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                ],

                // Input Keyboard text area component field box
                TextField(
                  controller: _verbController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Type out the solution...',
                    hintText: 'Keep capitalization rules relaxed.',
                  ),
                  onSubmitted: (_) => _submitText(),
                ),
                const SizedBox(height: 20),

                FilledButton(
                  onPressed: _submitText,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Submit Answer', style: TextStyle(fontSize: 18)),
                ),
                
                const SizedBox(height: 20),
                const Divider(),
                
                // History Feed Section
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
