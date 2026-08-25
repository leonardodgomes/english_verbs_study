class VocabularyItem {
  final String word;
  final String hint;
  final String iconName;
  final String category; // Novo campo adicionado

  VocabularyItem({
    required this.word,
    required this.hint,
    required this.iconName,
    required this.category, // Adicionado ao construtor
  });

  factory VocabularyItem.fromJson(Map<String, dynamic> json) {
    return VocabularyItem(
      word: json['word'],
      hint: json['hint'],
      iconName: json['iconName'] ?? 'help_outline',
      category: json['category'] ?? 'General', // Fallback caso alguma esteja vazia
    );
  }
}
