import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/verb_model.dart';
import 'question_engine.dart';

class DynamicQuizState {
  final int score;
  final int streak;
  final int highestStreak;
  final DynamicQuestion currentQuestion;
  final List<HistoryEntry> history;

  DynamicQuizState({
    required this.score,
    required this.streak,
    required this.highestStreak,
    required this.currentQuestion,
    required this.history,
  });
}

class DynamicQuizNotifier extends ValueNotifier<DynamicQuizState> {
  final List<Verb> _verbs;
  final SharedPreferences _prefs; // Changed to traditional class

  DynamicQuizNotifier(this._verbs, this._prefs)
      : super(DynamicQuizState(
          score: 0,
          streak: 0,
          // Read the saved best score using traditional getInt
          highestStreak: _prefs.getInt('highest_streak_key') ?? 0,
          currentQuestion: DynamicQuestion.generate(_pickVerbByWeight(_verbs), _verbs),
          history: [],
        ));

  static Verb _pickVerbByWeight(List<Verb> verbs) {
    int totalWeight = verbs.fold(0, (sum, item) => sum + item.weight);
    int randomValue = Random().nextInt(totalWeight);
    int currentSum = 0;
    for (var verb in verbs) {
      currentSum += verb.weight;
      if (randomValue < currentSum) return verb;
    }
    return verbs.first;
  }

  void submitAnswer(String selectedAnswer) {
    final currentQuestion = value.currentQuestion;
    final activeVerb = currentQuestion.verb;
    
    int newScore = value.score;
    int newStreak = value.streak;
    int newHighestStreak = value.highestStreak;
    bool isCorrect = selectedAnswer == currentQuestion.correctAnswer;

    if (isCorrect) {
      newScore += 1;
      newStreak += 1;
      
      if (newStreak > newHighestStreak) {
        newHighestStreak = newStreak;
        // Save using traditional asynchronous setter
        _prefs.setInt('highest_streak_key', newHighestStreak);
      }
      
      if (activeVerb.weight > 1) activeVerb.weight -= 1;
    } else {
      newScore -= 1;
      newStreak = 0;
      activeVerb.weight += 3;
    }

    final newEntry = HistoryEntry(
      verbInfinitive: activeVerb.infinitive,
      questionText: currentQuestion.questionText,
      userAnswer: selectedAnswer,
      correctAnswer: currentQuestion.correctAnswer,
      isCorrect: isCorrect,
    );

    List<HistoryEntry> updatedHistory = List.from(value.history);
    updatedHistory.insert(0, newEntry);
    if (updatedHistory.length > 5) updatedHistory.removeLast();

    Verb nextVerb = _pickVerbByWeight(_verbs);
    
    value = DynamicQuizState(
      score: newScore,
      streak: newStreak,
      highestStreak: newHighestStreak,
      currentQuestion: DynamicQuestion.generate(nextVerb, _verbs),
      history: updatedHistory,
    );
  }
}
