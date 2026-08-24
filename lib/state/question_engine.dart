import 'dart:math';
import '../data/verb_model.dart';

enum TenseTarget { pastSimple, pastParticiple, gerund }

class DynamicQuestion {
  final Verb verb;
  final String questionText;
  final String correctAnswer;
  final List<String> options;

  DynamicQuestion({
    required this.verb,
    required this.questionText,
    required this.correctAnswer,
    required this.options,
  });

  factory DynamicQuestion.generate(Verb targetVerb, List<Verb> allVerbs) {
    final random = Random();
    final chosenTense = TenseTarget.values[random.nextInt(TenseTarget.values.length)];

    String questionText = '';
    String correctAnswer = '';

    switch (chosenTense) {
      case TenseTarget.pastSimple:
        questionText = 'What is the PAST SIMPLE of "${targetVerb.infinitive}"?';
        correctAnswer = targetVerb.pastSimple;
        break;
      case TenseTarget.pastParticiple:
        questionText = 'What is the PAST PARTICIPLE of "${targetVerb.infinitive}"?';
        correctAnswer = targetVerb.pastParticiple;
        break;
      case TenseTarget.gerund:
        questionText = 'What is the GERUND (-ing form) of "${targetVerb.infinitive}"?';
        correctAnswer = targetVerb.gerund;
        break;
    }

    Set<String> wrongOptions = {};
    List<Verb> shuffledPool = List.from(allVerbs)..shuffle();
    
    for (var v in shuffledPool) {
      if (v.infinitive == targetVerb.infinitive) continue;
      
      if (chosenTense == TenseTarget.pastSimple) wrongOptions.add(v.pastSimple);
      if (chosenTense == TenseTarget.pastParticiple) wrongOptions.add(v.pastParticiple);
      if (chosenTense == TenseTarget.gerund) wrongOptions.add(v.gerund);
      
      if (wrongOptions.length >= 2) break;
    }

    while (wrongOptions.length < 2) {
      wrongOptions.add('${targetVerb.infinitive}ed'); 
    }

    List<String> combinedOptions = [correctAnswer, ...wrongOptions];
    combinedOptions.shuffle();

    return DynamicQuestion(
      verb: targetVerb,
      questionText: questionText,
      correctAnswer: correctAnswer,
      options: combinedOptions,
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
