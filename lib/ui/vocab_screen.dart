import 'package:flutter/material.dart';
import '../state/vocab_notifier.dart';

class VocabScreen extends StatefulWidget {
  final VocabQuizNotifier vocabNotifier;

  const VocabScreen({super.key, required this.vocabNotifier});

  @override
  State<VocabScreen> createState() => _VocabScreenState();
}

class _VocabScreenState extends State<VocabScreen> {
  final TextEditingController _controller = TextEditingController();

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'apple': return Icons.apple;
      case 'directions_car': return Icons.directions_car;
      case 'pets': return Icons.pets;
      case 'home': return Icons.home;
      case 'book': return Icons.book;
      case 'pedal_bike': return Icons.pedal_bike;
      default: return Icons.help_outline;
    }
  }

  void _submit() {
    if (_controller.text.isEmpty) return;
    widget.vocabNotifier.checkAnswer(_controller.text);
    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vocabulary Builder'),
      ),
      body: ValueListenableBuilder<VocabQuizState>(
        valueListenable: widget.vocabNotifier,
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
                    Text('🔥 Streak: ${state.score}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('🏆 Best: ${state.highestScore}', style: const TextStyle(fontSize: 18, color: Colors.amber, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 50),
                Icon(
                  _getIconData(item.iconName),
                  size: 100,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 30),
                Text(
                  item.hint,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'What is this called in English?',
                  ),
                  onSubmitted: (_) => _submit(),
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: _submit,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Check Word', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
