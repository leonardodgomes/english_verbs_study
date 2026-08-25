class DataEngItem {
  final String scenario;
  final String correctAnswer;
  final List<String> distractors;
  final String explanation; // Novo campo mapeado

  DataEngItem({
    required this.scenario,
    required this.correctAnswer,
    required this.distractors,
    required this.explanation,
  });

  factory DataEngItem.fromJson(Map<String, dynamic> json) {
    return DataEngItem(
      scenario: json['scenario'],
      correctAnswer: json['correctAnswer'],
      distractors: List<String>.from(json['distractors']),
      explanation: json['explanation'] ?? 'No extra technical description available.',
    );
  }

  List<String> getShuffledOptions() {
    List<String> options = [correctAnswer, ...distractors];
    options.shuffle();
    return options;
  }
}
