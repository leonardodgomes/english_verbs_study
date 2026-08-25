import 'package:flutter/material.dart';
import '../state/quiz_notifier.dart';
import '../state/vocab_notifier.dart';
import '../state/data_eng_notifier.dart';
import '../data/vocab_model.dart';
import '../data/data_eng_model.dart';
import 'quiz_screen.dart';
import 'vocab_screen.dart';
import 'data_eng_screen.dart';
import 'stats_screen.dart';

class HomeScreen extends StatefulWidget {
  final DynamicQuizNotifier quizNotifier;
  final List<VocabularyItem> vocabularyList;
  final List<DataEngItem> dataEngList;

  const HomeScreen({
    super.key, 
    required this.quizNotifier, 
    required this.vocabularyList,
    required this.dataEngList,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final VocabQuizNotifier _vocabNotifier;
  late final DataEngQuizNotifier _dataEngNotifier;

  @override
  void initState() {
    super.initState();
    _vocabNotifier = VocabQuizNotifier(widget.vocabularyList, widget.quizNotifier.prefsInstance);
    _dataEngNotifier = DataEngQuizNotifier(widget.dataEngList, widget.quizNotifier.prefsInstance);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DynamicQuizState>(
      valueListenable: widget.quizNotifier,
      builder: (context, verbState, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('English Study Hub'),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.analytics_outlined),
              tooltip: 'View Mistakes Analytics',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StatsScreen(
                      quizNotifier: widget.quizNotifier,
                      vocabNotifier: _vocabNotifier,
                      dataEngNotifier: _dataEngNotifier,
                    ),
                  ),
                ).then((_) {
                  setState(() {});
                });
              },
            ),
            actions: [
              IconButton(
                icon: Icon(verbState.isDarkMode ? Icons.light_mode : Icons.dark_mode),
                onPressed: () => widget.quizNotifier.toggleTheme(),
              ),
            ],
          ),
          // CORREÇÃO: SingleChildScrollView colocado como NODE principal do Scaffold Body
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ValueListenableBuilder<VocabQuizState>(
                valueListenable: _vocabNotifier,
                builder: (context, vocabState, child) {
                  return ValueListenableBuilder<DataEngQuizState>(
                    valueListenable: _dataEngNotifier,
                    builder: (context, dataEngState, child) {
                      return Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          // CORREÇÃO: Força a coluna a ocupar apenas o tamanho real dos seus filhos
                          mainAxisSize: MainAxisSize.min, 
                          children: [
                            const Text(
                              'Welcome Back!',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 20),

                            Center(
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                    image: const DecorationImage(
                                      image: AssetImage('assets/leo_avatar.png'), // Nome exato do teu ficheiro
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),


                            // Painel de Recordes
                            Card(
                              elevation: 0,
                              color: verbState.isDarkMode ? Colors.grey.shade900 : Colors.grey.shade100,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: Colors.grey.withOpacity(0.2)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.emoji_events, color: Colors.amber, size: 20),
                                        SizedBox(width: 8),
                                        Text('Personal Best Records', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                      ],
                                    ),
                                    const Divider(height: 24),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        _buildStatColumn('Verbs', verbState.highestStreak, Colors.indigo),
                                        _buildStatColumn('Vocab', vocabState.highestScore, Colors.orange),
                                        _buildStatColumn('Data Eng', dataEngState.highestScore, Colors.teal),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),

                            const Text(
                              'Select a Study Module:',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
                            ),
                            const SizedBox(height: 10),

                            // JOGO 1
                            _buildGameCard(
                              context: context,
                              title: 'Verb Tense Mastery',
                              subtitle: 'Type out Past, Participle, and Gerund formats with error-priority spacing.',
                              icon: Icons.translate,
                              iconColor: Colors.indigo,
                              destination: QuizScreen(quizNotifier: widget.quizNotifier),
                            ),
                            const SizedBox(height: 16),

                            // JOGO 2
                            _buildGameCard(
                              context: context,
                              title: 'Word Writer Quiz',
                              subtitle: 'Identify 30+ visual object icons and type the matching English definitions.',
                              icon: Icons.edit_note,
                              iconColor: Colors.orange,
                              destination: VocabScreen(vocabNotifier: _vocabNotifier),
                            ),
                            const SizedBox(height: 16),

                            // JOGO 3
                            _buildGameCard(
                              context: context,
                              title: 'Architecture Match',
                              subtitle: 'Test pipelines, distributed infrastructure tradeoffs, and cloud design models.',
                              icon: Icons.hub,
                              iconColor: Colors.teal,
                              destination: DataEngScreen(notifier: _dataEngNotifier),
                            ),
                            
                            // CORREÇÃO: Margem extra generosa no fundo para garantir que o terceiro bloco passa a barra de navegação do telemóvel
                            const SizedBox(height: 40), 
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatColumn(String label, int value, Color color) {
    return Column(
      children: [
        Text(
          '$value',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildGameCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Widget destination,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          ).then((_) {
            setState(() {});
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Icon(icon, size: 40, color: iconColor), // CORREÇÃO efetuada: iconColor aplicado
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}