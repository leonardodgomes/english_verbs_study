import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../state/quiz_notifier.dart';
import '../state/vocab_notifier.dart';
import '../state/data_eng_notifier.dart';
import 'quiz_screen.dart';
import 'vocab_screen.dart';

class StatsScreen extends StatelessWidget {
  final DynamicQuizNotifier quizNotifier;
  final VocabQuizNotifier? vocabNotifier;
  final DataEngQuizNotifier? dataEngNotifier;

  const StatsScreen({
    super.key,
    required this.quizNotifier,
    this.vocabNotifier,
    this.dataEngNotifier,
  });

  void _clearAllStats(BuildContext context) async {
    final SharedPreferences prefs = quizNotifier.prefsInstance;
    
    // 1. Limpa o armazenamento físico persistente do telemóvel
    await prefs.remove('failed_verbs_key');
    await prefs.remove('failed_vocab_key');
    await prefs.remove('failed_data_eng_key');

    // 2. CORREÇÃO DE PERSISTÊNCIA: Força a limpeza imediata na memória RAM ativa dos Notifiers
    quizNotifier.clearMetricsLocally();
    if (vocabNotifier != null) vocabNotifier!.clearMetricsLocally();
    if (dataEngNotifier != null) dataEngNotifier!.clearMetricsLocally();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All analytical metrics have been wiped instantly!')),
      );
      Navigator.pop(context); // Fecha a tela e regressa ao menu atualizado
    }
  }


  Widget _buildErrorList({
    required BuildContext context,
    required String title,
    required Map<String, int> errorMap,
    required Color color,
    required VoidCallback? onReviewPressed, // Nova ação para o botão de revisão
  }) {
    final sortedEntries = errorMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
            // Só exibe o botão se o utilizador tiver de facto erros cometidos nessa categoria
            if (errorMap.isNotEmpty && onReviewPressed != null)
              TextButton.icon(
                icon: const Icon(Icons.psychology, size: 18),
                label: const Text('Review Misses'),
                style: TextButton.styleFrom(foregroundColor: color),
                onPressed: onReviewPressed,
              ),
          ],
        ),
        if (errorMap.isEmpty)
          Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.stars, color: Colors.green),
              title: Text('No mistakes in $title yet!'),
              subtitle: const Text('Keep up the flawless work.'),
            ),
          )
        else
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(side: BorderSide(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(12)),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sortedEntries.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final entry = sortedEntries[index];
                return ListTile(
                  title: Text(entry.key, style: const TextStyle(fontWeight: FontWeight.w500)),
                  trailing: Chip(
                    backgroundColor: color.withOpacity(0.1),
                    label: Text('${entry.value} misses', style: TextStyle(color: color, fontWeight: FontWeight.bold)),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Performance Analytics'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever, color: Colors.red),
            tooltip: 'Reset Historical Mistakes',
            onPressed: () => _clearAllStats(context),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Global Error Ledger',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Click "Review Misses" to launch a focused session drilling only the questions you got wrong.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),

            // 1. REVISÃO DE VERBOS
            // 1. REVISÃO DE VERBOS
            _buildErrorList(
              context: context,
              title: 'Verb Grammar Quiz',
              errorMap: quizNotifier.value.failedVerbsCount,
              color: Colors.indigo,
              onReviewPressed: () {
                // CORREÇÃO: Remove o [] de dentro dos parênteses
                quizNotifier.loadWeakSpotsMode(); 
                Navigator.push(context, MaterialPageRoute(builder: (context) => QuizScreen(quizNotifier: quizNotifier)));
              },
            ),

            const SizedBox(height: 24),

            // 2. REVISÃO DE VOCABULÁRIO
            if (vocabNotifier != null)
              _buildErrorList(
                context: context,
                title: 'Word Writer Quiz',
                errorMap: vocabNotifier!.value.failedWordsCount,
                color: Colors.orange,
                onReviewPressed: () {
                  vocabNotifier!.loadWeakSpotsMode();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => VocabScreen(vocabNotifier: vocabNotifier!)));
                },
              ),
            const SizedBox(height: 24),

            // 3. REVISÃO DE ENGENHARIA DE DADOS (Apenas listagem de histórico, pois é múltipla escolha rotativa)
            if (dataEngNotifier != null)
              _buildErrorList(
                context: context,
                title: 'Architecture Match',
                errorMap: dataEngNotifier!.value.failedScenariosCount,
                color: Colors.teal,
                onReviewPressed: null, // Como Engenharia é múltipla escolha conceitual com 30 itens, a roleta de pesos nativa já resolve sozinha!
              ),
          ],
        ),
      ),
    );
  }
}
