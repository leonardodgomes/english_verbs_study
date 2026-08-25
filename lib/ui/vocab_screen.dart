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
      case 'flight': return Icons.flight;
      case 'train': return Icons.train;
      case 'computer': return Icons.computer;
      case 'phone_android': return Icons.phone_android;
      case 'key': return Icons.key;
      case 'nature': return Icons.nature;
      case 'wb_sunny': return Icons.wb_sunny;
      case 'dark_mode': return Icons.dark_mode;
      case 'photo_camera': return Icons.photo_camera;
      case 'watch_later': return Icons.watch_later;
      case 'cake': return Icons.cake;
      case 'coffee': return Icons.coffee;
      case 'water_drop': return Icons.water_drop;
      case 'chair': return Icons.chair;
      case 'bed': return Icons.bed;
      case 'school': return Icons.school;
      case 'store': return Icons.store;
      case 'music_note': return Icons.music_note;
      case 'favorite': return Icons.favorite;
      case 'star': return Icons.star;
      case 'cloud': return Icons.cloud;
      case 'umbrella': return Icons.umbrella;
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
                const SizedBox(height: 40),
                Icon(
                  _getIconData(item.iconName),
                  size: 100,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 20),
                Text(
                  item.hint,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 30),

                // NEW: Dynamic Correction Banner Feedback Card
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
                        'Oops! The correct word was: ${state.revealCorrection}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.red.shade900,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

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
