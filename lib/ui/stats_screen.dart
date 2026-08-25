import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../state/quiz_notifier.dart';
import '../state/vocab_notifier.dart';
import '../state/data_eng_notifier.dart';

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
    // Acede às SharedPreferences através da nossa ponte pública
    final SharedPreferences prefs = quizNotifier.prefsInstance;
    
    // Remove todas as chaves de erros do telemóvel
    await prefs.remove('failed_verbs_key');
    await prefs.remove('failed_vocab_key');
    await prefs.remove('failed_data_eng_key');

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All metrics reset successfully! Please restart the app.')),
      );
      Navigator.pop(context); // Fecha a tela de estatísticas
    }
  }

  Widget _buildErrorList(String title, Map<String, int> errorMap, Color color) {
    if (errorMap.isEmpty) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          leading: const Icon(Icons.stars, color: Colors.green),
          title: Text('No mistakes in $title yet!'),
          subtitle: const Text('Keep up the flawless work.'),
        ),
      );
    }

    final sortedEntries = errorMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        ),
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
              'Historical logs stored on your device database. The engine pushes these items forward automatically.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),

            _buildErrorList('Verb Grammar Quiz', quizNotifier.value.failedVerbsCount, Colors.indigo),
            const SizedBox(height: 24),

            if (vocabNotifier != null)
              _buildErrorList('Word Writer Quiz', vocabNotifier!.value.failedWordsCount, Colors.orange),
            const SizedBox(height: 24),

            if (dataEngNotifier != null)
              _buildErrorList('Architecture Match', dataEngNotifier!.value.failedScenariosCount, Colors.teal),
          ],
        ),
      ),
    );
  }
}
