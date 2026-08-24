class Verb {
  final String infinitive;
  final String pastSimple;
  final String pastParticiple;
  final String gerund;
  final bool isRegular;
  int weight;

  Verb({
    required this.infinitive,
    required this.pastSimple,
    required this.pastParticiple,
    required this.gerund,
    required this.isRegular,
    this.weight = 5,
  });

  factory Verb.fromJson(Map<String, dynamic> json) {
    return Verb(
      infinitive: json['infinitive'],
      pastSimple: json['pastSimple'],
      pastParticiple: json['pastParticiple'],
      gerund: json['gerund'],
      isRegular: json['isRegular'],
      weight: 5,
    );
  }
}
