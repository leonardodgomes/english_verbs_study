import 'package:flutter/material.dart';
import '../state/data_eng_notifier.dart';

class DataEngScreen extends StatelessWidget {
  final DataEngQuizNotifier notifier;

  const DataEngScreen({super.key, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Architecture Match'),
      ),
      body: ValueListenableBuilder<DataEngQuizState>(
        valueListenable: notifier,
        builder: (context, state, child) {
          final item = state.currentItem;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Score: ${state.score}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const Icon(Icons.hub, size: 32, color: Colors.teal),
                  ],
                ),
                const SizedBox(height: 25),

                // PAINEL DE FEEDBACK EXPLICATIVO DINÂMICO
                if (state.lastExplanation != null) ...[
                  Card(
                    color: state.lastAnswerWasCorrect == true ? Colors.green.shade50 : Colors.red.shade50,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: state.lastAnswerWasCorrect == true ? Colors.green.shade200 : Colors.red.shade200,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                state.lastAnswerWasCorrect == true ? Icons.check_circle : Icons.error,
                                color: state.lastAnswerWasCorrect == true ? Colors.green : Colors.red,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                state.lastAnswerWasCorrect == true ? 'Correct Engineering Idea!' : 'Incorrect Choice!',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold, 
                                  color: state.lastAnswerWasCorrect == true ? Colors.green.shade900 : Colors.red.shade900,
                                  fontSize: 16
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.lastExplanation!,
                            style: TextStyle(
                              fontSize: 15,
                              color: state.lastAnswerWasCorrect == true ? Colors.green.shade900 : Colors.red.shade900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // ÁREA DO CENÁRIO ATUAL
                const Text(
                  'Scenario Pipeline Challenge:',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                const SizedBox(height: 6),
                Text(
                  item.scenario,
                  style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 35),

                // LISTA DE OPÇÕES
                ...state.currentOptions.map((option) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: FilledButton.tonal(
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical:16),
                      ),
                      onPressed: () => notifier.submitChoice(option),
                      child: Text(option, style: const TextStyle(fontSize: 17), textAlign: TextAlign.center),
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}
