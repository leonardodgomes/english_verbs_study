import 'dart:math';
import '../data/verb_model.dart';

enum TenseTarget { pastSimple, pastParticiple, gerund }

class DynamicQuestion {
  final Verb verb;
  final String questionText;
  final String correctAnswer;

  DynamicQuestion({
    required this.verb,
    required this.questionText,
    required this.correctAnswer,
  });

  factory DynamicQuestion.generate(Verb targetVerb, List<Verb> allVerbs) {
    final random = Random();
    final chosenTense = TenseTarget.values[random.nextInt(TenseTarget.values.length)];

    String questionText = '';
    String correctAnswer = '';

    switch (chosenTense) {
      case TenseTarget.pastSimple:
        questionText = 'Type the PAST SIMPLE of "${targetVerb.infinitive}":';
        correctAnswer = targetVerb.pastSimple;
        break;
      case TenseTarget.pastParticiple:
        questionText = 'Type the PAST PARTICIPLE of "${targetVerb.infinitive}":';
        correctAnswer = targetVerb.pastParticiple;
        break;
      case TenseTarget.gerund:
        questionText = 'Type the GERUND (-ing form) of "${targetVerb.infinitive}":';
        correctAnswer = targetVerb.gerund;
        break;
    }

    return DynamicQuestion(
      verb: targetVerb,
      questionText: questionText,
      correctAnswer: correctAnswer,
    );
  }
}

class HistoryEntry {
  final String verbInfinitive;
  final String questionText;
  final String userAnswer;
  final String correctAnswer;
  final bool isCorrect;

  HistoryEntry({
    required this.verbInfinitive,
    required this.questionText,
    required this.userAnswer,
    required this.correctAnswer,
    required this.isCorrect,
  });
}
