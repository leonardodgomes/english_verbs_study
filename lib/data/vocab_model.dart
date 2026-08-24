class VocabularyItem {
  final String word;
  final String hint;
  final String iconName;

  VocabularyItem({
    required this.word,
    required this.hint,
    required this.iconName,
  });

  factory VocabularyItem.fromJson(Map<String, dynamic> json) {
    return VocabularyItem(
      word: json['word'],
      hint: json['hint'],
      iconName: json['iconName'] ?? 'help_outline',
    );
  }
}
